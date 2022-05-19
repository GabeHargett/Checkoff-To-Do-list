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
        backgroundColor = .white
        label.textAlignment = .center
        label.text = "Log In"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.cornerRadius(radius: 8)

        
        emailField.placeholder = "Email Address"
        emailField.layer.borderWidth = 1
        emailField.autocapitalizationType = .none
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.backgroundColor = .white
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailField.cornerRadius(radius: 8)

        
        passField.placeholder = "Password"
        passField.layer.borderWidth = 1
        passField.cornerRadius(radius: 8)
        passField.isSecureTextEntry = true
        passField.layer.borderColor = UIColor.black.cgColor
        passField.backgroundColor = .white
        passField.leftViewMode = .always
        passField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        button.backgroundColor = .systemGray4
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Continue", for: .normal)
        button.isUserInteractionEnabled = true
        button.cornerRadius(radius: 8)


        addAutoLayoutSubview(button)
        addAutoLayoutSubview(passField)
        addAutoLayoutSubview(emailField)
        addAutoLayoutSubview(label)
                
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -120),
            label.widthAnchor.constraint(equalToConstant: 400),
            label.heightAnchor.constraint(equalToConstant: 30),
            
            emailField.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailField.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -80),
            emailField.widthAnchor.constraint(equalToConstant: 400),
            emailField.heightAnchor.constraint(equalToConstant: 30),

            passField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passField.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -40),
            passField.widthAnchor.constraint(equalToConstant: 400),
            passField.heightAnchor.constraint(equalToConstant: 30),

            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 400),
            button.heightAnchor.constraint(equalToConstant: 30),
            ])


    }
}
