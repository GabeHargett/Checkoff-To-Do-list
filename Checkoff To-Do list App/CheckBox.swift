//
//  CheckBox.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 3/30/22.
//

import UIKit
import SwiftUI

final class CircularCheckbox: UIView {
//    private var tasks = [Task]()
    private var isChecked = false
//    private var isChecked = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.label.cgColor
        layer.cornerRadius = frame.size.width / 2.0
        backgroundColor = .systemBackground
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    func isComplete(isChecked: Bool) {
        self.isChecked = isChecked
        if isChecked == true {
            backgroundColor = .systemBlue
        }
        else {
            backgroundColor = .systemBackground
        }
}
        func toggle() {
            self.isChecked = !isChecked
    
            if self.isChecked {
                backgroundColor = .systemBlue
            }
            else {
                backgroundColor = .systemBackground
            }
        }
    }



    

    
