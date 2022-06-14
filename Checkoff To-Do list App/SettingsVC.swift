//
//  SettingsVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 5/18/22.
//

import UIKit
import Firebase


class SettingsVC: UIViewController {
    override func loadView() {
        view = baseView
    }
    
    
    let baseView = SettingsView()
    let signOutButton = CustomButton(type: .imageAndLabel)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        baseView.tableView.dataSource = self
        logOutButton()
        logOutButtonSetUp()
        generateToken()

    }
    private func getRandomToken() -> String {
        let randomNumber = Int.random(in: 100000...999999)
        return String(randomNumber)
    }
    
    private func generateToken() {
        let token = getRandomToken()
        let groupID = GroupManager.shared.getCurrentGroupID() ?? ""
        FirebaseAPI.setGroupToken(groupID: groupID, token: token)
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as! SettingsCell
        return cell
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ColorScheme"
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
    
    private let titleLabel = UILabel()
    private let checkbox = CircularCheckbox()
    private let mainColorLabel = UIView()
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
        mainColorLabel.addAutoLayoutSubview(gradient1)
        gradient1.fillSuperview()
        gradient1.isUserInteractionEnabled = false

    }
    
    private func setupSubviews() {
        
        mainColorLabel.addBorders(color: .black, thickness: 1)
        mainColorLabel.layer.cornerRadius = 8

        let stackView = UIStackView()
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.addArrangedSubviews([mainColorLabel,checkbox])
        stackView.setCustomSpacing(8, after: mainColorLabel)
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
        

