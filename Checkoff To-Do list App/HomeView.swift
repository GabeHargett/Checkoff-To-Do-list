//
//  HomeView.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 5/12/22.
//

import UIKit
import SwiftUI

class HomeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        setupView()
        setColors()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    let currentWeekStack = UIStackView()
    let nextWeekLabel = UILabel()
    let previousWeekLabel = UILabel()
    let otherWeeksLabel = UILabel()
    
    let openTaskLabel = UILabel()
    let finishedTaskLabel = UILabel()
    
    let openGoalLabel = UILabel()
    let finishedGoalLabel = UILabel()
    
    let nextWeekGoalLabel = UILabel()
    let previousWeekGoalLabel = UILabel()
    let otherWeeksGoalLabel = UILabel()
    
    let goalsStack2 = UIStackView()
    var couplePhoto = UIImageView()
    let quoteGradient = Gradient()
    let quoteStack = UIStackView()
    let quoteLabel = UILabel()
    let authorLabel = UILabel()
    let quoteSignature = UILabel()
    
    let camera = UIImageView(image: UIImage(systemName: "camera.fill"))
    let editPhotoButton = UIStackView()
    let editLabel = UILabel()
    let quoteImage = UIImageView(image: UIImage(systemName: "message.fill"))
    let addQuote = UIStackView()
    let labelquote = UILabel()
    let profileViewStack = UIStackView()

    private let holder = UIView()
    private let holder2 = UIView()
    private let imageView = UIImageView(image: UIImage(systemName: "list.bullet.rectangle"))
    private let goalImageView = UIImageView(image: UIImage(systemName: "flag.filled.and.flag.crossed"))
    private let goalArrowImageView = UIImageView(image: UIImage(systemName: "arrow.right"))
    private let taskArrowImageView = UIImageView(image: UIImage(systemName: "arrow.right"))

    private let hiarchyStack = UIStackView()
    private let currentWeekTaskLabel = UILabel()
    
    private let scrollStack = ScrollableStackView()
    private let weekStack = UIStackView()
    private let nextPreviousOtherGoalStack = UIStackView()
    private let nextPreviousOtherStack = UIStackView()
    private let currentTaskLabel = UILabel()
    
    //underlinedLabels getting bugged because of imageview with the stack
    
    
    private let labelStack = UIStackView()
    private let testStack = UIStackView()

    private let goalLabelStack = UIStackView()
    private let goalsStack1 = UIStackView()
    private let goalsLabel = UILabel()
    private let goalLabelAndArrow = UIStackView()
    private let taskLabelAndArrow = UIStackView()

    func setColors() {
        authorLabel.quickConfigure(textAlignment: .right, font: .boldSystemFont(ofSize: 13), textColor: .mainColor6)
        //editPhotoButton.addBorders(color: .mainColor6, thickness: 2)
        editLabel.quickConfigure(textAlignment: .center, font: .boldSystemFont(ofSize:12), textColor: .mainColor6)
        //addQuote.addBorders(color: .mainColor6, thickness: 2)
        labelquote.quickConfigure(textAlignment: .center, font: .boldSystemFont(ofSize:12), textColor: .mainColor6)
        
        quoteImage.tintColor = .mainColor6
        quoteLabel.textColor = .mainColor6
        camera.tintColor = .mainColor6
        
        for color in [previousWeekLabel, previousWeekGoalLabel, nextWeekLabel, nextWeekGoalLabel, otherWeeksLabel, otherWeeksGoalLabel, openGoalLabel, openTaskLabel, finishedGoalLabel, finishedTaskLabel] {
            color.textColor = .mainColor1
        }
        for backgroundColor in [weekStack, goalsStack1] {
            backgroundColor.backgroundColor = .mainColor6
        }
        for backgroundColor in [previousWeekLabel, previousWeekGoalLabel, nextWeekLabel, nextWeekGoalLabel, otherWeeksLabel, otherWeeksGoalLabel] {
            backgroundColor.backgroundColor = .mainColor4
        }
    }
    
    private func setupView() {
        for view in [couplePhoto, addQuote, editPhotoButton, currentWeekStack, previousWeekLabel, nextWeekLabel, otherWeeksLabel, goalsStack2, previousWeekGoalLabel, nextWeekGoalLabel,
                     otherWeeksGoalLabel] {
            view.isUserInteractionEnabled = true
        }
        let photoBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        editPhotoButton.addAutoLayoutSubview(photoBlurView)
        photoBlurView.fillSuperview()
        let quoteBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        addQuote.addAutoLayoutSubview(quoteBlurView)
        quoteBlurView.fillSuperview()
        
        

        couplePhoto.backgroundColor = .darkGray

        editPhotoButton.axis = .horizontal
        editPhotoButton.alignment = .center
        editPhotoButton.spacing = 4
        editPhotoButton.layoutMargins = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        editPhotoButton.isLayoutMarginsRelativeArrangement = true
        editPhotoButton.cornerRadius(radius: 5)
        editPhotoButton.addArrangedSubviews([camera, editLabel])
        editLabel.text = "Edit"
        
        addQuote.isHidden = true
        quoteStack.isHidden = true
        addQuote.axis = .horizontal
        addQuote.alignment = .center
        addQuote.spacing = 4
        addQuote.layoutMargins = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        addQuote.isLayoutMarginsRelativeArrangement = true
        addQuote.cornerRadius(radius: 5)
        addQuote.addArrangedSubviews([quoteImage, labelquote])
        labelquote.text = "+"
        quoteLabel.textAlignment = .left
        quoteLabel.font = .boldSystemFont(ofSize: 14)
        quoteLabel.numberOfLines = 0
        
        quoteStack.axis = .vertical
        quoteStack.spacing = 4
        quoteStack.addArrangedSubviews([quoteLabel, authorLabel])
        
        addAutoLayoutSubview(couplePhoto)
        
        quoteGradient.horizontalMode = false
        quoteGradient.startColor = .clear
        quoteGradient.endColor = UIColor(hex: "#000000")
        quoteGradient.startLocation = 0.7
        quoteGradient.endLocation = 1.1
        //gradient1.cornerRadius(radius: 24)
        //gradient1.addBorders(color: UIColor(hex: "#f6f6f6"), thickness: 3)
        couplePhoto.addAutoLayoutSubview(quoteGradient)
        quoteGradient.fillSuperview()
        
        couplePhoto.addAutoLayoutSubview(editPhotoButton)
        couplePhoto.addAutoLayoutSubview(addQuote)
        couplePhoto.addAutoLayoutSubview(quoteStack)
        //couplePhoto.addAutoLayoutSubview(quoteLabel)
        couplePhoto.addAutoLayoutSubview(profileViewStack)
        addAutoLayoutSubview(scrollStack)
        
        NSLayoutConstraint.activate([
            editPhotoButton.leftAnchor.constraint(equalTo: couplePhoto.leftAnchor, constant: 12),
            editPhotoButton.topAnchor.constraint(equalTo: couplePhoto.topAnchor,constant: 12),
            addQuote.leftAnchor.constraint(equalTo: couplePhoto.leftAnchor, constant: 12),
            addQuote.bottomAnchor.constraint(equalTo: couplePhoto.bottomAnchor,constant: -25),
            //quoteStack.topAnchor.constraint(equalTo: couplePhoto.topAnchor, constant: 235),
            quoteStack.leftAnchor.constraint(equalTo: couplePhoto.leftAnchor, constant: 16),
            quoteStack.rightAnchor.constraint(equalTo: couplePhoto.rightAnchor, constant: -16),
            quoteStack.bottomAnchor.constraint(equalTo: couplePhoto.bottomAnchor,constant: -8),
            //authorLabel.rightAnchor.constraint(equalTo: couplePhoto.rightAnchor,constant: -55),
           // authorLabel.bottomAnchor.constraint(equalTo: couplePhoto.bottomAnchor, constant: -2),
            profileViewStack.topAnchor.constraint(equalTo: couplePhoto.topAnchor, constant: 12),
            profileViewStack.rightAnchor.constraint(equalTo: couplePhoto.rightAnchor,constant: -12)
            ])
        
        labelStack.axis = .vertical
        goalLabelStack.axis = .vertical
        
        scrollStack.stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollStack.stackView.spacing = 12
        scrollStack.stackView.isLayoutMarginsRelativeArrangement = true
        
        scrollStack.fillSuperview()
        
        weekStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        weekStack.axis = .vertical
        weekStack.spacing = 12
        weekStack.isLayoutMarginsRelativeArrangement = true
        
        currentWeekStack.axis = .horizontal
        currentWeekStack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        currentWeekStack.isLayoutMarginsRelativeArrangement = true
        currentWeekStack.alignment = .center
        currentWeekStack.spacing = 12
        currentWeekStack.cornerRadius(radius: 8)
        
        
//        goalLabelAndArrow.axis = .horizontal
//        currentWeekStack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
//        currentWeekStack.isLayoutMarginsRelativeArrangement = true
//        currentWeekStack.alignment = .center
//        currentWeekStack.spacing = 12

        
        nextPreviousOtherStack.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 10, right: 12)
        nextPreviousOtherStack.isLayoutMarginsRelativeArrangement = true
        nextPreviousOtherStack.alignment = .center
        nextPreviousOtherStack.spacing = 12
        nextPreviousOtherStack.cornerRadius(radius: 8)

        nextPreviousOtherGoalStack.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 10, right: 12)
        nextPreviousOtherGoalStack.isLayoutMarginsRelativeArrangement = true
        nextPreviousOtherGoalStack.spacing = 12
        nextPreviousOtherGoalStack.alignment = .center
        nextPreviousOtherGoalStack.cornerRadius(radius: 8)
        
        imageView.height(constant: 55)
        imageView.width(constant: 55)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        
        goalArrowImageView.height(constant: 20)
        goalArrowImageView.width(constant: 20)
        goalArrowImageView.contentMode = .scaleAspectFit
        goalArrowImageView.tintColor = .black
        
        taskArrowImageView.height(constant: 20)
        taskArrowImageView.width(constant: 20)
        taskArrowImageView.contentMode = .scaleAspectFit
        taskArrowImageView.tintColor = .black

        
        
        goalImageView.height(constant: 55)
        goalImageView.width(constant: 55)
        goalImageView.contentMode = .scaleAspectFit
        goalImageView.tintColor = .black

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

