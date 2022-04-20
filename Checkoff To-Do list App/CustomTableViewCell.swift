//
//  CustomTableViewCell.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 3/30/22.
//

import UIKit

protocol CustomTableViewCellDelegate: AnyObject {
    func didCheckBox(taskIndex: Int)
}



class CustomTableViewCell: UITableViewCell {

    

    
    static let identifier = "CustonTableViewCell"
    
    public let checkbox1 = CircularCheckbox(frame: CGRect(x: 150, y: 150, width: 25, height: 25))
    
    weak var delegate: CustomTableViewCellDelegate?
    var taskIndex: Int?
    
    public let myImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "pencil"))
        imageView.tintColor = .black
        imageView.isUserInteractionEnabled = true

        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemGray4
        
        addAutoLayoutSubview(checkbox1)
        NSLayoutConstraint.activate([
            checkbox1.rightAnchor.constraint(equalTo: rightAnchor,constant: -10),
            checkbox1.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkbox1.widthAnchor.constraint(equalToConstant: 25),
            checkbox1.heightAnchor.constraint(equalToConstant: 25),
        ])
        
        addAutoLayoutSubview(myImageView)
        NSLayoutConstraint.activate([
            myImageView.rightAnchor.constraint(equalTo: rightAnchor,constant: -40),
            myImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            myImageView.widthAnchor.constraint(equalToConstant: 25),
            myImageView.heightAnchor.constraint(equalToConstant: 25),
        ])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCheckBox))
        checkbox1.addGestureRecognizer(gesture)
        
    }
    
    @objc func didTapCheckBox() {
        checkbox1.toggle()
        if let taskIndex = taskIndex {
            delegate?.didCheckBox(taskIndex: taskIndex)
        }
        //protocols and delegates for tableview cells
    }
    
    @objc func didTapTableViewPencil() {
        let vc = TextInputVC(textType: .task)
        vc.delegate = self
//        vc.showModal(vc: self)
        if let taskIndex = taskIndex {
            delegate?.didCheckBox(taskIndex: taskIndex)
        }
    }
    



    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension CustomTableViewCell: TextInputVCDelegate {
    func didSubmitText(text: String, textType: TextInputVC.TextType) {
    }
}
