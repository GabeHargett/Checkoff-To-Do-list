//
//  TextInputVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 3/30/22.
//

import UIKit
import SwiftUI


protocol TextInputVCDelegate: AnyObject {
    func didSubmitText(text: String, textType: TextInputVC.TextType)
}



class TextInputVC: UIViewController {
    
    enum TextType {
        case quote
        case goal
        case task
        case author
    }
    
    private let textType: TextType
    //private let homeVC = HomeViewController()
    private let baseView = BareBonesBottomModalView(frame: .zero, allowsTapToDismiss: true, allowsSwipeToDismiss: true)
    
    override func loadView() {
        view = baseView
        baseView.delegate = self
    }
    
    private let textField = UnderlinedTextField()
    private let submitButton = UIButton()
    
    weak var delegate: TextInputVCDelegate?

    init(textType: TextType) {
        self.textType = textType
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupKeyboardObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.5
        let height = (keyboardFrame?.height) ?? 400
        UIView.animate(withDuration: keyboardDuration, animations: {
            self.baseView.modalViewBottomAnchor.constant = -height
            self.baseView.layoutIfNeeded()
        })
    }
    
    @objc private func handleKeyboardWillHide(notification: NSNotification) {
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.5
        UIView.animate(withDuration: keyboardDuration, animations: {
            self.baseView.modalViewBottomAnchor.constant = 0
        })
    }
    
    private func setupSubviews() {
        baseView.stack.addArrangedSubview(textField)
        
        textField.height(constant: 50)
        textField.placeholder = "Enter Text"
        
        switch textType {
        case .quote:
            textField.placeholder = "Enter Quote"
        case .goal:
            textField.placeholder = "Enter Goal"
        case .author:
            textField.placeholder = "Enter Author"
        default:
            textField.placeholder = "Enter Text"
        }
        
        baseView.stack.addArrangedSubview(submitButton)
        
        submitButton.setTitle("Submit", for: .normal)
        submitButton.height(constant: 50)
        submitButton.setTitleColor(.black, for: .normal)
        
        submitButton.addTarget(self, action: #selector(didSubmit), for: .touchUpInside)
    }

    
    @objc private func didSubmit() {
        

        
        if let text = textField.text {
            self.dismiss(animated: true) {
                self.delegate?.didSubmitText(text: text, textType: self.textType)
            }
            }
        }

    
    
    func showModal(vc: UIViewController) {
        vc.present(self, animated: true, completion: nil)
        self.baseView.updateModalConstraints()
    }
    
}

extension TextInputVC: BareBonesBottomModalViewDelegate {
    func didDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

class UnderlinedTextField: UITextField {
    override func didMoveToSuperview() {
        font = UIFont.systemFont(ofSize: 20, weight: .medium)
        tintColor = .black
        
        let underlineView = UIView()
        underlineView.backgroundColor = .black
        
        addAutoLayoutSubview(underlineView)
        underlineView.height(constant: 2)
        NSLayoutConstraint.activate([
            underlineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            underlineView.centerXAnchor.constraint(equalTo: centerXAnchor),
            underlineView.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }
}

