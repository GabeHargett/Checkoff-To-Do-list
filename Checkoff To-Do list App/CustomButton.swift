//
//  CustomButton.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 3/30/22.
//

import UIKit
import Foundation


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
        spacing = 8
        
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

class UnderlinedLabel: UILabel {

override var text: String? {
    didSet {
        guard let text = text else { return }
        let textRange = NSRange(location: 0, length: text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        // Add other attributes if needed
        self.attributedText = attributedText
        }
    }
}



//        let tannersButton = CustomButton(type: .imageAndLabel)
//        tannersButton.setImage(image:UIImage(systemName: "music.note"),color: .systemGreen)
//
//        tannersButton.setTitle(title: "Music World")
//        tannersButton.setImageWidth(size: 32)
//        tannersButton.setImageHeight(size: 32)
//        tannersButton.quickConfigure(
//            font: .systemFont(ofSize: 17), titleColor: .systemGreen, backgroundColor: .systemBrown, cornerRadius: 15)
//
//        tannersButton.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//
//        view.addAutoLayoutSubview(tannersButton)
//
//
//        NSLayoutConstraint.activate([
//            tannersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            tannersButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//            ])

//        tannersButton.isUserInteractionEnabled = true
//    let tapGesture180 = UITapGestureRecognizer(target: self, action: #selector(didTapTannersButton))
//        tannersButton.addGestureRecognizer(tapGesture180)
//
//    @objc private func didTapTannersButton() {
//        let vc = TemporaryVC()
//        navigationController?.pushViewController(vc, animated: true)
//    }
 
//class TemporaryVC: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .systemGreen
//    }
//}
