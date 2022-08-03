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
    let textfield = LimitedLengthField()

    private let holder = UIView()
    private let holder2 = UIView()
    private let imageView = UIImageView(image: UIImage(systemName: "list.bullet.rectangle"))
    private let goalImageView = UIImageView(image: UIImage(systemName: "list.bullet.rectangle"))
    private let hiarchyStack = UIStackView()
    private let currentWeekTaskLabel = UILabel()
    
    private let scrollStack = ScrollableStackView()
    private let weekStack = UIStackView()
    private let nextPreviousOtherGoalStack = UIStackView()
    private let nextPreviousOtherStack = UIStackView()
    private let currentTaskLabel = UnderlinedLabel()
    private let labelStack = UIStackView()
    private let testStack = UIStackView()

    private let goalLabelStack = UIStackView()
    private let quoteStack = UIStackView()
    private let quoteOfTheWeek = UnderlinedLabel()
    private let imageStack = UIStackView()
    private let imageLabel = UnderlinedLabel()
    private let goalsStack1 = UIStackView()
    private let goalsLabel = UnderlinedLabel()

    func setColors() {
        authorLabel.quickConfigure(textAlignment: .right, font: .boldSystemFont(ofSize: 12), textColor: .mainColor6)
        editPhotoButton.addBorders(color: .mainColor6, thickness: 1)
        editLabel.quickConfigure(textAlignment: .center, font: .systemFont(ofSize:12), textColor: .mainColor6)
        addQuote.addBorders(color: .mainColor6, thickness: 1)
        labelquote.quickConfigure(textAlignment: .center, font: .systemFont(ofSize:12), textColor: .mainColor6)
        
        quoteImage.tintColor = .mainColor6
        quoteLabel.textColor = .mainColor6
        camera.tintColor = .mainColor6
        
        for color in [previousWeekLabel, previousWeekGoalLabel, nextWeekLabel, nextWeekGoalLabel, otherWeeksLabel, otherWeeksGoalLabel, openGoalLabel, openTaskLabel, finishedGoalLabel, finishedTaskLabel] {
            color.textColor = .mainColor1
        }
        for backgroundColor in [weekStack, imageStack, goalsStack1, quoteStack] {
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
        couplePhoto.backgroundColor = .darkGray

        editPhotoButton.axis = .horizontal
        editPhotoButton.alignment = .center
        editPhotoButton.layoutMargins = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        editPhotoButton.isLayoutMarginsRelativeArrangement = true
        editPhotoButton.cornerRadius(radius: 5)
        editPhotoButton.addArrangedSubviews([camera, editLabel])
        editLabel.text = "Edit"
        
        addQuote.axis = .horizontal
        addQuote.alignment = .center
        addQuote.layoutMargins = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        addQuote.isLayoutMarginsRelativeArrangement = true
        addQuote.cornerRadius(radius: 5)
        addQuote.addArrangedSubviews([quoteImage, labelquote])
        labelquote.text = "+"
        quoteLabel.textAlignment = .left
        quoteLabel.font = .boldSystemFont(ofSize: 12)
        quoteLabel.numberOfLines = 2
        
        addAutoLayoutSubview(couplePhoto)
        couplePhoto.addAutoLayoutSubview(editPhotoButton)
        couplePhoto.addAutoLayoutSubview(addQuote)
        couplePhoto.addAutoLayoutSubview(authorLabel)
        couplePhoto.addAutoLayoutSubview(quoteLabel)
        couplePhoto.addAutoLayoutSubview(profileViewStack)
        addAutoLayoutSubview(scrollStack)
        
        NSLayoutConstraint.activate([
            editPhotoButton.leftAnchor.constraint(equalTo: couplePhoto.leftAnchor, constant: 12),
            editPhotoButton.topAnchor.constraint(equalTo: couplePhoto.topAnchor,constant: 12),
            addQuote.leftAnchor.constraint(equalTo: couplePhoto.leftAnchor, constant: 12),
            addQuote.bottomAnchor.constraint(equalTo: couplePhoto.bottomAnchor,constant: -16),
            quoteLabel.topAnchor.constraint(equalTo: couplePhoto.topAnchor, constant: 250),
            quoteLabel.leftAnchor.constraint(equalTo: couplePhoto.leftAnchor, constant: 55),
            quoteLabel.rightAnchor.constraint(equalTo: couplePhoto.rightAnchor, constant: -3),
            quoteLabel.bottomAnchor.constraint(equalTo: couplePhoto.bottomAnchor,constant: -8),
            authorLabel.rightAnchor.constraint(equalTo: couplePhoto.rightAnchor,constant: -55),
            authorLabel.bottomAnchor.constraint(equalTo: couplePhoto.bottomAnchor),
            profileViewStack.topAnchor.constraint(equalTo: couplePhoto.topAnchor, constant: 12),
            profileViewStack.rightAnchor.constraint(equalTo: couplePhoto.rightAnchor,constant: -12)
            ])
        
        labelStack.axis = .vertical
        goalLabelStack.axis = .vertical
        
        scrollStack.stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollStack.stackView.isLayoutMarginsRelativeArrangement = true
        
        scrollStack.fillSuperview()
        
        weekStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        weekStack.axis = .vertical
        weekStack.spacing = 12
        weekStack.isLayoutMarginsRelativeArrangement = true
        textfield.placeholder = "Enter One Emoji"
        textfield.borderStyle = .line
        
        currentWeekStack.axis = .horizontal
        currentWeekStack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        currentWeekStack.isLayoutMarginsRelativeArrangement = true
        currentWeekStack.alignment = .center
        currentWeekStack.spacing = 12
        currentWeekStack.cornerRadius(radius: 8)
        
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
        
        goalImageView.height(constant: 55)
        goalImageView.width(constant: 55)
        goalImageView.contentMode = .scaleAspectFit
        goalImageView.tintColor = .black

        nextWeekLabel.text = " Next "
        nextWeekLabel.textAlignment = .center
        nextWeekLabel.height(constant: 40)
        nextWeekLabel.width(constant: 80)
        nextWeekLabel.cornerRadius(radius: 8)
        
        previousWeekLabel.text = " Previous "
        previousWeekLabel.textAlignment = .center
        previousWeekLabel.height(constant: 40)
        previousWeekLabel.width(constant: 80)
        previousWeekLabel.cornerRadius(radius: 8)
        
        otherWeeksLabel.text = " Other "
        otherWeeksLabel.textAlignment = .center
        otherWeeksLabel.height(constant: 40)
        otherWeeksLabel.width(constant: 80)
        otherWeeksLabel.cornerRadius(radius: 8)

        nextWeekGoalLabel.text = " Next "
        nextWeekGoalLabel.width(constant: 80)
        nextWeekGoalLabel.textAlignment = .center
        nextWeekGoalLabel.height(constant: 40)
        nextWeekGoalLabel.cornerRadius(radius: 8)

        previousWeekGoalLabel.text = " Previous "
        previousWeekGoalLabel.width(constant: 80)
        previousWeekGoalLabel.textAlignment = .center
        previousWeekGoalLabel.height(constant: 40)
        previousWeekGoalLabel.cornerRadius(radius: 8)
                
        otherWeeksGoalLabel.text = " Other "
        otherWeeksGoalLabel.textAlignment = .center
        otherWeeksGoalLabel.width(constant: 80)
        otherWeeksGoalLabel.height(constant: 40)
        otherWeeksGoalLabel.cornerRadius(radius: 8)
        
        currentTaskLabel.text = "Current Week Tasks"
        currentTaskLabel.font = UIFont.systemFont(ofSize: 21)
        
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

        goalsLabel.text = "Group's Goals of the Week"
        goalsLabel.textAlignment = .left
        goalsLabel.font = UIFont.systemFont(ofSize: 21)
        goalsLabel.numberOfLines = 0
                
        scrollStack.stackView.addArrangedSubviews([couplePhoto, weekStack, goalsStack1])
        
        weekStack.addArrangedSubviews([currentWeekStack, textfield,holder])
        
        currentWeekStack.addArrangedSubviews([imageView,labelStack])
        
        holder.addAutoLayoutSubview(nextPreviousOtherStack)
        nextPreviousOtherStack.centerInSuperview()
        nextPreviousOtherStack.heightAnchor.constraint(equalTo: holder.heightAnchor).isActive = true
        
        nextPreviousOtherStack.addArrangedSubviews([previousWeekLabel, nextWeekLabel, otherWeeksLabel])
        
        labelStack.addArrangedSubviews([currentTaskLabel, openTaskLabel, finishedTaskLabel])
        
        goalsStack1.addArrangedSubviews([ goalsStack2, holder2 ])
        
        goalsStack2.addArrangedSubviews([ goalImageView, goalLabelStack ])
        
        goalLabelStack.addArrangedSubviews([ goalsLabel, openGoalLabel, finishedGoalLabel ])
        holder2.addAutoLayoutSubview(nextPreviousOtherGoalStack)
        nextPreviousOtherGoalStack.centerInSuperview()
        nextPreviousOtherGoalStack.heightAnchor.constraint(equalTo: holder2.heightAnchor).isActive = true
        
        nextPreviousOtherGoalStack.addArrangedSubviews([ previousWeekGoalLabel, nextWeekGoalLabel, otherWeeksGoalLabel,])
}
}
protocol ProfileViewDelegate: AnyObject {
    func updateProfileView(image: UIImage?, emoji: String?)
}

