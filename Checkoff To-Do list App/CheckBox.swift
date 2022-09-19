//
//  CheckBox.swift
//  Checkoff To-Do list App
//
//  Created by Gabe Hargett on 3/30/22.
//

import UIKit

final class CircularCheckbox: UIView {
    
    private var isChecked = false {
        didSet {
            if isChecked {
                imageView.image = checkedImage
                imageView.tintColor = .mainColor1
                addBorders(color: UIColor.mainColor1.withAlphaComponent(1), thickness: 2)
            } else {
                imageView.image = nil
                addBorders(color: UIColor.mainColor1.withAlphaComponent(0.4), thickness: 2)
            }
        }
    }
    
    private let checkedImage = UIImage(systemName: "checkmark")
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        addBorders(color: UIColor.mainColor1.withAlphaComponent(0.4), thickness: 2)
        backgroundColor = .white
        cornerRadius(radius: 4)
        
        addAutoLayoutSubview(imageView)
        imageView.fillSuperviewMargins()
        imageView.tintColor = .mainColor1
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //    override func layoutSubviews() {
    //        layer.cornerRadius = frame.size.width / 2.0
    //    }
    
    func isComplete(isChecked: Bool) {
        self.isChecked = isChecked
    }
    
    func toggle() {
        self.isChecked = !isChecked
    }
}






