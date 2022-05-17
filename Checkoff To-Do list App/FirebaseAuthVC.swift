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
        
        baseView.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    @objc private func didTapButton() {
        guard let email = baseView.emailField.text, !email.isEmpty,
              let password = baseView.passField.text, !password.isEmpty else {
                  print("Missing data")
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
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: {_ in
            
        }))

        present(alert, animated: true)
    }
}
