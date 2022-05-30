//
//  File.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 5/4/22.
//

import UIKit

protocol DatePickerVCDelegate: AnyObject {
    func didSubmitDate(date: Date?)
    func didSubmitGoalDate(date: Date?)
}

class DatePickerVC: UIViewController {
    
    enum GoalType {
        case goal
        case task
    }
    
    private let goalType: GoalType

    private let datePicker = UIDatePicker()
    private let submitButton = UIButton()
    weak var delegate: DatePickerVCDelegate?
    
    init(goalType: GoalType) {
        self.goalType = goalType
        super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
}

       func setupSubviews() {
           

           view.addAutoLayoutSubview(datePicker)
           
           datePicker.date = Date()
           datePicker.locale = .current
           datePicker.datePickerMode = .date
           datePicker.preferredDatePickerStyle = .inline
           datePicker.tintColor = .gray
           datePicker.contentMode = .scaleAspectFill
           view.addAutoLayoutSubview(submitButton)

           
           submitButton.setTitle("Submit", for: .normal)
           submitButton.width(constant: 200)
           submitButton.height(constant: 40)
           submitButton.titleLabel?.font = .systemFont(ofSize: 23.0, weight: .regular)
           submitButton.setTitleColor(.white, for: .normal)
           submitButton.backgroundColor = .gray
           submitButton.cornerRadius(radius: 8)
           
           
           view.backgroundColor = .systemGray4

           NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            datePicker.widthAnchor.constraint(equalTo: view.widthAnchor),
            datePicker.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.centerYAnchor.constraint(equalTo:view.safeAreaLayoutGuide.centerYAnchor, constant: 10),
           ])
           
           submitButton.addTarget(self, action: #selector(didSubmit), for: .touchUpInside)

           updateDate()
           
       }

    
    @objc private func didSubmit() {
        
        switch goalType {
        case .goal:
            self.delegate?.didSubmitGoalDate(date: self.datePicker.date)

        case .task:
            self.delegate?.didSubmitDate(date: self.datePicker.date)
        }
    }
    
    @objc func updateDate() {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.string(from: self.datePicker.date)
    }
    
}
