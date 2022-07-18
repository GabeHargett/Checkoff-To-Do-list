//
//  ToastHelper.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 6/27/22.
//


import UIKit

class ToastHelper {
    
    private let buttonAction: (() -> ())?
    private let titleLabel = UILabel()
    private let button = UIButton()
    private let toastView = UIView()
    
    init(title: String, buttonTitle: String?, buttonAction: (() -> ())?) {
        self.buttonAction = buttonAction
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        toastView.addAutoLayoutSubview(blurView)
        blurView.fillSuperview()
        
        titleLabel.quickConfigure(textAlignment: .left, font: .systemFont(ofSize: 17, weight: .regular), textColor: .white, numberOfLines: 0)
        titleLabel.text = title
        
        if let buttonTitle = buttonTitle {
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
            button.layoutMargins = UIEdgeInsets(top: 2, left: 3, bottom: 2, right: 3)
//            button.contentEdgeInsets = UIEdgeInsets(horizontal: 6, vertical: 4)
            button.backgroundColor = .mainColor1
            button.cornerRadius(radius: 4)
        }
        
        let stack = UIStackView()
        stack.addArrangedSubviews([titleLabel, button])
        toastView.addAutoLayoutSubview(stack)
        stack.fillSuperview()
        stack.spacing = 8
        stack.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)

//        stack.layoutMargins = UIEdgeInsets(horizontal: 8, vertical: 8)
        stack.isLayoutMarginsRelativeArrangement = true
        toastView.cornerRadius(radius: 12)
    }
    
    @objc private func didTapButton() {
        guard let buttonAction = buttonAction else {
            return
        }
        buttonAction()
    }
    
    func showToast(view: UIView, duration: Double, bottomInset: CGFloat) {
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        view.addAutoLayoutSubview(toastView)
        
        NSLayoutConstraint.activate([
            toastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomInset),
            toastView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64),
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(withDuration: 0.5, animations: {
                self.toastView.alpha = 0
            }) {result in
                self.toastView.removeFromSuperview()
            }
        }
    }
    
}
