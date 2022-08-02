//
//  EditProfileViewVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 8/2/22.
//

import UIKit

class EditProfileViewVC: UIViewController {
    private let baseView = BareBonesBottomModalView(frame: .zero, allowsTapToDismiss: true, allowsSwipeToDismiss: true)
    
    override func loadView() {
        view = baseView
        baseView.delegate = self
    }
    
    private let profileLabel = UILabel()
    private let profilePicImageView = UIImageView()
    private let emojiImageView = UIImageView()
    
    private let emojiLabel = UILabel()
    private let initialProfileImage: UIImage?
    private let initialEmoji: String?

    init(initialProfileImage: UIImage?, initialEmoji: String?) {
        self.initialProfileImage = initialProfileImage
        self.initialEmoji = initialEmoji
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
        let emojiHolder = UIView()
        emojiHolder.addAutoLayoutSubview(emojiImageView)
        emojiImageView.centerInSuperview()
        
        let profilePicHeight = UIScreen.main.bounds.width - 100
        profilePicImageView.height(constant: profilePicHeight)
        
        let emojiHeight: CGFloat = 40
        emojiHolder.height(constant: emojiHeight)
        emojiImageView.height(constant: emojiHeight)
        emojiImageView.width(constant: emojiHeight)
        
        profilePicImageView.image = initialProfileImage
        emojiImageView.image = initialEmoji?.textToImage()
        
        profilePicImageView.cornerRadius(radius: profilePicHeight.half)
        profilePicImageView.contentMode = .scaleAspectFill
        emojiImageView.cornerRadius(radius: 4)
        emojiImageView.backgroundColor = .gray
        
        profileLabel.quickConfigure(textAlignment: .left, font: .systemFont(ofSize: 10, weight: .bold), textColor: .mainColor1)
        profileLabel.text = "Profile Picture".uppercased()
        
        emojiLabel.quickConfigure(textAlignment: .left, font: .systemFont(ofSize: 10, weight: .bold), textColor: .mainColor1)
        emojiLabel.text = "Current Status".uppercased()
        
        baseView.stack.addArrangedSubviews([profileLabel, profilePicImageView, emojiLabel, emojiHolder])
        baseView.stack.spacing = 24
        baseView.stack.setCustomSpacing(8, after: profileLabel)
        baseView.stack.setCustomSpacing(8, after: emojiLabel)
        baseView.stack.layoutMargins = UIEdgeInsets(top: 24, left: 50, bottom: 24, right: 50)
    }
    
    func showModal(vc: UIViewController) {
        vc.present(self, animated: true, completion: nil)
        self.baseView.updateModalConstraints()
    }
}

extension EditProfileViewVC: BareBonesBottomModalViewDelegate {
    func didDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CGFloat {
    var half: CGFloat {
        return self / 2
    }
}
