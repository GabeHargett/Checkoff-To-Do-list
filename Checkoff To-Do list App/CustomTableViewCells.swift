//
//  CustomTableViewCell.swift
//  Checkoff To-Do list App
//
//  Created by Gabe Hargett on 4/20/22.
//

import UIKit

protocol TaskCellDelegate: AnyObject {
    func didCheckBox(task: Task)
    func didTapPencil(task: Task)
}


class TaskCell: UITableViewCell {
    
    static let identifier = "TaskCell"
    
    private let pencilImageView = UIImageView(image: UIImage(systemName: "pencil"))
    private let titleLabel = UILabel()
    private let checkbox = CircularCheckbox()
    private let authorAndDateLabel = UILabel()
    
    weak var delegate: TaskCellDelegate?
    private var task: Task?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        
        pencilImageView.tintColor = .black
        pencilImageView.isUserInteractionEnabled = true
        
        titleLabel.quickConfigure(textAlignment: .left, font: .systemFont(ofSize: 17), textColor: .mainColor1, numberOfLines: 0)
        authorAndDateLabel.quickConfigure(textAlignment: .right, font: .systemFont(ofSize: 15, weight: .light), textColor: .white, numberOfLines: 1)
        authorAndDateLabel.text = "author"
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.spacing = 4
        
        addAutoLayoutSubview(stackView)
        stackView.fillSuperview()
        
        pencilImageView.height(constant: 32)
        pencilImageView.width(constant: 32)
        
        let titleStack = UIStackView()
        titleStack.alignment = .top
        titleStack.addArrangedSubviews([titleLabel, UIView(), pencilImageView, checkbox])
        titleStack.setCustomSpacing(8, after: titleLabel)
        titleStack.setCustomSpacing(8, after: pencilImageView)
        checkbox.height(constant: 32)
        checkbox.width(constant: 32)
        
        stackView.addArrangedSubviews([titleStack, authorAndDateLabel])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCheckBox))
        checkbox.addGestureRecognizer(gesture)
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(didTapTableViewPencil))
        pencilImageView.addGestureRecognizer(gesture1)
    }
    
    override func prepareForReuse() {
        self.authorAndDateLabel.text = "author"
        self.authorAndDateLabel.textColor = .white
    }
    
    func configureCell(task: Task) {
        self.task = task
        self.titleLabel.text = task.title
        FirebaseAPI.getFullName(uid: task.author) {result in
            if let fullName = result {
                DispatchQueue.main.async {
                    self.authorAndDateLabel.textColor = .mainColor3
                    let taskDate = Date.init(timeIntervalSince1970: task.dateStamp)
                    self.authorAndDateLabel.text = "Submitted by \(fullName.firstAndLastInitial()), due \(taskDate.dateString())"
                }
            }
        }
        self.checkbox.isComplete(isChecked: task.isComplete)
        return
    }
    
    @objc func didTapCheckBox() {
        checkbox.toggle()
        if let task = task {
            delegate?.didCheckBox(task: task)
        }
    }
    
    @objc func didTapTableViewPencil() {
        if let task = task {
            delegate?.didTapPencil(task: task)
        }
    }
    
}
extension TaskCell: TextInputVCDelegate {
    func didSubmitText(text: String, text2: String?, textType: TextInputVC.TextType, date: Date?) {
    }
}

protocol GoalCellDelegate: AnyObject {
    func didTapPencil(goal: Goal, date: Date)
    func didCheckBox(goal: Goal)

    
}


class GoalCell: UITableViewCell {
    
    static let identifier = "GoalCell"
    
    weak var delegate: GoalCellDelegate?
    var goal: Goal?
    private let pencilImageView = UIImageView(image: UIImage(systemName: "pencil"))
    private let titleLabel = UILabel()
    private let checkbox = CircularCheckbox()
    private let startDateLabel = UILabel()
    private let endDateLabel = UILabel()
    private let authorLabel = UILabel()


    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        
        setupSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        
        pencilImageView.tintColor = .black
        pencilImageView.isUserInteractionEnabled = true
        
        titleLabel.quickConfigure(textAlignment: .left, font: .systemFont(ofSize: 17), textColor: .mainColor1, numberOfLines: 0)
        startDateLabel.quickConfigure(textAlignment: .right, font: .systemFont(ofSize: 15, weight: .light), textColor: .white, numberOfLines: 1)
        endDateLabel.quickConfigure(textAlignment: .left, font: .systemFont(ofSize: 15, weight: .light), textColor: .white, numberOfLines: 1)
        authorLabel.quickConfigure(textAlignment: .left, font: .systemFont(ofSize: 20, weight: .bold), textColor: .mainColor1, numberOfLines: 1)
        authorLabel.height(constant: 30)
        endDateLabel.text = "endDate"
        startDateLabel.text = "startDate"
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.spacing = 4
        
        addAutoLayoutSubview(stackView)
        stackView.fillSuperview()
        
        pencilImageView.height(constant: 32)
        pencilImageView.width(constant: 32)
        
        let titleStack = UIStackView()
        titleStack.alignment = .top
        titleStack.addArrangedSubviews([titleLabel, UIView(), pencilImageView, checkbox])
        titleStack.setCustomSpacing(8, after: titleLabel)
        titleStack.setCustomSpacing(8, after: pencilImageView)
        checkbox.height(constant: 32)
        checkbox.width(constant: 32)
        
        stackView.addArrangedSubviews([authorLabel, titleStack, endDateLabel, startDateLabel])

        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCheckBox))
        checkbox.addGestureRecognizer(gesture)
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(didTapTableViewPencil))
        pencilImageView.addGestureRecognizer(gesture1)
    }
    override func prepareForReuse() {
        self.startDateLabel.text = "startDate"
        self.startDateLabel.textColor = .white
        self.endDateLabel.text = "endDate"
        self.endDateLabel.textColor = .white

    }
    func configureCell(goal: Goal) {
        self.goal = goal
        self.titleLabel.text = goal.title
        FirebaseAPI.getFullName(uid: goal.author) {result in
            if let fullName = result {
                DispatchQueue.main.async {
                    self.startDateLabel.textColor = .mainColor4
                    self.endDateLabel.textColor = .mainColor2
                    self.authorLabel.text = "\(fullName.firstAndLastInitial())"
                    let startDate = Date()
                    let goalDate = Date.init(timeIntervalSince1970: goal.dateStamp)
                    self.endDateLabel.text = "Expected Finish Date: \(goalDate.dateString())"
                    self.startDateLabel.text = "\(startDate.dateString())"
                }
            }
        }
        self.checkbox.isComplete(isChecked: goal.isComplete)
        return
    }

    @objc func didTapCheckBox() {
        checkbox.toggle()
        if let goal = goal {
            delegate?.didCheckBox(goal: goal)
        }
    }
    
    @objc func didTapTableViewPencil() {
        if let goal = goal {
            let goalDate = Date.init(timeIntervalSince1970: goal.dateStamp)
            delegate?.didTapPencil(goal: goal, date: goalDate)
        }
    }
}

extension GoalCell: TextInputVCDelegate {
    func didSubmitText(text: String, text2: String?, textType: TextInputVC.TextType, date: Date?) {
    }
}
