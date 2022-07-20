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
        
        setUpStackView()
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
    let stackView = UIStackView()
    
    
    
    
    @objc private func segmentedControlLogIn() {
        if segmentedControl.selectedSegmentIndex == 0 {
            firstNameTF.isHidden = true
            lastNameTF.isHidden = true
            button.setTitle("Continue", for: .normal)
        }
        else {
            firstNameTF.isHidden = false
            lastNameTF.isHidden = false
            button.setTitle("Create Account", for: .normal)

        }
    }
    private func setupUserInputs() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.height(constant: 40)
        backgroundColor = .white
        firstNameTF.isHidden = true
        lastNameTF.isHidden = true
        
        
        emailField.placeholder = "Email Address"
        emailField.layer.borderWidth = 1
        emailField.autocapitalizationType = .none
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.backgroundColor = .white
        emailField.leftViewMode = .always
        emailField.height(constant: 40)
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailField.cornerRadius(radius: 8)
        
        
        passField.placeholder = "Password"
        passField.layer.borderWidth = 1
        passField.cornerRadius(radius: 8)
        passField.isSecureTextEntry = true
        passField.layer.borderColor = UIColor.black.cgColor
        passField.backgroundColor = .white
        passField.leftViewMode = .always
        passField.height(constant: 40)
        passField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        firstNameTF.placeholder = "First Name"
        firstNameTF.layer.borderWidth = 1
        firstNameTF.cornerRadius(radius: 8)
        firstNameTF.layer.borderColor = UIColor.black.cgColor
        firstNameTF.backgroundColor = .white
        firstNameTF.leftViewMode = .always
        firstNameTF.height(constant: 40)
        firstNameTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        lastNameTF.placeholder = "Last Name"
        lastNameTF.layer.borderWidth = 1
        lastNameTF.cornerRadius(radius: 8)
        lastNameTF.layer.borderColor = UIColor.black.cgColor
        lastNameTF.backgroundColor = .white
        lastNameTF.leftViewMode = .always
        lastNameTF.height(constant: 40)
        lastNameTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        button.backgroundColor = .systemGray4
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Continue", for: .normal)
        button.isUserInteractionEnabled = true
        button.cornerRadius(radius: 8)
        button.height(constant: 40)
    }
    private func setUpStackView(){
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.alignment = .fill
        stackView.spacing = 12
        stackView.cornerRadius(radius: 8)
        let view = UIView()
        stackView.addArrangedSubviews([segmentedControl, emailField, passField, firstNameTF, lastNameTF, button, view])
        addAutoLayoutSubview(stackView)
        stackView.fillSuperview()
        
    }
}
