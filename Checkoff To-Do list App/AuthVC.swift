//
//  FirebaseAuthVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 5/16/22.
//

import UIKit
import Firebase
import FirebaseMessaging


class FirebaseAuthVC: UIViewController {
    
    override func loadView() {
        view = baseView
    }
    
    let baseView = FirebaseAuthView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        Practice.startPractice()
        baseView.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupKeyboardObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc private func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.5
        let height = (keyboardFrame?.height) ?? 400
        let stackViewBottomWithConstant0 = baseView.stackView.frame.maxY - baseView.stackViewCenterContraint.constant
        let baseViewHeight = view.frame.height
        let overlap = (baseViewHeight - stackViewBottomWithConstant0) - height
        if overlap < 0 {
            UIView.animate(withDuration: keyboardDuration == 0 ? 0.1 : keyboardDuration, animations: {
                self.baseView.stackViewCenterContraint.constant = overlap - 10
                self.baseView.layoutIfNeeded()
            })
        }
        
    }
    
    @objc private func handleKeyboardWillHide(notification: NSNotification) {
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.5
        UIView.animate(withDuration: keyboardDuration, animations: {
            self.baseView.stackViewCenterContraint.constant = 0
            self.baseView.layoutIfNeeded()
        })
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
            let customAlert = ModalJesus(title: "Oops", description: "You forgot to include a username and/or password.")
            customAlert.addAction(ModalJesusAction(title: "Close", style: false))
            customAlert.showModal(vc: self)
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else{
                return
            }
            DispatchQueue.main.async {
                if let error = error {
                    let customAlert = ModalJesus(title: "Oops", description: "\(error.localizedDescription)")
                    customAlert.addAction(ModalJesusAction(title: "Close", style: false))
                    customAlert.showModal(vc: strongSelf)
                    return
                }
                FirebaseAPI.getUserGroups {groups in
                    if let groupID = groups?.first {
                        GroupManager.shared.setCurrentGroupID(groupID: groupID)
                        let vc = HomeViewController(groupID: groupID)
                        strongSelf.navigationController?.pushViewController(vc, animated: true)
                        strongSelf.navigationItem.leftBarButtonItem = nil
                    } else {
                        let vc = GroupCreationVC()
                        strongSelf.navigationController?.pushViewController(vc, animated: true)
                        strongSelf.navigationItem.leftBarButtonItem = nil
                    }
                }
                
            }
        })
    }
    private func register() {
        guard let email = baseView.emailField.text, !email.isEmpty,
              let password = baseView.passField.text, !password.isEmpty,
              let firstName = baseView.firstNameTF.text, !firstName.isEmpty,
              let lastName = baseView.lastNameTF.text, !lastName.isEmpty
        else {
            let customAlert = ModalJesus(title: "Oops", description: "Please fill out all information.")
            customAlert.addAction(ModalJesusAction(title: "Close", style: false))
            customAlert.showModal(vc: self)
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
            DispatchQueue.main.async {
                let vc = GroupCreationVC()
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                strongSelf.navigationItem.leftBarButtonItem = nil                
            }


        })
    }
    func showCreateAccount(email: String, password: String, fullname: FullName) {
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
                guard let strongSelf = self else{
                    
                    return
                }
                guard error == nil else{
                    if let error = error {
                        let customAlert = ModalJesus(title: "Oops", description: "\(error.localizedDescription)")
                        customAlert.addAction(ModalJesusAction(title: "Close", style: false))
                        customAlert.showModal(vc: strongSelf)
                        return
                    }
                    print("Account creation failed")
                    return
                }
                guard let result = result else {
                    return
                }
                let newUser = User(id: result.user.uid, fullName: fullname, dateJoined: Date().timeIntervalSince1970)
                FirebaseAPI.addUser(user: newUser)
                if let fcmToken = Messaging.messaging().fcmToken {
                    FirebaseAPI.updateDeviceID(deviceID: fcmToken, uid: result.user.uid){
                        print("\(fcmToken) this token was updated for \(fullname)")
                    } }
                DispatchQueue.main.async {
                    let vc = GroupCreationVC()
                    strongSelf.navigationController?.pushViewController(vc, animated: true)
                    strongSelf.navigationItem.leftBarButtonItem = nil
                }
            })
    }

}