//        nextWeekGoalLabel.text = " Next "
//        nextWeekGoalLabel.width(constant: 80)
//        nextWeekGoalLabel.textAlignment = .center
//        nextWeekGoalLabel.height(constant: 40)
//        nextWeekGoalLabel.cornerRadius(radius: 8)
//
//        previousWeekGoalLabel.text = " Previous "
//        previousWeekGoalLabel.width(constant: 80)
//        previousWeekGoalLabel.textAlignment = .center
//        previousWeekGoalLabel.height(constant: 40)
//        previousWeekGoalLabel.cornerRadius(radius: 8)
//
//        otherWeeksGoalLabel.text = " Other "
//        otherWeeksGoalLabel.textAlignment = .center
//        otherWeeksGoalLabel.width(constant: 80)
//        otherWeeksGoalLabel.height(constant: 40)
//        otherWeeksGoalLabel.cornerRadius(radius: 8)
        
//        currentTaskLabel.text = "Current Week Tasks"
        currentTaskLabel.font = UIFont.systemFont(ofSize: 21)
        currentTaskLabel.attributedText = "Current Week Tasks".underLined

        
        couplePhoto.height(constant: 300)
        couplePhoto.contentMode = .scaleAspectFill
        couplePhoto.layer.masksToBounds = true
        
        goalsStack2.axis = .horizontal
        goalsStack2.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        goalsStack2.isLayoutMarginsRelativeArrangement = true
        goalsStack2.alignment = .center
        goalsStack2.spacing = 12
        goalsStack2.cornerRadius(radius: 8)
        
        goalsStack1.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        goalsStack1.axis = .vertical
        goalsStack1.spacing = 12
        goalsStack1.isLayoutMarginsRelativeArrangement = true

