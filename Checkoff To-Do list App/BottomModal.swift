//
//  BottomModal.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 3/30/22.
//

import UIKit

protocol BareBonesBottomModalViewDelegate: AnyObject {
    func didDismiss()
}

//MARK: BareBones ModalView
class BareBonesBottomModalView: UIView {
    
    let backgroundMask = UIView()
    let modalView = UIView()
    var modalViewBottomAnchor = NSLayoutConstraint()
    var modalViewTopAnchor = NSLayoutConstraint()
    
    let stack = UIStackView()
    
    weak var delegate: BareBonesBottomModalViewDelegate?
    
    init(frame: CGRect, allowsTapToDismiss: Bool, allowsSwipeToDismiss: Bool) {
        super.init(frame: frame)
        if allowsTapToDismiss {
            configureBackTapToDismiss()
        }
        if allowsSwipeToDismiss {
            configureSwipeToDismiss()
        }
        
        configureSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("fatal init")
    }
    
    private func configureBackTapToDismiss() {
        backgroundMask.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDismissModal))
        backgroundMask.addGestureRecognizer(tapGesture)
    }
    
    private func configureSwipeToDismiss() {
        backgroundMask.isUserInteractionEnabled = true
        let backPanGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanOnBackground))
        let modalPanGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanOnBackground))
        backgroundMask.addGestureRecognizer(backPanGesture)
        modalView.addGestureRecognizer(modalPanGesture)
        modalView.isUserInteractionEnabled = true
        
        let handle = UIView()
        handle.backgroundColor = UIColor.lightGray
        modalView.addAutoLayoutSubview(handle)
        handle.height(constant: 6)
        handle.width(constant: 50)
        handle.cornerRadius(radius: 3)
        NSLayoutConstraint.activate([
            handle.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 8),
            handle.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
        ])
    }
    
    private func configureSubviews() {
        backgroundMask.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        modalView.backgroundColor = .white
        modalView.clipsToBounds = true
        modalView.layer.cornerRadius = 32
        modalView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func configureLayout() {
        addAutoLayoutSubview(backgroundMask)
        backgroundMask.fillSuperview()
        
        addAutoLayoutSubview(modalView)
        
        modalView.addAutoLayoutSubview(stack)
        stack.axis = .vertical
        stack.spacing = 16
        stack.fillSuperview()
        stack.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        
        modalViewBottomAnchor = modalView.bottomAnchor.constraint(equalTo: bottomAnchor)
        modalViewTopAnchor = modalView.topAnchor.constraint(equalTo: bottomAnchor, constant: 10)
        
        NSLayoutConstraint.activate([
            modalView.centerXAnchor.constraint(equalTo: centerXAnchor),
            modalViewTopAnchor,
            modalView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            modalView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
        ])
    }
    
    @objc private func didDismissModal() {
        self.delegate?.didDismiss()
    }
    
    @objc private func didPanOnBackground(panGesture: UIPanGestureRecognizer) {
        guard let panView = panGesture.view else {return}
        let changeY = panGesture.translation(in: panView).y
        if changeY > 0 {
            modalViewBottomAnchor.constant = changeY
        }
        if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: panView)
            let modalHeight = modalView.frame.height
            
            if changeY > 60 && velocity.y > 0 {
                let remainingPoints = modalHeight - changeY
                var interval = Double(remainingPoints / velocity.y)
                if interval > 0.5 {interval = 0.5}
                UIView.animate(withDuration: interval, animations: {
                    self.modalViewBottomAnchor.isActive = false
                    self.modalViewTopAnchor.isActive = true
                    self.layoutIfNeeded()
                }) {_ in
                    self.delegate?.didDismiss()
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.modalViewBottomAnchor.constant = 0
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    func updateModalConstraints() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.modalViewTopAnchor.isActive = false
            self.modalViewBottomAnchor.isActive = true
            self.layoutIfNeeded()
        })
    }
    
}
