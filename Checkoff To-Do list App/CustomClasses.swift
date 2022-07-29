//
//  CustomClasses.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 7/28/22.
//

import UIKit

class UnderlinedTextField: UITextField {
    override func didMoveToSuperview() {
        font = UIFont.systemFont(ofSize: 20, weight: .medium)
        tintColor = .mainColor1
        
        let underlineView = UIView()
        underlineView.backgroundColor = .mainColor1
        
        addAutoLayoutSubview(underlineView)
        underlineView.height(constant: 2)
        NSLayoutConstraint.activate([
            underlineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            underlineView.centerXAnchor.constraint(equalTo: centerXAnchor),
            underlineView.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }
}

class LimitedLengthField: UITextField {
    var maxLength: Int = 6
    override func willMove(toSuperview superview: UIView?) {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        editingChanged()
    }
    @objc func editingChanged() {
        text = String(text!.prefix(maxLength))
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

class EmojiTextField: UITextField {
    
    var maxLength: Int = 1
    
    override var textInputContextIdentifier: String? { "" }
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func willMove(toSuperview superview: UIView?) {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        editingChanged()
    }

    @objc func editingChanged() {
        text = String(text!.prefix(maxLength))
    }
    
    func commonInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(inputModeDidChange), name: UITextInputMode.currentInputModeDidChangeNotification, object: nil)
    }
    
    @objc func inputModeDidChange(_ notification: Notification) {
        guard isFirstResponder else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.reloadInputViews()
        }
    }
    func didDismiss() {
        
    }
}
