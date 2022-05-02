//
//  UIDatePicker.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 5/1/22.
//

import UIKit
protocol DatePickerVCDelegate: AnyObject {
}

class DatePickerVC: UIViewController {
        
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.tintColor = .darkGray
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addAutoLayoutSubview(datePicker)
        datePicker.contentMode = .scaleAspectFill
        view.backgroundColor = .systemGray4
        
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            datePicker.widthAnchor.constraint(equalTo: view.widthAnchor),
            datePicker.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
        
//        weak var delegate: DatePickerVCDelegate?

    }
}
