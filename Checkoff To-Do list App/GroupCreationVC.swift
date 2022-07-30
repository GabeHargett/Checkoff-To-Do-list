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
        FirebaseAPI.addGroup(title: group) {result in
            if let groupID = result {
                GroupManager.shared.setCurrentGroupID(groupID: groupID)
                DispatchQueue.main.async {
                    let vc = HomeViewController(groupID: groupID)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }

    }
    
    private func joinGroup() {
        //error saying must be an empty string, but reloading the app again puts user in the group. unless the token is wrong, then everything breaks.
        guard let joinGroup = baseView.joinGroupField.text, !joinGroup.isEmpty
        else {
            print("Missing data")
            return
        }
        FirebaseAPI.readGroupToken(token: joinGroup, completion: {
            result in
            FirebaseAPI.joinGroup(groupID: result ?? "")
            GroupManager.shared.setCurrentGroupID(groupID: result ?? "")
            //Firebase.addUserToGroup
            //Instead of adding the user to the group here, let's just do it all in the FirebaseAPI.joinGroup function above
            DispatchQueue.main.async {
                let vc = HomeViewController(groupID: "")
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
        setUpStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    let segmentedControl = UISegmentedControl(items: ["Create Group", "Join Group"])
    let label = UILabel()
    let createGroupField = UITextField()
    let joinGroupField = UITextField()
    let button = UIButton()
    let stackView = UIStackView()
    let stackView2 = UIStackView()
    
    
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
        segmentedControl.height(constant: 40)
        backgroundColor = .white
        joinGroupField.isHidden = true

        
        createGroupField.placeholder = "Group Name"
        createGroupField.layer.borderWidth = 1
        createGroupField.autocapitalizationType = .none
        createGroupField.layer.borderColor = UIColor.black.cgColor
        createGroupField.backgroundColor = .white
        createGroupField.leftViewMode = .always
        createGroupField.height(constant: 40)
        createGroupField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        createGroupField.cornerRadius(radius: 8)

        
        joinGroupField.placeholder = "Enter Group Token"
        joinGroupField.layer.borderWidth = 1
        joinGroupField.cornerRadius(radius: 8)
        joinGroupField.isSecureTextEntry = true
        joinGroupField.layer.borderColor = UIColor.black.cgColor
        joinGroupField.backgroundColor = .white
        joinGroupField.leftViewMode = .always
        joinGroupField.height(constant: 40)
        joinGroupField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        joinGroupField.keyboardType = UIKeyboardType.numberPad
//        joinGroupField.maxLength = 6


        button.backgroundColor = .systemGray4
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Continue", for: .normal)
        button.isUserInteractionEnabled = true
        button.height(constant: 40)
        button.cornerRadius(radius: 8)
    }
        private func setUpStackView(){
            stackView.axis = .vertical
            stackView.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.alignment = .fill
            stackView.spacing = 12
            stackView.addArrangedSubviews([segmentedControl, createGroupField, joinGroupField, button])
            
            stackView2.axis = .horizontal
            stackView2.alignment = .center
            stackView2.addArrangedSubviews([stackView])
            addAutoLayoutSubview(stackView2)
            stackView2.fillSuperview()

    }
}

