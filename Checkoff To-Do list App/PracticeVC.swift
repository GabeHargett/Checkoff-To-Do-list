//
//  PracticeVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 4/27/22.
//

import UIKit

class PracticeVC: UIViewController {
    
    private let boxWithLabel = BoxWithLabel()
    private let boxWithTwoLabels = BoxWithTwoLabels()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBoxes()
    }
    
    private func setupBoxes() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        view.addAutoLayoutSubview(stack)
        stack.fillSuperview()
        stack.addArrangedSubviews([boxWithLabel, boxWithTwoLabels])
        boxWithLabel.changeText(text: "tanners cool")
        boxWithTwoLabels.setStackViewSpacing(spacing: 30)
    }
    
}

class BoxWithLabel: UIView {
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addAutoLayoutSubview(label)
        label.centerInSuperview()
        label.text = "I'm a label"
    }
    func changeText(text: String) {
        label.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class BoxWithTwoLabels: UIView {
    
    private let stack = UIStackView()
    private let leftLabel = UILabel()
    private let rightLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addAutoLayoutSubview(stack)
        stack.centerInSuperview()
        leftLabel.text = "I'm a left label"
        rightLabel.text = "I'm a right label"
        stack.addArrangedSubviews([leftLabel, rightLabel])
    }
    func setStackViewSpacing(spacing: CGFloat) {
        stack.spacing = spacing
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
