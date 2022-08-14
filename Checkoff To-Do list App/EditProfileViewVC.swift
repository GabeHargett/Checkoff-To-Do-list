//
//  EditProfileViewVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 8/2/22.
//

import UIKit
import Photos

protocol EditProfileViewVCDelegate: AnyObject {
    func didUpdateImage(profileImage: UIImage)
    func didUpdateEmoji(emojiString: String)
    }

class EditProfileViewVC: UIViewController {
    private let baseView = BareBonesBottomModalView(frame: .zero, allowsTapToDismiss: true, allowsSwipeToDismiss: true)
    
    override func loadView() {
        view = baseView
        baseView.delegate = self
    }
    weak var delegate: EditProfileViewVCDelegate?
    private let profileLabel = UILabel()
    private let profilePicImageView = UIImageView()
    private let emojiImageView = UIImageView()
    
    private let emojiLabel = UILabel()
    private let initialProfileImage: UIImage?
    private var initialEmoji: String?
    private let editPhotoStack = UIStackView()
    var editPhotoStackViewCenter = NSLayoutConstraint()
    let uid: String
    let currentUID: Bool
    
    private let invisibleTextField = EmojiTextField()

    init(initialProfileImage: UIImage?, initialEmoji: String?, uid: String) {
        self.initialProfileImage = initialProfileImage
        self.initialEmoji = initialEmoji
        self.uid = uid
        self.currentUID = uid == FirebaseAPI.currentUserUID()
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupSubviews()
        setUpProfiles()
        setUpProfileNames()
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
            self.baseView.layoutIfNeeded()
        })
    }
    
    private func setupSubviews() {
        let stackHolder = UIView()
        let photoBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        let editLabel = UILabel()
        let camera = UIImageView(image: UIImage(systemName: "camera.fill"))
        camera.tintColor = .mainColor6
        camera.height(constant: 15)
        camera.width(constant: 15)
        camera.contentMode = .scaleAspectFit
        editLabel.text = "Edit"
        editLabel.quickConfigure(textAlignment: .center, font: .boldSystemFont(ofSize:10), textColor: .mainColor6)
        editPhotoStack.axis = .horizontal
        editPhotoStack.alignment = .center
        editPhotoStack.spacing = 4
        editPhotoStack.layoutMargins = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        editPhotoStack.isLayoutMarginsRelativeArrangement = true
        editPhotoStack.cornerRadius(radius: 5)
        stackHolder.addAutoLayoutSubview(editPhotoStack)
        stackHolder.centerInSuperview()
//        baseView.modalView.addAutoLayoutSubview(editPhotoStack)
        editPhotoStack.addAutoLayoutSubview(photoBlurView)
        editPhotoStack.addArrangedSubviews([camera, editLabel])
        photoBlurView.fillSuperview()

//        NSLayoutConstraint.activate([//editPhotoStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
////                                     editPhotoStack.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
//            editPhotoStack.bottomAnchor = baseView.modalViewBottomAnchor
//
//                                    ])


        let emojiHolder = UIView()
        emojiHolder.addAutoLayoutSubview(emojiImageView)
        emojiImageView.centerInSuperview()
        
        let profilePicHeight = UIScreen.main.bounds.width - 100
        profilePicImageView.height(constant: profilePicHeight)
        
        let emojiHeight: CGFloat = 40
        emojiHolder.height(constant: emojiHeight)
        emojiImageView.height(constant: emojiHeight)
        emojiImageView.width(constant: emojiHeight)
        emojiImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapEmoji)))
        
        profilePicImageView.image = initialProfileImage
        emojiImageView.image = initialEmoji?.textToImage()
        
        profilePicImageView.cornerRadius(radius: profilePicHeight.half)
        profilePicImageView.contentMode = .scaleAspectFill
        profilePicImageView.isUserInteractionEnabled = true
        profilePicImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic)))
        
        emojiImageView.cornerRadius(radius: 4)
        emojiImageView.isUserInteractionEnabled = true
        
        profileLabel.quickConfigure(textAlignment: .left, font: .systemFont(ofSize: 10, weight: .bold), textColor: .mainColor3)
       
        emojiLabel.quickConfigure(textAlignment: .left, font: .systemFont(ofSize: 10, weight: .bold), textColor: .mainColor3)
        emojiLabel.text = "Current Status".uppercased()
        
        baseView.stack.addArrangedSubviews([profileLabel, profilePicImageView, stackHolder, emojiLabel, emojiHolder])
        baseView.stack.spacing = 24
        baseView.stack.setCustomSpacing(12, after: profileLabel)
        baseView.stack.setCustomSpacing(-profilePicHeight.half, after: profilePicImageView)
        baseView.stack.setCustomSpacing(profilePicHeight.half, after: stackHolder)
        baseView.stack.setCustomSpacing(8, after: emojiLabel)
        baseView.stack.layoutMargins = UIEdgeInsets(top: 24, left: 50, bottom: 24, right: 50)
        
        baseView.addAutoLayoutSubview(invisibleTextField)
        invisibleTextField.alpha = 0
        invisibleTextField.delegate = self
    }
    
    private func setUpProfiles() {
        if !currentUID {return}
        emojiImageView.backgroundColor = .gray
    }
    
    private func setUpProfileNames() {
        FirebaseAPI.getFullName(uid: uid) {result in
            if let fullName = result {
                DispatchQueue.main.async {
                    self.profileLabel.text = "\(fullName.firstAndLastName()) Profile Picture".uppercased()
                }
            }
        }
    }

    @objc private func didTapEmoji() {
        if !currentUID {return}
        invisibleTextField.becomeFirstResponder()
    }
    
    private func deniedUI() {
        let customAlert = ModalJesus(title: "Status: Denied", description: "Please allow access to your photos to continue.")
        customAlert.addAction(ModalJesusAction(title: "Open Settings", style: true, action: {self.goToPrivacySettings()}))
        customAlert.addAction(ModalJesusAction(title: "Cancel", style: false))
        customAlert.showModal(vc: self)
    }
    
    private func restrictedUI() {
        let customAlert = ModalJesus(title: "Status: Restricted", description: "Your status is restricted by means this app cannot change.")
        customAlert.addAction(ModalJesusAction(title: "Cancel", style: false))
        customAlert.showModal(vc: self)
    }
    
    private func selectPhotos() {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }
    
    private func goToPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else {
                  assertionFailure("Not able to open App privacy settings")
                  return
              }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc private func didTapProfilePic() {
        if !currentUID {return}
        PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
            switch status {
                
            case .notDetermined:
                break
            case .restricted:
                DispatchQueue.main.async {
                    self.restrictedUI()
                }
            case .denied:
                DispatchQueue.main.async {
                    self.deniedUI()
                }
            case .authorized:
                DispatchQueue.main.async {
                    let vc = UIImagePickerController()
                    vc.sourceType = .photoLibrary
                    vc.delegate = self
                    vc.allowsEditing = true
                    self.present(vc, animated: true)
                }
            case .limited:
                DispatchQueue.main.async {
                    let vc = UIImagePickerController()
                    vc.sourceType = .photoLibrary
                    vc.delegate = self
                    vc.allowsEditing = true
                    self.present(vc, animated: true)
                }
            @unknown default:
                break
            }
        })
    }
    
    private func handleSelectedEmoji(emojiString: String) {
        print(emojiString)
        FirebaseAPI.addEmoji(emoji: emojiString)
        delegate?.didUpdateEmoji(emojiString: emojiString)
        self.initialEmoji = emojiString
        self.emojiImageView.image = emojiString.textToImage()
    }
    
    func showModal(vc: UIViewController) {
        vc.present(self, animated: true, completion: nil)
        self.baseView.updateModalConstraints()
    }
}

