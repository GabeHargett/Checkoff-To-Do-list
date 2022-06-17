//
//  SettingsVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 5/18/22.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {
    
    
    enum Section: Int {
        case setColorScheme
        case userTools
    }
    
    enum buttonType: Int {
        case token
        case logOut
    }
    
    
    override func loadView() {
        view = baseView
    }
    
    let baseView = SettingsView()
    private let sections: [Section] = [.setColorScheme, .userTools]
    
    let signOutButton = CustomButton(type: .imageAndLabel)
    let tokenButton = CustomButton(type: .imageAndLabel)
    let alert2 = UIAlertController(title: "Share this Token",
                                   message: "",
                                   preferredStyle: .alert)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        baseView.tableView.dataSource = self
        
    }
    
    private func getRandomToken() -> String {
        let randomNumber = Int.random(in: 100000...999999)
        return String(randomNumber)
    }
    
    
    @objc private func shouldDismiss() {
        alert2.dismiss(animated: true)
    }
    
}
extension SettingsVC: SettingsColorCellDelegate {
    func didCheckBox() {
        print("checked")
    }
}

extension SettingsVC: SettingsButtonCellDelegate {
    
    internal func logOutTapped() {
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
    
    func createToken() {
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
    }
}

extension SettingsVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .setColorScheme:
            return 7
        case .userTools:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section] {
        case .setColorScheme:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsColorCell.identifier, for: indexPath) as! SettingsColorCell
            if let colorScheme = ColorScheme.init(rawValue: indexPath.item) {
                cell.configure(colorScheme: colorScheme)
            }
            cell.delegate = self
            return cell
        case .userTools:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsButtonCell.identifier, for: indexPath) as! SettingsButtonCell
            cell.configure(buttonType: buttonType.init(rawValue: indexPath.item) ?? .logOut)
            cell.delegate = self
            return cell
        }
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
        tableView.register(SettingsColorCell.self, forCellReuseIdentifier: SettingsColorCell.identifier)
        tableView.register(SettingsButtonCell.self, forCellReuseIdentifier: SettingsButtonCell.identifier)
        
    }
    
    private func configureLayout() {
        addAutoLayoutSubview(tableView)
        tableView.fillSuperview()
    }
}
protocol SettingsColorCellDelegate: AnyObject {
    func didCheckBox()
}

class SettingsColorCell: UITableViewCell {
    
    static let identifier = "SettingsColorCell"
    
    private let checkbox = CircularCheckbox()
    private let gradient1 = Gradient()
    let mainColorView = UIView()
    
    
    weak var delegate: SettingsColorCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        setupSubviews()
        setUpGradient()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(colorScheme: ColorScheme) {
        gradient1.startColor = getStartColor(colorScheme: colorScheme)
        gradient1.endColor = getEndColor(colorScheme: colorScheme)
    }
    
    private func getStartColor(colorScheme: ColorScheme) -> UIColor {
        switch colorScheme {
        case .green:
            return UIColor(hex: "#358873")
        case .blue:
            return UIColor(hex: "#1666ba")
        case .purple:
            return UIColor(hex: "#6f3f74")
        case .red:
            return UIColor(hex: "#d90809")
        case .silver:
            return UIColor(hex: "#4c4c4c")
        case .pink:
            return UIColor(hex: "#f45ca2")
        case .brown:
            return UIColor(hex: "#5f4f3e")
        }
    }
    private func getEndColor(colorScheme: ColorScheme) -> UIColor {
        switch colorScheme {
        case .green:
            return UIColor(hex: "#DFEAE2")
        case .blue:
            return UIColor(hex: "#deecfb")
        case .purple:
            return UIColor(hex: "#eddde8")
        case .red:
            return UIColor(hex: "#fce0df")
        case .silver:
            return UIColor(hex: "#cccccc")
        case .pink:
            return UIColor(hex: "#ffe2f0")
        case .brown:
            return UIColor(hex: "#e3dad1")
        }
    }
    
    private func setUpGradient() {
        gradient1.horizontalMode = true
        gradient1.startLocation = 0.4
        gradient1.endLocation = 1.1
        gradient1.cornerRadius(radius: 8)
        mainColorView.addAutoLayoutSubview(gradient1)
        gradient1.fillSuperview()
        gradient1.isUserInteractionEnabled = false
    }
    
    private func setupSubviews() {
        
        mainColorView.addBorders(color: .black, thickness: 1)
        mainColorView.layer.cornerRadius = 8
        
        let stackView = UIStackView()
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.addArrangedSubviews([mainColorView,checkbox])
        stackView.setCustomSpacing(8, after: mainColorView)
        checkbox.height(constant: 32)
        checkbox.width(constant: 32)
        addAutoLayoutSubview(stackView)
        stackView.fillSuperview()
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCheckBox))
        checkbox.addGestureRecognizer(gesture)
    }
    
    
    
    @objc func didTapCheckBox() {
        checkbox.toggle()
        delegate?.didCheckBox()
    }
}



protocol SettingsButtonCellDelegate: AnyObject {
    func logOutTapped()
    func createToken()
}

class SettingsButtonCell: UITableViewCell {
    
    
    
    static let identifier = "SettingsButtonCell"
    
    let button = CustomButton(type: .image)
    let label  = UILabel()
    
    weak var delegate: SettingsButtonCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(buttonType: SettingsVC.buttonType) {
        switch buttonType {
            
        case .token:
            label.text = "Create Group Token"
            button.setImage(image:UIImage(systemName: "barcode"),color:.black)
            button.addTarget(self, action: #selector(didTapBarCode), for: .touchUpInside)
            
        case .logOut:
            label.text = "Log Out"
            button.setImage(image:UIImage(systemName: "hand.wave"),color:.black)
            button.addTarget(self, action: #selector(didTapLogOut), for: .touchUpInside)
            
        }
    }
    
    @objc func didTapBarCode() {
        delegate?.createToken()
    }
    
    @objc func didTapLogOut() {
        delegate?.logOutTapped()
    }
    
    private func setUpSubviews() {
        label.quickConfigure(textAlignment: .center, font: .systemFont(ofSize: 17), textColor: .black, numberOfLines: 0)
        button.setImageWidth(size: 25)
        button.setImageHeight(size: 25)
        button.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right:5)
        button.quickConfigure(font: .systemFont(ofSize: 15), titleColor: .black, backgroundColor: .systemGray4, cornerRadius: 8)
        
        
        let stackView = UIStackView()
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.addArrangedSubviews([label,button])
        addAutoLayoutSubview(stackView)
        stackView.fillSuperview()
        
    }
}




