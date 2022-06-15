//
//  SettingsVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 5/18/22.
//

import UIKit
import Firebase

struct ColorOptions {
    let colorView = UIView()
    let checkBox = CircularCheckbox()
}

struct UserSpecificButtons {
    let logOutButton = UIButton()
    let tokenGenerator = UIButton()
}

class SettingsVC: UIViewController {
    
    enum Section: Int {
        case setColorScheme = 0
        case userTools = 1
    }

    override func loadView() {
        view = baseView
    }
    
    
    let baseView = SettingsView()
    private let sections: [Section] = [.setColorScheme, .userTools]
    
    let signOutButton = CustomButton(type: .imageAndLabel)
    let tokenButton = CustomButton(type: .imageAndLabel)
    let alert2 = UIAlertController(title: "Create Account",
                                   message: "",
                                   preferredStyle: .alert)



    var colorViews = [ColorOptions]()
    var tools = [UserSpecificButtons]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        baseView.tableView.dataSource = self
        logOutButton()
        logOutButtonSetUp()
        tokenButtonDidTap()
        tokenButtonSetUp()
    }

    private func getRandomToken() -> String {
        let randomNumber = Int.random(in: 100000...999999)
        return String(randomNumber)
    }
    
    @objc public func generateToken() {
        let alert = UIAlertController(title: "Create Group Token",
                                      message: "Would you like to create a group token?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue",
                                      style: .default,
                                      handler: {_ in
            let token = self.getRandomToken()
            let groupID = GroupManager.shared.getCurrentGroupID() ?? ""
            FirebaseAPI.setGroupToken(groupID: groupID, token: token)
            self.alert2.message = token
            self.present(self.alert2, animated: true) { [weak self] in
                guard let self = self else { return }

                let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(self.shouldDismiss))

                self.alert2.view.window?.isUserInteractionEnabled = true
                self.alert2.view.window?.addGestureRecognizer(dismissGesture)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: {_ in
            
        }))
        present(alert, animated: true)

    }
    @objc private func shouldDismiss() {
        alert2.dismiss(animated: true)
    }
    private func logOutButton() {
        signOutButton.isUserInteractionEnabled = true
        let tapGesture180 = UITapGestureRecognizer(target: self, action: #selector(logOutTapped))
        signOutButton.addGestureRecognizer(tapGesture180)
    }

    
    private func logOutButtonSetUp() {
    
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
    }
    private func tokenButtonDidTap() {
        tokenButton.isUserInteractionEnabled = true
        let tapGesture180 = UITapGestureRecognizer(target: self, action: #selector(generateToken))
        tokenButton.addGestureRecognizer(tapGesture180)
    }

    
    private func tokenButtonSetUp() {
    
        tokenButton.setImage(image:UIImage(systemName: "hand.wave"),color: .black)
        tokenButton.setTitle(title: "Token")
        tokenButton.setImageWidth(size: 30)
        tokenButton.setImageHeight(size: 30)
        tokenButton.quickConfigure(
            font: .systemFont(ofSize: 17),
            titleColor: .black,
            backgroundColor: .systemGray4,
            cornerRadius: 15)
    
        tokenButton.layoutMargins = UIEdgeInsets(top: 10,
                                                   left: 0,
                                                   bottom: 10,
                                                   right: 10)
        view.addAutoLayoutSubview(tokenButton)
    
        NSLayoutConstraint.activate([
            tokenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tokenButton.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -40),
        ])
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

extension SettingsVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch sections[section] {
//        case .setColorScheme:
//            return colorViews.count
//        case .userTools:
//            return tools.count
//        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as! SettingsCell

//        switch sections[indexPath.section] {
//        case .setColorScheme:
////            task = tasks.filter({!$0.isComplete})[indexPath.item]
//        case .userTools:
////            task = tasks.filter({$0.isComplete})[indexPath.item]
//        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section] {
        case .setColorScheme:
            return "Select Color Scheme"
        case .userTools:
            return "User Tools"
        }
        }
    }
class SettingsView: UIView {
    
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        configureSubviews()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    private func configureSubviews() {
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
    }
    
    private func configureLayout() {
        addAutoLayoutSubview(tableView)
        tableView.fillSuperview()
    }
}


class SettingsCell: UITableViewCell {
    
    static let identifier = "SettingsCell"
    
    private let checkbox = CircularCheckbox()
    private let mainColorViews = UIView()
    private let gradient1 = Gradient()

    
    weak var delegate: SettingsCell?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        setupSubviews()
        setUpGradient()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpGradient() {
        gradient1.horizontalMode = true
        gradient1.startColor = .mainColor1
        gradient1.endColor = .mainColor6
        gradient1.startLocation = 0.4
        gradient1.endLocation = 1.1
        gradient1.cornerRadius(radius: 8)
        mainColorViews.addAutoLayoutSubview(gradient1)
        gradient1.fillSuperview()
        gradient1.isUserInteractionEnabled = false

    }
    
    private func setupSubviews() {
        
        mainColorViews.addBorders(color: .black, thickness: 1)
        mainColorViews.layer.cornerRadius = 8

        let stackView = UIStackView()
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.addArrangedSubviews([mainColorViews,checkbox])
        stackView.setCustomSpacing(8, after: mainColorViews)
        checkbox.height(constant: 32)
        checkbox.width(constant: 32)
        addAutoLayoutSubview(stackView)
        stackView.fillSuperview()
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCheckBox))
        checkbox.addGestureRecognizer(gesture)
    }


@objc func didTapCheckBox() {
    checkbox.toggle()
}
}




