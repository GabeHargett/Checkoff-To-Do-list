//
//  CustomButton.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 3/30/22.
//

import UIKit


class CustomButton: UIControl {
    
    
    enum CustomButtonType {
        case label
        case image
        case imageAndLabel
    }
    
    private let type: CustomButtonType
    private let stackView = UIStackView()
    private let label = UILabel()
    private let imageView = UIImageView()
    
    override var layoutMargins: UIEdgeInsets {
        didSet {
            stackView.layoutMargins = layoutMargins
        }
    }
    
    var spacing: CGFloat = 0 {
        didSet {
            stackView.spacing = spacing
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.3 : 1
            transform = isHighlighted ? CGAffineTransform(scaleX: 1/1.05, y: 1/1.05) : CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    var color: UIColor = .black {
        didSet {
            label.textColor = color
            imageView.tintColor = color
        }
    }
    
    init(type: CustomButtonType){
        self.type = type
        super.init(frame: .zero)
        
        color = .black
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        spacing = 200
        imageView.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        addAutoLayoutSubview(stackView)
        stackView.fillSuperview()
        stackView.alignment = .center
        stackView.addArrangedSubviews([imageView, label])
        stackView.isUserInteractionEnabled = false
        stackView.isLayoutMarginsRelativeArrangement = true
        
        label.textAlignment = .center
        
        switch type {
        case .label:
            imageView.isHidden = true
        case .image:
            label.isHidden = true
        case .imageAndLabel:
            break
        }
    }
    
    func setImage(image: UIImage?, color: UIColor) {
        imageView.image = image
        self.color = color
    }
    
    func setImageWidth(size: CGFloat) {
        imageView.width(constant: size)
    }
    
    func setImageHeight(size: CGFloat) {
        imageView.height(constant: size)
    }
    
    func setTitle(title: String) {
        label.text = title
    }
    
    func setTitleAlignment(alignment: NSTextAlignment) {
        label.textAlignment = alignment
    }
    
    func quickConfigure(font: UIFont, titleColor: UIColor, backgroundColor: UIColor, cornerRadius: CGFloat) {
        self.label.font = font
        self.color = titleColor
        self.backgroundColor = backgroundColor
        self.cornerRadius(radius: cornerRadius)
    }
    
}



