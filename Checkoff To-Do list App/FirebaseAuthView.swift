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
    segmentedControl.addTarget(self, action: #selector(segmentedControlLogIn), for: .valueChanged)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    let segmentedControl = UISegmentedControl(items: ["Log In", "Register"])
    let label = UILabel()
    let emailField = UITextField()
    let passField = UITextField()
    var firstNameTF = UITextField()
    var lastNameTF = UITextField()
    let button = UIButton()
    
    
    
    @objc private func segmentedControlLogIn() {
        if segmentedControl.selectedSegmentIndex == 0 {
            firstNameTF.isHidden = true
            lastNameTF.isHidden = true
        }
        else {
            firstNameTF.isHidden = false
            lastNameTF.isHidden = false
        }
    }
    private func setupUserInputs() {
        segmentedControl.selectedSegmentIndex = 0
        backgroundColor = .white
        firstNameTF.isHidden = true
        lastNameTF.isHidden = true

        
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
        
        firstNameTF.placeholder = "First Name"
        firstNameTF.layer.borderWidth = 1
        firstNameTF.cornerRadius(radius: 8)
        firstNameTF.layer.borderColor = UIColor.black.cgColor
        firstNameTF.backgroundColor = .white
        firstNameTF.leftViewMode = .always
        firstNameTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        lastNameTF.placeholder = "Last Name"
        lastNameTF.layer.borderWidth = 1
        lastNameTF.cornerRadius(radius: 8)
        lastNameTF.layer.borderColor = UIColor.black.cgColor
        lastNameTF.backgroundColor = .white
        lastNameTF.leftViewMode = .always
        lastNameTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))

        button.backgroundColor = .systemGray4
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Continue", for: .normal)
        button.isUserInteractionEnabled = true
        button.cornerRadius(radius: 8)

        addAutoLayoutSubview(segmentedControl)
        addAutoLayoutSubview(button)
        addAutoLayoutSubview(passField)
        addAutoLayoutSubview(emailField)
        addAutoLayoutSubview(firstNameTF)
        addAutoLayoutSubview(lastNameTF)
//        addAutoLayoutSubview(label)
                
        NSLayoutConstraint.activate([
            
            segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -120),
            segmentedControl.widthAnchor.constraint(equalToConstant: 400),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30),
            
            emailField.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailField.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -80),
            emailField.widthAnchor.constraint(equalToConstant: 400),
            emailField.heightAnchor.constraint(equalToConstant: 30),

            passField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passField.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -40),
            passField.widthAnchor.constraint(equalToConstant: 400),
            passField.heightAnchor.constraint(equalToConstant: 30),
            
            firstNameTF.centerXAnchor.constraint(equalTo: centerXAnchor),
            firstNameTF.centerYAnchor.constraint(equalTo: centerYAnchor),
            firstNameTF.widthAnchor.constraint(equalToConstant: 400),
            firstNameTF.heightAnchor.constraint(equalToConstant: 30),

            lastNameTF.centerXAnchor.constraint(equalTo: centerXAnchor),
            lastNameTF.centerYAnchor.constraint(equalTo: centerYAnchor,constant: +40),
            lastNameTF.widthAnchor.constraint(equalToConstant: 400),
            lastNameTF.heightAnchor.constraint(equalToConstant: 30),

            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: +80),
            button.widthAnchor.constraint(equalToConstant: 400),
            button.heightAnchor.constraint(equalToConstant: 30),
            ])


    }
}