class ProfileView: UIView {
    
    let profileStack = UIStackView()
    var emojiImage = UIImageView()
    var emojiString: String?
    weak var delegate: ProfileViewDelegate?
    let profileImage = UIImageView(image: UIImage(systemName: "person.fill"))
    let emojiFace = "\u{1F600}"
    var emojiImageTest = UIImageView()
    let uid: String
    
    init(uid: String) {
        self.uid = uid
        super.init(frame: .zero)
        
        configureSubviews()
        configureLayout()
        loadProfileImage()
        loadEmojiImage()
        setUpDidTaps()
        practiceConvertingEmoji()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadProfileImage() {
        if let data = UserDefaults.standard.data(forKey: "profileImage") {
            let image = UIImage.init(data: data)
            self.profileImage.image = image
        }
        
        FirebaseAPI.downloadProfileImage(uid: uid) {image in
            if image != nil {
                self.profileImage.image = image
            }
            if let data = image?.jpegData(compressionQuality: 0.7) {
                UserDefaults.standard.set(data, forKey: "profileImage")
            }
            UIView.animate(withDuration: 0.5, animations: {
            })
        }
    }
    
    private func loadEmojiImage() {
        
        //need to figure out how to do cache for string
        
        FirebaseAPI.getEmoji(uid: uid) {emojiString in
            if emojiString != nil {
                self.emojiString = emojiString
                self.emojiImage.image = emojiString?.textToImage()
           }
        }
    }

    @objc private func didTapProfileImage() {
        delegate?.updateProfileView(image: profileImage.image, emoji: emojiString)
    }
    @objc private func didTapEmojiImage() {
        delegate?.updateProfileView(image: profileImage.image, emoji: emojiString)
    }
    private func practiceConvertingEmoji() {
        if let newImage = emojiFace.textToImage() {
            emojiImageTest.image = newImage
        }
    }
    private func downloadProfileImage() {
//        if let data = UserDefaults.standard.data(forKey: "profileImage") {
//            let image = UIImage.init(data: data)
//            self.baseView.profilePhoto.image = image
//        }
//        if let uid = FirebaseAPI.currentUserUID() {
//            FirebaseAPI.downloadProfileImages(uid: uid) {
//                image in
//                if image == nil {
//                    return
//                }
//                self.baseView.profilePhoto.image = image
//                if let data = image?.jpegData(compressionQuality: 0.7) {
//                    UserDefaults.standard.set(data, forKey: "profileImage")
//                }
//                UIView.animate(withDuration: 0.5, animations: {
//                })
//            }
//        }
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
        profileImage.addBorders(color: .mainColor6, thickness: 5)
        emojiImage.addBorders(color: .mainColor6, thickness: 3)
        profileImage.tintColor = .mainColor6
    }
    
    private func configureLayout() {
        profileStack.alignment = .top
        profileStack.axis = .horizontal
        profileStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        profileStack.spacing = -20
        profileStack.isLayoutMarginsRelativeArrangement = true
        profileStack.addArrangedSubviews([profileImage, emojiImage])
        
        profileImage.height(constant: 75)
        profileImage.width(constant: 75)
        profileImage.cornerRadius(radius: 37.5)
        profileImage.backgroundColor = .black        

        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.masksToBounds = true
        
        emojiImage.height(constant: 26)
        emojiImage.width(constant: 26)
        emojiImage.cornerRadius(radius: 13)
        
        addAutoLayoutSubview(profileStack)
        profileStack.fillSuperview()
    }
}
