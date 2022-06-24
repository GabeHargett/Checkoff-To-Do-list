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
    let button1 = UIButton()
    let button2 = UIButton()

    
    
    
    @objc private func segmentedControlLogIn() {
        if segmentedControl.selectedSegmentIndex == 0 {
            firstNameTF.isHidden = true
            lastNameTF.isHidden = true
            button2.isHidden = true
            button1.isHidden = false
        }
        else {
            firstNameTF.isHidden = false
            lastNameTF.isHidden = false
            button2.isHidden = false
            button1.isHidden = true
        }
    }
    private func setupUserInputs() {
        segmentedControl.selectedSegmentIndex = 0
        backgroundColor = .white
        firstNameTF.isHidden = true
        lastNameTF.isHidden = true
        button2.isHidden = true

        
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

        button1.backgroundColor = .systemGray4
        button1.setTitleColor(.black, for: .normal)
        button1.setTitle("Continue", for: .normal)
        button1.isUserInteractionEnabled = true
        button1.cornerRadius(radius: 8)
        
        button2.backgroundColor = .systemGray4
        button2.setTitleColor(.black, for: .normal)
        button2.setTitle("Continue", for: .normal)
        button2.isUserInteractionEnabled = true
        button2.cornerRadius(radius: 8)


        addAutoLayoutSubview(segmentedControl)
        addAutoLayoutSubview(button1)
        addAutoLayoutSubview(button2)
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
            
            button1.centerXAnchor.constraint(equalTo: centerXAnchor),
            button1.centerYAnchor.constraint(equalTo: centerYAnchor),
            button1.widthAnchor.constraint(equalToConstant: 400),
            button1.heightAnchor.constraint(equalToConstant: 30),

            lastNameTF.centerXAnchor.constraint(equalTo: centerXAnchor),
            lastNameTF.centerYAnchor.constraint(equalTo: centerYAnchor,constant: +40),
            lastNameTF.widthAnchor.constraint(equalToConstant: 400),
            lastNameTF.heightAnchor.constraint(equalToConstant: 30),

            button2.centerXAnchor.constraint(equalTo: centerXAnchor),
            button2.centerYAnchor.constraint(equalTo: centerYAnchor, constant: +80),
            button2.widthAnchor.constraint(equalToConstant: 400),
            button2.heightAnchor.constraint(equalToConstant: 30),
            ])


    }
}
