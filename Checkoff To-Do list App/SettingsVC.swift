//
//  SettingsVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 5/18/22.
//

import UIKit
import Firebase


class SettingsVC: UIViewController {
    
    let signOutButton = CustomButton(type: .imageAndLabel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        
        setUpViews()
    }
    
    private func setUpViews() {

        view.backgroundColor = .white
        signOutButton.setImage(image:UIImage(systemName: "hand.wave"),color: .black)
        signOutButton.setTitle(title: "Log Out")
        signOutButton.setImageWidth(size: 30)
        signOutButton.setImageHeight(size: 30)
        signOutButton.quickConfigure(
            font: .systemFont(ofSize: 17),
            titleColor: .black,
            backgroundColor: .systemGray4,
            cornerRadius: 15)
        
        signOutButton.layoutMargins = UIEdgeInsets(top: 10,
                                                   left: 0,
                                                   bottom: 10,
                                                   right: 10)
        
        view.addAutoLayoutSubview(signOutButton)
        
        NSLayoutConstraint.activate([
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        signOutButton.isUserInteractionEnabled = true
        let tapGesture180 = UITapGestureRecognizer(target: self, action: #selector(logOutTapped))
        signOutButton.addGestureRecognizer(tapGesture180)
    }
    
    @objc private func logOutTapped() {
        do{
            try FirebaseAuth.Auth.auth().signOut()
            DispatchQueue.main.async {
                let vc = FirebaseAuthVC()
                self.navigationController?.pushViewController(vc, animated: true)
        }
    }
        catch{
           print("An error occurred")
        }
    }
}
        

