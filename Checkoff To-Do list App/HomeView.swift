//
//  HomeView.swift
//  Checkoff To-Do list App
//
//  Created Gabe Hargett on 5/12/22.
//

import UIKit

class HomeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setColors()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let currentWeekTasksStack = UIStackView()
    let nextWeekLabel = UILabel()
    let previousWeekLabel = UILabel()
    let otherWeeksLabel = UILabel()
    
    let openTasksLabel = UILabel()
    let finishedTasksLabel = UILabel()
    
    let startedGoalsLabel = UILabel()
    let finishedGoalsLabel = UILabel()
    
    let mainGoalsStack = UIStackView()
    var couplePhoto = UIImageView()
    let quoteGradient = Gradient()
    let quoteStack = UIStackView()
    let quoteLabel = UILabel()
    let quoteSignature = UILabel()
    
    let editPhotoButtonStack = UIStackView()
    let addQuoteButtonStack = UIStackView()
    let profileViewStack = UIStackView()

    private let cameraImageView = UIImageView(image: UIImage(systemName: "camera.fill"))
    private let editPhotoLabel = UILabel()
    private let quoteBubbleImageView = UIImageView(image: UIImage(systemName: "message.fill"))
    private let addQuoteLabel = UILabel()
    
    private let weekTasksimageView = UIImageView(image: UIImage(systemName: "list.bullet.rectangle"))
    private let goalFlagImageView = UIImageView(image: UIImage(systemName: "flag.filled.and.flag.crossed"))
    private let goalsArrowImageView = UIImageView(image: UIImage(systemName: "arrow.right"))
    private let taskArrowImageView = UIImageView(image: UIImage(systemName: "arrow.right"))
    
    private let mainScreenScrollStack = ScrollableStackView()
    private let mainTasksStack = UIStackView()
    private let nextPreviousOtherStack = UIStackView()
    private let currentWeekTasksLabel = UILabel()
    private let stackLabelHolderView = UIView()
    private let taskslabelStack = UIStackView()
    
    private let goalsLabelStack = UIStackView()
    private let goalsLabel = UILabel()
    private let goalsLabelAndArrow = UIStackView()
    private let tasksLabelAndArrow = UIStackView()
    
    func setColors() {
        quoteSignature.quickConfigure(textAlignment: .right, font: .boldSystemFont(ofSize: 13), textColor: .mainColor6)
        editPhotoLabel.quickConfigure(textAlignment: .center, font: .boldSystemFont(ofSize:12), textColor: .mainColor6)
        addQuoteLabel.quickConfigure(textAlignment: .center, font: .boldSystemFont(ofSize:12), textColor: .mainColor6)
        
        quoteBubbleImageView.tintColor = .mainColor6
        quoteLabel.textColor = .mainColor6
        cameraImageView.tintColor = .mainColor6
        
        for color in [previousWeekLabel, nextWeekLabel, otherWeeksLabel, startedGoalsLabel, openTasksLabel, finishedGoalsLabel, finishedTasksLabel] {
            color.textColor = .mainColor1
        }
        for backgroundColor in [mainTasksStack, mainGoalsStack] {
            backgroundColor.backgroundColor = .mainColor6
        }
        for backgroundColor in [previousWeekLabel, nextWeekLabel, otherWeeksLabel] {
            backgroundColor.backgroundColor = .mainColor4
        }
    }
    
    private func setupView() {
        for view in [couplePhoto, addQuoteButtonStack, editPhotoButtonStack, currentWeekTasksStack, previousWeekLabel, nextWeekLabel, otherWeeksLabel, mainGoalsStack] {
            view.isUserInteractionEnabled = true
        }
        
        let photoBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        editPhotoButtonStack.addAutoLayoutSubview(photoBlurView)
        photoBlurView.fillSuperview()
        
        let quoteBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        addQuoteButtonStack.addAutoLayoutSubview(quoteBlurView)
        quoteBlurView.fillSuperview()
        
        couplePhoto.backgroundColor = .darkGray
        addAutoLayoutSubview(couplePhoto)
        
        editPhotoButtonStack.axis = .horizontal
        editPhotoButtonStack.alignment = .center
        editPhotoButtonStack.spacing = 4
        editPhotoButtonStack.layoutMargins = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        editPhotoButtonStack.isLayoutMarginsRelativeArrangement = true
        editPhotoButtonStack.cornerRadius(radius: 5)
        editPhotoButtonStack.addArrangedSubviews([cameraImageView, editPhotoLabel])
        editPhotoLabel.text = "Edit"
        
        quoteStack.isHidden = true
        addQuoteButtonStack.isHidden = true
        addQuoteButtonStack.axis = .horizontal
        addQuoteButtonStack.alignment = .center
        addQuoteButtonStack.spacing = 4
        addQuoteButtonStack.layoutMargins = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        addQuoteButtonStack.isLayoutMarginsRelativeArrangement = true
        addQuoteButtonStack.cornerRadius(radius: 5)
        addQuoteButtonStack.addArrangedSubviews([quoteBubbleImageView, addQuoteLabel])
        addQuoteLabel.text = "+"
        quoteLabel.textAlignment = .left
        quoteLabel.font = .boldSystemFont(ofSize: 14)
        quoteLabel.numberOfLines = 0
        
        quoteStack.axis = .vertical
        quoteStack.spacing = 4
        quoteStack.addArrangedSubviews([quoteLabel, quoteSignature])
        
        
        quoteGradient.horizontalMode = false
        quoteGradient.startColor = .clear
        quoteGradient.endColor = UIColor(hex: "#000000")
        quoteGradient.startLocation = 0.7
        quoteGradient.endLocation = 1.1
        
        couplePhoto.addAutoLayoutSubview(quoteGradient)
        quoteGradient.fillSuperview()
        
        couplePhoto.addAutoLayoutSubview(editPhotoButtonStack)
        couplePhoto.addAutoLayoutSubview(addQuoteButtonStack)
        couplePhoto.addAutoLayoutSubview(quoteStack)
        couplePhoto.addAutoLayoutSubview(profileViewStack)
        addAutoLayoutSubview(mainScreenScrollStack)
        
        NSLayoutConstraint.activate([
            editPhotoButtonStack.leftAnchor.constraint(equalTo: couplePhoto.leftAnchor, constant: 12),
            editPhotoButtonStack.topAnchor.constraint(equalTo: couplePhoto.topAnchor,constant: 12),
            addQuoteButtonStack.leftAnchor.constraint(equalTo: couplePhoto.leftAnchor, constant: 12),
            addQuoteButtonStack.bottomAnchor.constraint(equalTo: couplePhoto.bottomAnchor,constant: -25),
            quoteStack.leftAnchor.constraint(equalTo: couplePhoto.leftAnchor, constant: 16),
            quoteStack.rightAnchor.constraint(equalTo: couplePhoto.rightAnchor, constant: -16),
            quoteStack.bottomAnchor.constraint(equalTo: couplePhoto.bottomAnchor,constant: -8),
            profileViewStack.topAnchor.constraint(equalTo: couplePhoto.topAnchor, constant: 12),
            profileViewStack.rightAnchor.constraint(equalTo: couplePhoto.rightAnchor,constant: -12)
        ])
        
        taskslabelStack.axis = .vertical
        goalsLabelStack.axis = .vertical
        
        mainScreenScrollStack.stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mainScreenScrollStack.stackView.spacing = 12
        mainScreenScrollStack.stackView.isLayoutMarginsRelativeArrangement = true
        
        mainScreenScrollStack.fillSuperview()
        
        mainTasksStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mainTasksStack.axis = .vertical
        mainTasksStack.spacing = 12
        mainTasksStack.isLayoutMarginsRelativeArrangement = true
        
        currentWeekTasksStack.axis = .horizontal
        currentWeekTasksStack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        currentWeekTasksStack.isLayoutMarginsRelativeArrangement = true
        currentWeekTasksStack.alignment = .center
        currentWeekTasksStack.spacing = 12
        currentWeekTasksStack.cornerRadius(radius: 8)
        
        nextPreviousOtherStack.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 10, right: 12)
        nextPreviousOtherStack.isLayoutMarginsRelativeArrangement = true
        nextPreviousOtherStack.alignment = .center
        nextPreviousOtherStack.spacing = 12
        nextPreviousOtherStack.cornerRadius(radius: 8)
        
        weekTasksimageView.height(constant: 55)
        weekTasksimageView.width(constant: 55)
        weekTasksimageView.contentMode = .scaleAspectFit
        weekTasksimageView.tintColor = .black
        
        goalsArrowImageView.height(constant: 20)
        goalsArrowImageView.width(constant: 20)
        goalsArrowImageView.contentMode = .scaleAspectFit
        goalsArrowImageView.tintColor = .black
        
        taskArrowImageView.height(constant: 20)
        taskArrowImageView.width(constant: 20)
        taskArrowImageView.contentMode = .scaleAspectFit
        taskArrowImageView.tintColor = .black
        
        goalFlagImageView.height(constant: 55)
        goalFlagImageView.width(constant: 55)
        goalFlagImageView.contentMode = .scaleAspectFit
        goalFlagImageView.tintColor = .black
        
        nextWeekLabel.text = "Next"
        nextWeekLabel.textAlignment = .center
        nextWeekLabel.height(constant: 40)
        nextWeekLabel.width(constant: 80)
        nextWeekLabel.cornerRadius(radius: 8)
        
        previousWeekLabel.text = "Previous"
        previousWeekLabel.textAlignment = .center
        previousWeekLabel.height(constant: 40)
        previousWeekLabel.width(constant: 80)
        previousWeekLabel.cornerRadius(radius: 8)
        
        otherWeeksLabel.text = "Other"
        otherWeeksLabel.textAlignment = .center
        otherWeeksLabel.height(constant: 40)
        otherWeeksLabel.width(constant: 80)
        otherWeeksLabel.cornerRadius(radius: 8)
        
        currentWeekTasksLabel.font = UIFont.systemFont(ofSize: 21)
        currentWeekTasksLabel.attributedText = "Current Week Tasks".underLined
        
        couplePhoto.height(constant: 300)
        couplePhoto.contentMode = .scaleAspectFill
        couplePhoto.layer.masksToBounds = true
        
        mainGoalsStack.axis = .horizontal
        mainGoalsStack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        mainGoalsStack.isLayoutMarginsRelativeArrangement = true
        mainGoalsStack.alignment = .center
        mainGoalsStack.spacing = 12
        mainGoalsStack.cornerRadius(radius: 8)
        
        goalsLabel.textAlignment = .left
        goalsLabel.font = UIFont.systemFont(ofSize: 21)
        goalsLabel.numberOfLines = 0
        goalsLabel.attributedText = "Group Goals".underLined
        
        mainScreenScrollStack.stackView.addArrangedSubviews([couplePhoto, mainTasksStack, mainGoalsStack])
        
        mainTasksStack.addArrangedSubviews([currentWeekTasksStack, stackLabelHolderView])
        
        currentWeekTasksStack.addArrangedSubviews([weekTasksimageView,taskslabelStack])
        
        stackLabelHolderView.addAutoLayoutSubview(nextPreviousOtherStack)
        nextPreviousOtherStack.centerInSuperview()
        nextPreviousOtherStack.heightAnchor.constraint(equalTo: stackLabelHolderView.heightAnchor).isActive = true
        
        nextPreviousOtherStack.addArrangedSubviews([previousWeekLabel, nextWeekLabel, otherWeeksLabel])
        
        taskslabelStack.addArrangedSubviews([tasksLabelAndArrow, openTasksLabel, finishedTasksLabel])
        
        tasksLabelAndArrow.addArrangedSubviews([currentWeekTasksLabel, taskArrowImageView])
        tasksLabelAndArrow.height(constant: 25)
        
        mainGoalsStack.addArrangedSubviews([ goalFlagImageView, goalsLabelStack ])
        
        goalsLabelStack.addArrangedSubviews([ goalsLabelAndArrow, startedGoalsLabel, finishedGoalsLabel ])
        
        goalsLabelAndArrow.addArrangedSubviews([goalsLabel, goalsArrowImageView])
        goalsLabelAndArrow.height(constant: 25)
        
    }
}
protocol ProfileViewDelegate: AnyObject {
    func updateProfileView(image: UIImage?, emoji: String?, uid: String)
}

