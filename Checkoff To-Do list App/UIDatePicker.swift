//
//  UIDatePicker.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 5/1/22.
////
//
//import UIKit
//import SwiftUI
//protocol DatePickerVCDelegate: AnyObject {
//}
//
//class DatePickerVC: UIViewController {
//    
//    private var tasks = [Task]()
//    private let weekAndYear: WeekAndYear
//    private let submitButton = UIButton()
//
//    init(weekAndYear: WeekAndYear) {
//
//        self.weekAndYear = weekAndYear
//        super.init(nibName: nil, bundle: nil)
//    }
//
//
//
//    required init?(coder aDecoder: NSCoder) { fatalError() }
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupSubviews()
//
//       func setupSubviews() {
//
//            let datePicker: UIDatePicker = {
//                let datePicker = UIDatePicker()
//                datePicker.locale = .current
//                datePicker.datePickerMode = .date
//                datePicker.preferredDatePickerStyle = .inline
//                datePicker.tintColor = .gray
//
//                return datePicker
//            }()
//
//        view.addAutoLayoutSubview(datePicker)
//        datePicker.contentMode = .scaleAspectFill
//        view.backgroundColor = .systemGray4
//
//        NSLayoutConstraint.activate([
//            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            datePicker.widthAnchor.constraint(equalTo: view.widthAnchor),
//            datePicker.heightAnchor.constraint(equalTo: view.heightAnchor),
//        ])
//
//        FirebaseAPI.getTasks() {result in
//            if let allTasks = result {
//                self.tasks = allTasks.filter({task in
//                    let taskDate = Date(timeIntervalSince1970: task.dateStamp)
//                    let taskWeekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: taskDate)
//                    return self.weekAndYear == taskWeekAndYear
//
//                })
//                DispatchQueue.main.async {
//                }
//            }
//        }
////           submitButton.addBorders(color: .black, thickness: 1)
//           submitButton.setTitle("Submit", for: .normal)
//           submitButton.width(constant: 200)
//           submitButton.height(constant: 40)
//           submitButton.titleLabel?.font = .systemFont(ofSize: 23.0, weight: .regular)
//           submitButton.setTitleColor(.white, for: .normal)
//           submitButton.backgroundColor = .gray
//           submitButton.cornerRadius(radius: 8)
//           datePicker.addAutoLayoutSubview(submitButton)
//
////        submitButton.addTarget(self, action: #selector(didSubmit), for: .touchUpInside)
//    }
//        NSLayoutConstraint.activate([
//            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            submitButton.centerYAnchor.constraint(equalTo:view.safeAreaLayoutGuide.centerYAnchor, constant: 10),
//        ])
//
//}
//
////        weak var delegate: DatePickerVCDelegate?
//
//    }
//
