//
//  FirebaseAuthVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 5/16/22.
//

import UIKit
import Firebase


class FirebaseAuthVC: UIViewController {
    
    override func loadView() {
        view = baseView
    }
    
    let baseView = FirebaseAuthView()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true

        baseView.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser == nil {
            baseView.emailField.becomeFirstResponder()
        }
    }
    @objc private func didTapButton() {
        if baseView.segmentedControl.selectedSegmentIndex == 0 {
            signIn()
        }
        else{
            register()
        }
    }
    private func signIn() {
        guard let email = baseView.emailField.text, !email.isEmpty,
              let password = baseView.passField.text, !password.isEmpty
        else {
            print("Missing data")
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else{
                return
            }
            DispatchQueue.main.async {
                let vc = HomeViewController()
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                strongSelf.navigationItem.leftBarButtonItem = nil
                
            }
        })
    }
    private func register() {
        guard let email = baseView.emailField.text, !email.isEmpty,
              let password = baseView.passField.text, !password.isEmpty,
              let firstName = baseView.firstNameTF.text, !firstName.isEmpty,
              let lastName = baseView.lastNameTF.text, !lastName.isEmpty
        else {
            print("Missing data")
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else{
                return
            }
            guard error == nil else{
                let fullName = FullName(firstName: firstName, lastName: lastName)
                strongSelf.showCreateAccount(email: email, password: password, fullname: fullName)
                
                return
            }
            print("You have signed in")
            
            DispatchQueue.main.async {
                let vc = HomeViewController()
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                strongSelf.navigationItem.leftBarButtonItem = nil
                
            }
        })
    }
    func showCreateAccount(email: String, password: String, fullname: FullName) {
        let alert = UIAlertController(title: "Create Account",
                                      message: "Would you like to create an account",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue",
                                      style: .default,
                                      handler: {_ in
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
                guard let strongSelf = self else{
                    
                    return
                }
                guard error == nil else{
                    print("Account creation failed")
                    return
                }
                guard let result = result else {
                    return
                }
                let newUser = User(id: result.user.uid, fullName: fullname, dateJoined: Date().timeIntervalSince1970)
                FirebaseAPI.addUser(user: newUser)
                DispatchQueue.main.async {
                    let vc = HomeViewController()
                    strongSelf.navigationController?.pushViewController(vc, animated: true)
                    strongSelf.navigationItem.leftBarButtonItem = nil
                }
                print("You have signed in")
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: {_ in
            
        }))

        present(alert, animated: true)
    }
}