class ProfileView: UIView {
    
    weak var delegate: ProfileViewDelegate?
    let profileStack = UIStackView()
    private let emojiHolder = UIView()
    var emojiImage = UIImageView()
    var emojiString: String?
    let profileImage = UIImageView(image: UIImage(systemName: "person.fill"))
    let uid: String
    
    init(uid: String) {
        self.uid = uid
        super.init(frame: .zero)
        
        configureSubviews()
        configureLayout()
        loadProfileImage()
        loadEmojiImage()
        setUpTapGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        profileImage.cornerRadius(radius: profileImage.frame.height / 2)
    }
    
    private func loadProfileImage() {
        FirebaseAPI.downloadProfileImage(uid: uid) {image in
            if image != nil {
                self.profileImage.image = image
            }
        }
    }
    
    func updateImage(profileImage: UIImage) {
        self.profileImage.image = profileImage
    }
    
    func updateEmoji(emojiString: String) {
        self.emojiString = emojiString
        self.emojiImage.image = emojiString.textToImage()
        self.emojiHolder.isHidden = false
    }
    
    private func loadEmojiImage() {
        FirebaseAPI.getEmoji(uid: uid) {emojiString in
            if emojiString != nil {
                self.emojiString = emojiString
                self.emojiImage.image = emojiString?.textToImage()
                self.emojiHolder.isHidden = false
            } else {
                self.emojiHolder.isHidden = true
            }
        }
    }

