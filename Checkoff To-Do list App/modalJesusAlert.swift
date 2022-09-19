//
//  modalJesusAlert.swift
//  Checkoff To-Do list App
//
//  Created by Gabe Hargett on 6/28/22.
//

import UIKit

class AlertHelper {
    public class func showBasicAlert(vc: UIViewController, title: String, description: String) {
        let alert = ModalJesus(title: title, description: description)
        alert.addAction(ModalJesusAction(title: "Got it", style: true))
        alert.showModal(vc: vc)
    }
}

class ModalJesus: UIViewController {
    
    private let baseView = ModalJesusView()
    
    convenience init(title: String, description: String? = nil, allowDismiss: Bool = true) {
        self.init()
        self.view = baseView
        
        self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        baseView.titleLabel.text = title
        
        if let description = description {
            baseView.descriptionLabel.text = description
        } else {
            baseView.descriptionLabel.isHidden = true
        }
        
        if allowDismiss {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
            baseView.backgroundMask.addGestureRecognizer(tapGesture)
            baseView.backgroundMask.isUserInteractionEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func addAction(_ alertAction: ModalJesusAction) {
        baseView.actionStack.addArrangedSubview(alertAction)
        baseView.actionStack.setCustomSpacing(8, after: alertAction)
        
        alertAction.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
    }
    
    func addCancelAction(title: String) {
        addAction(ModalJesusAction(title: title, style: false))
    }
    
    func showModal(vc: UIViewController) {
        vc.present(self, animated: true, completion: nil)
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
}

private class ModalJesusView: UIView {
    
    let backgroundMask = UIView()
    let modalView = UIView()
    
    let headerStack = UIStackView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let separator = UIView()
    
    let actionStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("fatal init")
    }
    
    private func configureSubviews() {
        backgroundMask.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        modalView.backgroundColor = .white
        modalView.layer.cornerRadius = 16
        modalView.layer.masksToBounds = true
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.numberOfLines = 0
        
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.numberOfLines = 0
        
        separator.backgroundColor = UIColor.lightGray
        
        
    }
    
    private func configureLayout() {
        addAutoLayoutSubview(backgroundMask)
        backgroundMask.fillSuperview()
        
        addAutoLayoutSubview(modalView)
        
        modalView.addAutoLayoutSubview(headerStack)
        headerStack.axis = .vertical
        
        headerStack.addArrangedSubviews([titleLabel, descriptionLabel, separator])
        headerStack.spacing = 8
        
        modalView.addAutoLayoutSubview(actionStack)
        actionStack.spacing = 12
        actionStack.axis = .vertical
        actionStack.layoutMargins = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        actionStack.isLayoutMarginsRelativeArrangement = true
        
        NSLayoutConstraint.activate([
            modalView.centerXAnchor.constraint(equalTo: centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: centerYAnchor),
            modalView.widthAnchor.constraint(equalTo: widthAnchor, constant: -32),
            modalView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            headerStack.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            headerStack.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 16),
            headerStack.widthAnchor.constraint(equalTo: modalView.widthAnchor, constant: -32),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            actionStack.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            actionStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor),
            actionStack.widthAnchor.constraint(equalTo: modalView.widthAnchor, constant: -32),
            actionStack.bottomAnchor.constraint(equalTo: modalView.bottomAnchor),
        ])
    }
}

class ModalJesusAction: UIButton {
    fileprivate var action: (() -> Void)?
    
    var actionStyleDefault: Bool
    
    init() {
        actionStyleDefault = true
        super.init(frame: CGRect.zero)
    }
    
    convenience init(title: String, style: Bool, action: (() -> Void)? = nil) {
        self.init()
        
        self.action = action
        addTarget(self, action: #selector(ModalJesusAction.tapped(_:)), for: .touchUpInside)
        
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        layer.cornerRadius = 11
        layer.masksToBounds = true
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        actionStyleDefault = style
        if actionStyleDefault {
            setTitleColor(.white, for: .normal)
            backgroundColor = .black
        } else {
            setTitleColor(.black, for: .normal)
            backgroundColor = .clear
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapped(_ sender: ModalJesusAction) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.action?()
        })
    }
}
