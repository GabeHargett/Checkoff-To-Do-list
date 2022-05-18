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
    let signOutButton = UIButton()




    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            baseView.label.isHidden = true
            baseView.emailField.isHidden = true
            baseView.passField.isHidden = true
            baseView.button.isHidden = true
            
            baseView.signOutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)

        }
    }
    @objc private func logOutTapped() {
        do{
            try FirebaseAuth.Auth.auth().signOut()
            baseView.label.isHidden = false
            baseView.emailField.isHidden = false
            baseView.passField.isHidden = false
            baseView.button.isHidden = false
            
            baseView.signOutButton.removeFromSuperview()
        }
        catch{
           print("An error occurred")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser == nil {
            baseView.emailField.becomeFirstResponder()
        }
    }
    @objc private func didTapButton() {
        guard let email = baseView.emailField.text, !email.isEmpty,
              let password = baseView.passField.text, !password.isEmpty else {
                  print("Missing data")
                  if FirebaseAuth.Auth.auth().currentUser != nil {
                  let vc = HomeViewController()
                  navigationController?.pushViewController(vc, animated: true)
                      //lines 64-69 dont't work, after inputting a user and selecting the continue button, it glitches out the log out button making it unable to log out, and isn't able to push to HomeVC
                  }
                  return
              }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else{
                
                return
            }
            guard error == nil else{
                strongSelf.showCreateAccount(email: email, password: password)
                return
            }
            print("You have signed in")
            strongSelf.baseView.label.isHidden = true
            strongSelf.baseView.emailField.isHidden = true
            strongSelf.baseView.passField.isHidden = true
            strongSelf.baseView.button.isHidden = true
            strongSelf.baseView.emailField.resignFirstResponder()
            strongSelf.baseView.passField.resignFirstResponder()


        })
    }
    func showCreateAccount(email: String, password: String) {
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
                print("You have signed in")
                strongSelf.baseView.label.isHidden = true
                strongSelf.baseView.emailField.isHidden = true
                strongSelf.baseView.passField.isHidden = true
                strongSelf.baseView.button.isHidden = true
                strongSelf.baseView.emailField.resignFirstResponder()
                strongSelf.baseView.passField.resignFirstResponder()

            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: {_ in
            
        }))

        present(alert, animated: true)
    }
}
