//
//  GroupCreationVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 6/2/22.
//

import UIKit

class GroupCreationVC: UIViewController {
    
    override func loadView() {
        view = baseView
    }
    
    let baseView = GroupView()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    private func setGroupTitle(){
        guard let group = baseView.createGroupField.text, !group.isEmpty
        else {
            print("Missing data")
            return
        }
        FirebaseAPI.addGroup(title: group)
        DispatchQueue.main.async {
            let vc = HomeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    private func joinGroup() {
        guard let joinGroup = baseView.joinGroupField.text, !joinGroup.isEmpty
        else {
            print("Missing data")
            return
        }
        FirebaseAPI.readGroupToken(token: joinGroup, completion: {
            result in
            FirebaseAPI.joinGroup(groupID: result ?? "")
            GroupManager.shared.setCurrentGroupID(groupID: result ?? "")
            DispatchQueue.main.async {
                let vc = HomeViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
    @objc private func didTapButton() {
        if baseView.segmentedControl.selectedSegmentIndex == 0 {
            setGroupTitle()
        }
        else{
            joinGroup()
        }
    }
}
class GroupView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    setupUserInputs()
    segmentedControl.addTarget(self, action: #selector(segmentedControlGroup), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    let segmentedControl = UISegmentedControl(items: ["Create Group", "Join Group"])
    let label = UILabel()
    let createGroupField = UITextField()
    let joinGroupField = UITextField()
    let button = UIButton()
    
    
    
    @objc private func segmentedControlGroup() {
        if segmentedControl.selectedSegmentIndex == 0 {
            createGroupField.isHidden = false
            joinGroupField.isHidden = true
        }
        else {
            joinGroupField.isHidden = false
            createGroupField.isHidden = true
        }
    }
    private func setupUserInputs() {
        segmentedControl.selectedSegmentIndex = 0
        backgroundColor = .white
        joinGroupField.isHidden = true

        
        createGroupField.placeholder = "Create Group Name"
        createGroupField.layer.borderWidth = 1
        createGroupField.autocapitalizationType = .none
        createGroupField.layer.borderColor = UIColor.black.cgColor
        createGroupField.backgroundColor = .white
        createGroupField.leftViewMode = .always
        createGroupField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        createGroupField.cornerRadius(radius: 8)

        
        joinGroupField.placeholder = "Enter Group Token"
        joinGroupField.layer.borderWidth = 1
        joinGroupField.cornerRadius(radius: 8)
        joinGroupField.isSecureTextEntry = true
        joinGroupField.layer.borderColor = UIColor.black.cgColor
        joinGroupField.backgroundColor = .white
        joinGroupField.leftViewMode = .always
        joinGroupField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))

        button.backgroundColor = .systemGray4
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Continue", for: .normal)
        button.isUserInteractionEnabled = true
        button.cornerRadius(radius: 8)

        addAutoLayoutSubview(segmentedControl)
        addAutoLayoutSubview(button)
        addAutoLayoutSubview(joinGroupField)
        addAutoLayoutSubview(createGroupField)
                
        NSLayoutConstraint.activate([
            
            segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -40),
            segmentedControl.widthAnchor.constraint(equalToConstant: 400),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30),
            
            createGroupField.centerXAnchor.constraint(equalTo: centerXAnchor),
            createGroupField.centerYAnchor.constraint(equalTo: centerYAnchor),
            createGroupField.widthAnchor.constraint(equalToConstant: 400),
            createGroupField.heightAnchor.constraint(equalToConstant: 30),

            joinGroupField.centerXAnchor.constraint(equalTo: centerXAnchor),
            joinGroupField.centerYAnchor.constraint(equalTo: centerYAnchor),
            joinGroupField.widthAnchor.constraint(equalToConstant: 400),
            joinGroupField.heightAnchor.constraint(equalToConstant: 30),
            
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: +40),
            button.widthAnchor.constraint(equalToConstant: 400),
            button.heightAnchor.constraint(equalToConstant: 30),
            ])


    }
}

