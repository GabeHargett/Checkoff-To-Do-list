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

    private func setupUserInputs() {

        label.textAlignment = .center
        label.text = "Log In"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        
        emailField.placeholder = "Email Address"
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.systemGray4.cgColor
        
        passField.placeholder = "Password"
        passField.layer.borderWidth = 1
        passField.isSecureTextEntry = true
        passField.layer.borderColor = UIColor.systemGray4.cgColor
        
        button.backgroundColor = .systemGray4
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Continue", for: .normal)
        button.isUserInteractionEnabled = true

        
        addAutoLayoutSubview(button)
        addAutoLayoutSubview(passField)
        addAutoLayoutSubview(emailField)
        addAutoLayoutSubview(label)
        
        NSLayoutConstraint.activate([
            label.rightAnchor.constraint(equalTo: rightAnchor,constant: -40),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 25),
            label.heightAnchor.constraint(equalToConstant: 25),
            
            emailField.rightAnchor.constraint(equalTo: rightAnchor,constant: -40),
            emailField.centerYAnchor.constraint(equalTo: centerYAnchor),
            emailField.widthAnchor.constraint(equalToConstant: 25),
            emailField.heightAnchor.constraint(equalToConstant: 25),

            passField.rightAnchor.constraint(equalTo: rightAnchor,constant: -40),
            passField.centerYAnchor.constraint(equalTo: centerYAnchor),
            passField.widthAnchor.constraint(equalToConstant: 25),
            passField.heightAnchor.constraint(equalToConstant: 25),

            button.rightAnchor.constraint(equalTo: rightAnchor,constant: -40),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 25),
            button.heightAnchor.constraint(equalToConstant: 25),

        ])
    }
}