extension EditProfileViewVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
                               [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            if let uid = FirebaseAPI.currentUserUID() {
                self.profilePicImageView.image = image
                delegate?.didUpdateImage(profileImage: image)
                FirebaseAPI.uploadProfileImages(uid: uid, image: image) {
                    ImageAssetHelper.clearImage(imageURL: "images/\(uid)/profilePhoto")
                    print("image Uploaded")
                }
            }
            UIView.animate(withDuration: 0.5, animations: {
            })
        }
        
        else {
            let customAlert = ModalJesus(title: "Status: Limited", description: "Please allow access to your photos in settings or select more photos below.")
            customAlert.addAction(ModalJesusAction(title: "Select Photos", style: true, action: {self.selectPhotos()}))
            customAlert.addAction(ModalJesusAction(title: "Open Settings", style: true, action: {self.goToPrivacySettings()}))
            customAlert.addAction(ModalJesusAction(title: "Cancel", style: false))
            customAlert.showModal(vc: self)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewVC: BareBonesBottomModalViewDelegate {
    func didDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.first?.isEmoji == true, string.count == 1 {
            textField.resignFirstResponder()
            handleSelectedEmoji(emojiString: string)
        }
        return false
    }
}

extension CGFloat {
    var half: CGFloat {
        return self / 2
    }
}

extension Character {
    var isEmoji: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return scalar.properties.isEmoji && (scalar.value > 0x238C || unicodeScalars.count > 1)
    }
}

class EmojiTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setEmoji() {
        _ = self.textInputMode
    }
    
    override var textInputContextIdentifier: String? {
           return ""
    }
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                self.keyboardType = .default // do not remove this
                return mode
            }
        }
        return nil
    }
}
