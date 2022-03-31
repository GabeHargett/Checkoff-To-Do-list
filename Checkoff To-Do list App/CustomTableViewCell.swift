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
    
    let myTextField: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 300.00, height: 50.00))
    let checkbox1 = CircularCheckbox(frame: CGRect(x: 150, y: 150, width: 25, height: 25))
    
    weak var delegate: CustomTableViewCellDelegate?
    var taskIndex: Int?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .orange
        
        addAutoLayoutSubview(checkbox1)
        NSLayoutConstraint.activate([
            checkbox1.rightAnchor.constraint(equalTo: rightAnchor,constant: -10),
            checkbox1.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkbox1.widthAnchor.constraint(equalToConstant: 25),
            checkbox1.heightAnchor.constraint(equalToConstant: 25),
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
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
