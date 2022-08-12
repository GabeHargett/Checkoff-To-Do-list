//
//  SettingsVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 5/18/22.
//

import UIKit
import Firebase

protocol SettingsVCDelegate: AnyObject {
    func updateColor()
    func updateGroupName()
}

class SettingsVC: UIViewController {
    
    
    enum Section: Int {
        case setColorScheme
        case userTools
    }
    
    enum ButtonType: Int {
        case token
        case groupName
        case logOut
    }
    
    
    override func loadView() {
        view = baseView
    }
    
    let baseView = SettingsView()
    private let sections: [Section] = [.setColorScheme, .userTools]
    
    let signOutButton = CustomButton(type: .imageAndLabel)
    let tokenButton = CustomButton(type: .imageAndLabel)
    weak var delegate: SettingsVCDelegate?
    var currentToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        baseView.tableView.dataSource = self
        baseView.tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectRow()
    }
    
    private func getToken() -> String {
        let randomNumber = Int.random(in: 100000...999999)
        return String(randomNumber)
    }
        
    private func selectRow() {
        let currentSelectedRow = UserDefaults.standard.integer(forKey: "ColorScheme")
        for index in 0...7 {
            if let cell = baseView.tableView.cellForRow(at: IndexPath(row: index, section: Section.setColorScheme.rawValue)) as? SettingsColorCell {
                cell.checkbox.isComplete(isChecked: index == currentSelectedRow)
            }
        }
    }
    
    private func showToast() {
        UIPasteboard.general.string = currentToken
        let toast = ToastHelper(title: "Group token copied", buttonTitle: nil, buttonAction: nil)
        toast.showToast(view: baseView, duration: 1, bottomInset: 20)
    }
    
    private func showToast2() {
        let toast2 = ToastHelper(title: "Color Updated", buttonTitle: nil, buttonAction: nil)
        toast2.showToast(view: baseView, duration: 1, bottomInset: 20)
    }
}

extension SettingsVC: SettingsButtonCellDelegate, TextInputVCDelegate {
        
    func createToken() {
        let customAlert = ModalJesus(title: "Group Token", description: "Share this token with your group member during the account creation phase.")
        let groupID = GroupManager.shared.getCurrentGroupID() ?? ""
        let newToken = getToken()
        currentToken = newToken
        FirebaseAPI.setGroupToken(groupID: groupID, token: newToken)
        customAlert.addAction(ModalJesusAction(title: "\(newToken) (Tap to copy)", style: true, action: {self.showToast()}))
        customAlert.addAction(ModalJesusAction(title: "Cancel", style: false))
        customAlert.showModal(vc: self)
    }
    func changeGroupName() {
        let vc = TextInputVC(textType: .groupName)
        vc.delegate = self
        vc.showModal(vc: self)
    }
    
    internal func logOutTapped() {
        do{
            try FirebaseAuth.Auth.auth().signOut()
            GroupManager.shared.clearGroupID()
            DispatchQueue.main.async {
                let vc = FirebaseAuthVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        catch{
            print("An error occurred")
        }
    }
    
    func didSubmitText(text: String, text2: String?, textType: TextInputVC.TextType, date: Date?) {
        FirebaseAPI.addGroup(title: text) {result in
            if let text = result {
                DispatchQueue.main.async {
                    self.delegate?.updateGroupName()
                }
            }
        }
        //delegate?.updateGroupName() call here after groupname is added
    }
}

extension SettingsVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .setColorScheme:
            return 8
        case .userTools:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section] {
        case .setColorScheme:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsColorCell.identifier, for: indexPath) as! SettingsColorCell
            if let colorScheme = ColorScheme.init(rawValue: indexPath.item) {
                cell.configure(colorScheme: colorScheme)
            }
            return cell
        case .userTools:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsButtonCell.identifier, for: indexPath) as! SettingsButtonCell
            cell.configure(buttonType: ButtonType.init(rawValue: indexPath.item) ?? .logOut)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .setColorScheme:
            if let colorScheme = ColorScheme(rawValue: indexPath.item) {
                UserDefaults.standard.set(indexPath.item, forKey: "ColorScheme")
                delegate?.updateColor()
                showToast2()
                tableView.reloadData()
                selectRow()
            }

            return
            
        case .userTools:
            switch ButtonType(rawValue: indexPath.item) {
            case .token:
                createToken()
            case .logOut:
                logOutTapped()
            case .groupName:
                changeGroupName()
            default:
                break
            }
            return
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

class SettingsColorCell: UITableViewCell {
    
    static let identifier = "SettingsColorCell"
    
    let checkbox = CircularCheckbox()
    private let gradient1 = Gradient()
    let mainColorView = UIView()
    
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
        case .black:
            return UIColor.black
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
        case .green:
            return UIColor(hex: "#358873")


        }
    }
    private func getEndColor(colorScheme: ColorScheme) -> UIColor {
        switch colorScheme {
        case .black:
            return UIColor.white
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
        case .green:
            return UIColor(hex: "#DFEAE2")


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
    }
}



protocol SettingsButtonCellDelegate: AnyObject {
    func logOutTapped()
    func createToken()
    func changeGroupName()
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

    func configure(buttonType: SettingsVC.ButtonType) {
        label.textColor = .mainColor1
        button.backgroundColor = .mainColor5
        switch buttonType {
            
        case .token:
            label.text = "Create Group Token"
            button.setImage(image:UIImage(systemName: "barcode"),color:.black)
            button.addTarget(self, action: #selector(didTapBarCode), for: .touchUpInside)
            
        case .groupName:
            label.text = "Change Group Name"
            button.setImage(image:UIImage(systemName: "pencil"),color:.black)
            button.addTarget(self, action: #selector(didTapPencil), for: .touchUpInside)

        case .logOut:
            label.text = "Log Out"
            button.setImage(image:UIImage(systemName: "hand.wave"),color:.black)
            button.addTarget(self, action: #selector(didTapLogOut), for: .touchUpInside)
            }
    }
    
    @objc func didTapBarCode() {
        delegate?.createToken()
    }
    
    @objc func didTapPencil() {
        delegate?.changeGroupName()
    }
    
    @objc func didTapLogOut() {
        delegate?.logOutTapped()
    }
    
    func setUpSubviews() {
        label.quickConfigure(textAlignment: .center, font: .systemFont(ofSize: 17), textColor: .mainColor1, numberOfLines: 0)
        button.setImageWidth(size: 24)
        button.setImageHeight(size: 24)
        button.layoutMargins = UIEdgeInsets(top: 3, left: 3, bottom: 3, right:3)
        button.quickConfigure(font: .systemFont(ofSize: 15), titleColor: .black, backgroundColor: .systemGray4, cornerRadius: 8)
        
        
        let stackView = UIStackView()
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.addArrangedSubviews([label,button])
        addAutoLayoutSubview(stackView)
        stackView.fillSuperview()
        
    }
}




