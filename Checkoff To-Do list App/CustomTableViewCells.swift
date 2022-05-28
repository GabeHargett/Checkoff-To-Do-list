//
//  CustomTableViewCell.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 4/20/22.
//

import UIKit

protocol CustomTableViewCellDelegate: AnyObject {
    func didCheckBox(taskIndex: Int)
    func didTapPencil(taskIndex: Int)
}



class CustomTableViewCell: UITableViewCell {

    

    
    static let identifier = "CustomTableViewCell"
    public var checkbox1 = CircularCheckbox(frame: CGRect(x: 150, y: 150, width: 25, height: 25))
    
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
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(didTapTableViewPencil))
        myImageView.addGestureRecognizer(gesture1)
    }
    func configureCell(task: Task) {
        self.textLabel?.numberOfLines = 0
        FirebaseAPI.getFullName(uid: task.author) {result in
            if let fullName = result {
                self.textLabel?.text = task.title + "\n\n" + fullName.firstName
            }
        }
        self.textLabel?.text = task.title
        self.checkbox1.isComplete(isChecked: task.isComplete)
        contentView.height(constant: 100)
        return
    }
    @objc func didTapCheckBox() {
        checkbox1.toggle()
        if let taskIndex = taskIndex {
            delegate?.didCheckBox(taskIndex: taskIndex)
        }
    }
    
    @objc func didTapTableViewPencil() {
        if let taskIndex = taskIndex {
            delegate?.didTapPencil(taskIndex: taskIndex)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension CustomTableViewCell: TextInputVCDelegate {
    func didSubmitText(text: String, textType: TextInputVC.TextType, date: Date?) {
    }
}

protocol GoalTableViewCellDelegate: AnyObject {
    func didTapPencil(goalIndex: Int)
}


class GoalTableViewCell: UITableViewCell {

    static let identifier = "GoalTableViewCell"
    
    weak var delegate: GoalTableViewCellDelegate?
    var goalIndex: Int?
    
    public let myImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "pencil"))
        imageView.tintColor = .black
        imageView.isUserInteractionEnabled = true

        return imageView
    }()
    public let myImageView2: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "pencil"))
        imageView.tintColor = .black
        imageView.isUserInteractionEnabled = true

        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemGray4
        
        addAutoLayoutSubview(myImageView)
        NSLayoutConstraint.activate([
            myImageView.rightAnchor.constraint(equalTo: rightAnchor,constant: -40),
            myImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            myImageView.widthAnchor.constraint(equalToConstant: 25),
            myImageView.heightAnchor.constraint(equalToConstant: 25),
        ])
                
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(didTapTableViewPencil))
        myImageView.addGestureRecognizer(gesture1)
    }
    func configureCell(goal: Goal) {
        self.textLabel?.numberOfLines = 0
        FirebaseAPI.getFullName(uid: goal.author) {result in
            if let fullName = result {
                self.textLabel?.text = goal.goal + "\n\n" + fullName.firstName
            }
        }
        self.textLabel?.text = goal.goal
        contentView.height(constant: 100)
        return
    }
    
    @objc func didTapTableViewPencil() {
        if let goalIndex = goalIndex {
            delegate?.didTapPencil(goalIndex: goalIndex)
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension GoalTableViewCell: TextInputVCDelegate {
    func didSubmitText(text: String, textType: TextInputVC.TextType, date: Date?) {
    }
}
