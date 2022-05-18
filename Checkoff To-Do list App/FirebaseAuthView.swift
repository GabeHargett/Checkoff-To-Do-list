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


                
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 20),
            label.heightAnchor.constraint(equalToConstant: 20),
            
            emailField.rightAnchor.constraint(equalTo: rightAnchor,constant: -20),
            emailField.centerYAnchor.constraint(equalTo: centerYAnchor),
            emailField.widthAnchor.constraint(equalToConstant: 20),
            emailField.heightAnchor.constraint(equalToConstant: 20),

            passField.centerXAnchor.constraint(equalTo: centerXAnchor,constant: -40),
            passField.centerYAnchor.constraint(equalTo: centerYAnchor),
            passField.widthAnchor.constraint(equalToConstant: 20),
            passField.heightAnchor.constraint(equalToConstant: 20),

            button.centerXAnchor.constraint(equalTo: centerXAnchor,constant: -60),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 20),
            button.heightAnchor.constraint(equalToConstant: 20),
            
            signOutButton.centerXAnchor.constraint(equalTo: centerXAnchor,constant: -80),
            signOutButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            signOutButton.widthAnchor.constraint(equalToConstant: 20),
            signOutButton.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        addAutoLayoutSubview(button)
        addAutoLayoutSubview(passField)
        addAutoLayoutSubview(emailField)
        addAutoLayoutSubview(label)

    }
}