//        goalsLabel.text = "Group Goals of the Week"
        goalsLabel.textAlignment = .left
        goalsLabel.font = UIFont.systemFont(ofSize: 21)
        goalsLabel.numberOfLines = 0
        goalsLabel.attributedText = "Group Goals".underLined

                
        scrollStack.stackView.addArrangedSubviews([couplePhoto, weekStack, goalsStack1])
        
        weekStack.addArrangedSubviews([currentWeekStack, holder])
        
        currentWeekStack.addArrangedSubviews([imageView,labelStack])
        
        holder.addAutoLayoutSubview(nextPreviousOtherStack)
        nextPreviousOtherStack.centerInSuperview()
        nextPreviousOtherStack.heightAnchor.constraint(equalTo: holder.heightAnchor).isActive = true
        
        nextPreviousOtherStack.addArrangedSubviews([previousWeekLabel, nextWeekLabel, otherWeeksLabel])
        
        labelStack.addArrangedSubviews([taskLabelAndArrow, openTaskLabel, finishedTaskLabel])
        
        taskLabelAndArrow.addArrangedSubviews([currentTaskLabel, taskArrowImageView])
        taskLabelAndArrow.height(constant: 25)
        
        goalsStack1.addArrangedSubviews([ goalsStack2, holder2 ])
        
        goalsStack2.addArrangedSubviews([ goalImageView, goalLabelStack ])
        
        goalLabelStack.addArrangedSubviews([ goalLabelAndArrow, openGoalLabel, finishedGoalLabel ])
        
        goalLabelAndArrow.addArrangedSubviews([goalsLabel, goalArrowImageView])
        goalLabelAndArrow.height(constant: 25)

        
//        holder2.addAutoLayoutSubview(nextPreviousOtherGoalStack)
//        nextPreviousOtherGoalStack.centerInSuperview()
//        nextPreviousOtherGoalStack.heightAnchor.constraint(equalTo: holder2.heightAnchor).isActive = true
//
//        nextPreviousOtherGoalStack.addArrangedSubviews([ previousWeekGoalLabel, nextWeekGoalLabel, otherWeeksGoalLabel,])
}
}
protocol ProfileViewDelegate: AnyObject {
    func updateProfileView(image: UIImage?, emoji: String?, uid: String)
}

class ProfileView: UIView {
    
    let profileStack = UIStackView()
    private let emojiHolder = UIView()
    var emojiImage = UIImageView()
    var emojiString: String?
    weak var delegate: ProfileViewDelegate?
    let profileImage = UIImageView(image: UIImage(systemName: "person.fill"))
    let uid: String
    
    init(uid: String) {
        self.uid = uid
        super.init(frame: .zero)
        
        configureSubviews()
        configureLayout()
        loadProfileImage()
        loadEmojiImage()
        setUpDidTaps()
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
    
    
    private func setUpDidTaps() {
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
