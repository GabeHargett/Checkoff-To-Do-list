//
//  TextInputVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 3/30/22.
//

import UIKit


protocol TextInputVCDelegate: AnyObject {
    func didSubmitText(text: String, text2: String?, textType: TextInputVC.TextType, date: Date?)
}

class TextInputVC: UIViewController {
    
    enum TextType {
        case quote
        case goal
        case task
    }
    
    private let textType: TextType
    private let baseView = BareBonesBottomModalView(frame: .zero, allowsTapToDismiss: true, allowsSwipeToDismiss: true)
    
    override func loadView() {
        view = baseView
        baseView.delegate = self
    }
    
    var textField = UnderlinedTextField()
    private let textField2 = UnderlinedTextField()
    private let datePicker = UIDatePicker()
    private let dateInput = UnderlinedTextField()
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
        baseView.stack.addArrangedSubview(dateInput)
        baseView.stack.addArrangedSubview(textField2)

        textField.height(constant: 50)
        textField.setPlaceHolder(text: "Enter Text",color: .mainColor4)
        textField.textColor = .mainColor1
        
        textField2.height(constant: 50)
        textField2.setPlaceHolder(text: "Enter Text",color: .mainColor4)
        textField2.textColor = .mainColor1

        dateInput.height(constant: 50)
        dateInput.placeholder = "Select Date"
        dateInput.inputView = datePicker
        dateInput.textColor = .mainColor1
        
        datePicker.datePickerMode = .date
        datePicker.timeZone = .current
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(updateDateTextField), for: .valueChanged)
        for view in datePicker.subviews {
            view.setValue(UIColor.mainColor1, forKeyPath: "textColor")
            view.backgroundColor = UIColor.mainColor6
        }

        
        updateDateTextField()
        
        switch textType {
        case .quote:
            textField.placeholder = "Enter Quote"
            textField2.placeholder = "Enter Author"
            dateInput.isHidden = true
        case .goal:
            textField.placeholder = "Enter Goal"
            textField2.isHidden = true
        default:
            textField.placeholder = "Enter Task"
            textField2.isHidden = true
        }

        
        baseView.stack.addArrangedSubview(submitButton)
        
        submitButton.setTitle("Submit", for: .normal)
        submitButton.height(constant: 50)
        submitButton.setTitleColor(.mainColor1, for: .normal)
        
        submitButton.addTarget(self, action: #selector(didSubmit), for: .touchUpInside)
    }

    
    @objc private func didSubmit() {
        
        if let text = textField.text {
            self.dismiss(animated: true) {
                self.delegate?.didSubmitText(text: text, text2: self.textField2.text, textType: self.textType, date: self.datePicker.date)
                
                
            }
        }
    }
    @objc func updateDateTextField() {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        dateInput.text = formatter.string(from: datePicker.date)
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
extension UITextField{

func setPlaceHolder(text : String, color : UIColor = .mainColor1 ){
    
    self.attributedPlaceholder = NSAttributedString(
       string: "\(text)",
       attributes: [NSAttributedString.Key.foregroundColor: color]
   )
}
}

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
        