    @objc private func didTapProfileImage() {
        delegate?.updateProfileView(image: profileImage.image, emoji: emojiString, uid: uid)
    }
    
    @objc private func didTapEmojiImage() {
        delegate?.updateProfileView(image: profileImage.image, emoji: emojiString, uid: uid)
    }
    
    
    private func setUpTapGestures() {
        profileStack.isUserInteractionEnabled = true
        profileImage.isUserInteractionEnabled = true
        emojiImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
        profileImage.addGestureRecognizer(gesture)
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(didTapEmojiImage))
        emojiImage.addGestureRecognizer(gesture2)
    }
    
    private func configureSubviews() {
        profileImage.addBorders(color: .mainColor6, thickness: 3)
        emojiImage.addBorders(color: .mainColor6, thickness: 3)
        self.emojiHolder.isHidden = true
        profileImage.tintColor = .mainColor6
    }
    
    private func configureLayout() {
        profileStack.alignment = .top
        profileStack.axis = .horizontal
        profileStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        profileStack.spacing = -20
        profileStack.isLayoutMarginsRelativeArrangement = true
        profileStack.addArrangedSubviews([profileImage, emojiHolder])
        
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 75),
            profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor),
        ])
        profileImage.backgroundColor = .black        

        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.masksToBounds = true
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        emojiHolder.height(constant: 36)
        emojiHolder.width(constant: 36)
        emojiHolder.cornerRadius(radius: 18)
        blurView.cornerRadius(radius: 18)
        emojiImage.cornerRadius(radius: 18)
        
        emojiHolder.addAutoLayoutSubview(blurView)
        blurView.fillSuperview()
        emojiHolder.addAutoLayoutSubview(emojiImage)
        emojiImage.fillSuperview()
        
        addAutoLayoutSubview(profileStack)
        profileStack.fillSuperview()
    }
}
