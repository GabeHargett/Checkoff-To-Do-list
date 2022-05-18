//
//  FirebaseAuthViewController.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 5/16/22.
//

import UIKit
import Firebase

class FirebaseAuthView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    setupUserInputs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    let label = UILabel()
    let emailField = UITextField()
    let passField = UITextField()
    let button = UIButton()
    let signOutButton = UIButton()



    private func setupUserInputs() {
        backgroundColor = .systemPurple
        label.textAlignment = .center
        label.text = "Log In"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        
        emailField.placeholder = "Email Address"
        emailField.layer.borderWidth = 1
        emailField.autocapitalizationType = .none
        emailField.layer.borderColor = UIColor.systemGray4.cgColor
        emailField.backgroundColor = .white
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        passField.placeholder = "Password"
        passField.layer.borderWidth = 1
        passField.isSecureTextEntry = true
        passField.layer.borderColor = UIColor.systemGray4.cgColor
        passField.backgroundColor = .white
        passField.leftViewMode = .always
        passField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        button.backgroundColor = .systemGray4
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Continue", for: .normal)
        button.isUserInteractionEnabled = true
        
        signOutButton.backgroundColor = .systemGray4
        signOutButton.setTitleColor(.black, for: .normal)
        signOutButton.setTitle("Log Out", for: .normal)
        signOutButton.isUserInteractionEnabled = true

        
        addAutoLayoutSubview(button)
        addAutoLayoutSubview(passField)
        addAutoLayoutSubview(emailField)
        addAutoLayoutSubview(label)
        addAutoLayoutSubview(signOutButton)
                
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -120),
            label.widthAnchor.constraint(equalToConstant: 400),
            label.heightAnchor.constraint(equalToConstant: 25),
            
            emailField.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailField.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -80),
            emailField.widthAnchor.constraint(equalToConstant: 400),
            emailField.heightAnchor.constraint(equalToConstant: 25),

            passField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passField.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -40),
            passField.widthAnchor.constraint(equalToConstant: 400),
            passField.heightAnchor.constraint(equalToConstant: 25),

            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 400),
            button.heightAnchor.constraint(equalToConstant: 25),
            
            signOutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signOutButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 60),
            signOutButton.widthAnchor.constraint(equalToConstant: 400),
            signOutButton.heightAnchor.constraint(equalToConstant: 25),
            
        ])

    }
}
