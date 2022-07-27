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

    let imageButton = CustomButton(type: .image)
    let imageAddButton = CustomButton(type: .imageAndLabel)

    let couplePhoto = UIImageView()
    
    let pencilQuoteButton = CustomButton(type: .image)
    let quoteButton = CustomButton(type: .imageAndLabel)
    
    let quoteLabel = UILabel()
    let quoteLabel2 = UILabel()
    let authorLabel = UILabel()
    let quoteSignature = UILabel()
    
    let camera = UIImageView(image: UIImage(systemName: "camera.fill"))
    let editPhotoButton = UIStackView()
    let editLabel = UILabel()
    let quoteImage = UIImageView(image: UIImage(systemName: "message.fill"))
    let addQuote = UIStackView()
    let labelquote = UILabel()


    
    private let holder = UIView()
    private let holder2 = UIView()
    private let photoView = UIView()
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
    private let quoteStackWithPencil = UIStackView()
    private let imageStackWithPencil = UIStackView ()


    func setColors() {
        imageButton.quickConfigure(font: .systemFont(ofSize: 15), titleColor: .black, backgroundColor: .mainColor4, cornerRadius: 8)
        pencilQuoteButton.quickConfigure(font: .systemFont(ofSize: 15), titleColor: .black, backgroundColor: .mainColor4, cornerRadius: 8)
        imageAddButton.quickConfigure(
            font: .systemFont(ofSize: 15), titleColor: .black, backgroundColor: .mainColor4, cornerRadius: 8)
        quoteButton.quickConfigure(
            font: .systemFont(ofSize: 15), titleColor: .black, backgroundColor: .mainColor1, cornerRadius: 8)
        authorLabel.quickConfigure(textAlignment: .right, font: .boldSystemFont(ofSize: 12), textColor: .mainColor6)
        quoteLabel2.textColor = .mainColor6
        
        camera.tintColor = .mainColor6
        editPhotoButton.addBorders(color: .mainColor6, thickness: 1)
        editLabel.quickConfigure(textAlignment: .center, font: .systemFont(ofSize:12), textColor: .mainColor6)
        
        quoteImage.tintColor = .mainColor6
        addQuote.addBorders(color: .mainColor6, thickness: 1)
        labelquote.quickConfigure(textAlignment: .center, font: .systemFont(ofSize:12), textColor: .mainColor6)

        
        for color in [previousWeekLabel, previousWeekGoalLabel, nextWeekLabel, nextWeekGoalLabel, otherWeeksLabel, otherWeeksGoalLabel, openGoalLabel, openTaskLabel, finishedGoalLabel, finishedTaskLabel, quoteSignature, quoteLabel] {
            color.textColor = .mainColor1
        }
        for backgroundColor in [weekStack, imageStack, goalsStack1, quoteStack] {
            backgroundColor.backgroundColor = .mainColor6
        }
        for backgroundColor in [quoteButton, previousWeekLabel, previousWeekGoalLabel, nextWeekLabel, nextWeekGoalLabel, otherWeeksLabel, otherWeeksGoalLabel] {
            backgroundColor.backgroundColor = .mainColor4
        }
    }
    
    private func setupView() {
        for view in [couplePhoto, addQuote, editPhotoButton, currentWeekStack, previousWeekLabel, nextWeekLabel, otherWeeksLabel, goalsStack2, previousWeekGoalLabel, nextWeekGoalLabel,
                     otherWeeksGoalLabel, quoteButton, pencilQuoteButton, imageAddButton, imageButton] {
            view.isUserInteractionEnabled = true
        }
        if couplePhoto.isHidden == true {
            photoView.addAutoLayoutSubview(editPhotoButton)
            photoView.addAutoLayoutSubview(addQuote)
        }
        else {
            couplePhoto.addAutoLayoutSubview(addQuote)
            couplePhoto.addAutoLayoutSubview(editPhotoButton)
        }
        
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
        quoteLabel2.textAlignment = .left
        quoteLabel2.font = .boldSystemFont(ofSize: 12)
        quoteLabel2.numberOfLines = 2

        photoView.addAutoLayoutSubview(couplePhoto)
        couplePhoto.addAutoLayoutSubview(authorLabel)
        couplePhoto.addAutoLayoutSubview(quoteLabel2)
        addAutoLayoutSubview(photoView)
        addAutoLayoutSubview(scrollStack)
        
        NSLayoutConstraint.activate([
            editPhotoButton.leftAnchor.constraint(equalTo: photoView.leftAnchor, constant: 12),
            editPhotoButton.topAnchor.constraint(equalTo: photoView.topAnchor,constant: 12),
            addQuote.leftAnchor.constraint(equalTo: photoView.leftAnchor, constant: 12),
            addQuote.bottomAnchor.constraint(equalTo: photoView.bottomAnchor,constant: -16),
            couplePhoto.bottomAnchor.constraint(equalTo: photoView.bottomAnchor),
            couplePhoto.topAnchor.constraint(equalTo: photoView.topAnchor),
            couplePhoto.rightAnchor.constraint(equalTo: photoView.rightAnchor),
            couplePhoto.leftAnchor.constraint(equalTo: photoView.leftAnchor),
            quoteLabel2.topAnchor.constraint(equalTo: couplePhoto.topAnchor, constant: 250),
            quoteLabel2.leftAnchor.constraint(equalTo: couplePhoto.leftAnchor, constant: 55),
            quoteLabel2.rightAnchor.constraint(equalTo: couplePhoto.rightAnchor, constant: -3),
            quoteLabel2.bottomAnchor.constraint(equalTo: couplePhoto.bottomAnchor,constant: -8),
            authorLabel.rightAnchor.constraint(equalTo: couplePhoto.rightAnchor,constant: -36),
            authorLabel.bottomAnchor.constraint(equalTo: couplePhoto.bottomAnchor)
            ])
        
        labelStack.axis = .vertical
        goalLabelStack.axis = .vertical

        
//        scrollStack.stackView.spacing = 12
        scrollStack.stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollStack.stackView.isLayoutMarginsRelativeArrangement = true
        
        scrollStack.fillSuperview()
        photoView.height(constant: 300)
        photoView.backgroundColor = .systemGray4
        
//        weekStack.addBorders(color: .black, thickness: 1)
        weekStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        weekStack.axis = .vertical
        weekStack.spacing = 12
        weekStack.isLayoutMarginsRelativeArrangement = true
//        weekStack.cornerRadius(radius: 8)

        
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
                
//        quoteStack.addBorders(color: .black, thickness: 1)
        quoteStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 16)
        quoteStack.axis = .vertical
        quoteStack.spacing = 12
        quoteStack.isLayoutMarginsRelativeArrangement = true
//        quoteStack.cornerRadius(radius: 8)
        
        
        quoteStackWithPencil.axis = .horizontal
        quoteStackWithPencil.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 16)
        quoteStackWithPencil.isLayoutMarginsRelativeArrangement = true
        quoteStackWithPencil.spacing = 20

                
        quoteOfTheWeek.text = "Quote of the week"
        quoteOfTheWeek.textAlignment = .left
        quoteOfTheWeek.font = UIFont.systemFont(ofSize: 21)
        
        quoteButton.setImage(image:UIImage(systemName: "quote.bubble"),color:.systemGray)
        quoteButton.setTitle(title: "Tap Here to Insert Quote")
        quoteButton.setImageWidth(size: 26)
        quoteButton.setImageHeight(size: 26)
        quoteButton.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        quoteButton.quickConfigure(
            font: .systemFont(ofSize: 15), titleColor: .black, backgroundColor: .black, cornerRadius: 8)


        quoteLabel.textAlignment = .center
        quoteLabel.numberOfLines = 0
        quoteLabel.font = UIFont.systemFont(ofSize: 20)

        quoteSignature.textAlignment = .right
        quoteSignature.font = UIFont.systemFont(ofSize: 15)
        
        
//        imageStack.addBorders(color: .black, thickness: 1)
        imageStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 16)
        imageStack.axis = .vertical
        imageStack.spacing = 12
        imageStack.isLayoutMarginsRelativeArrangement = true
//        imageStack.cornerRadius(radius: 8)
        
        imageStackWithPencil.axis = .horizontal
        imageStackWithPencil.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 16)
        imageStackWithPencil.isLayoutMarginsRelativeArrangement = true
        imageStackWithPencil.alignment = .leading
        imageStackWithPencil.spacing = 20


        imageButton.setImage(image:UIImage(systemName: "photo"),color:.systemGray)
        imageButton.setImageWidth(size: 25)
        imageButton.setImageHeight(size: 25)
        imageButton.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)


        pencilQuoteButton.setImage(image:UIImage(systemName: "pencil"),color:.systemGray)
        pencilQuoteButton.setImageWidth(size: 25)
        pencilQuoteButton.setImageHeight(size: 25)
        pencilQuoteButton.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        pencilQuoteButton.quickConfigure(font: .systemFont(ofSize: 15), titleColor: .black, backgroundColor: .systemGray4, cornerRadius: 8)

        
        imageLabel.text = "Couple Picture of the Week"
        imageLabel.textAlignment = .left
        imageLabel.font = UIFont.systemFont(ofSize: 21)
        imageLabel.numberOfLines = 0

        imageAddButton.setImage(image:UIImage(systemName: "camera"),color:.mainColor5)
        imageAddButton.setTitle(title: "Edit")
        imageAddButton.setImageWidth(size: 24)
        imageAddButton.setImageHeight(size: 24)
        imageAddButton.layoutMargins = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)

        couplePhoto.isHidden = true
//        couplePhoto.cornerRadius(radius: 8)
//        couplePhoto.addBorders(color: .black, thickness: 1)
        couplePhoto.height(constant: 300)
        couplePhoto.contentMode = .scaleAspectFill
        couplePhoto.layer.masksToBounds = true
        
        goalsStack2.axis = .horizontal
        goalsStack2.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        goalsStack2.isLayoutMarginsRelativeArrangement = true
        goalsStack2.alignment = .center
        goalsStack2.spacing = 12
        goalsStack2.cornerRadius(radius: 8)
        
//        goalsStack1.addBorders(color: .black, thickness: 1)
        goalsStack1.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        goalsStack1.axis = .vertical
        goalsStack1.spacing = 12
        goalsStack1.isLayoutMarginsRelativeArrangement = true
//        goalsStack1.cornerRadius(radius: 8)

        goalsLabel.text = "Couple Goals of the Week"
        goalsLabel.textAlignment = .left
        goalsLabel.font = UIFont.systemFont(ofSize: 21)
        goalsLabel.numberOfLines = 0
                
        scrollStack.stackView.addArrangedSubviews([
            photoView,
            weekStack,
            goalsStack1,
            imageStack,
            quoteStack
        ])
        
        weekStack.addArrangedSubviews([
            currentWeekStack,
            holder,
        ])
        
        currentWeekStack.addArrangedSubviews([
            imageView,
            labelStack
        ])
        
        holder.addAutoLayoutSubview(nextPreviousOtherStack)
        nextPreviousOtherStack.centerInSuperview()
        nextPreviousOtherStack.heightAnchor.constraint(equalTo: holder.heightAnchor).isActive = true
        
        nextPreviousOtherStack.addArrangedSubviews([
            previousWeekLabel,
            nextWeekLabel,
            otherWeeksLabel,
        ])
        
        labelStack.addArrangedSubviews([
            currentTaskLabel,
            openTaskLabel,
            finishedTaskLabel
        ])
        
        imageStack.addArrangedSubviews([
            imageStackWithPencil,
//            couplePhoto
        ])
                
        imageStackWithPencil.addArrangedSubviews([
            imageButton,
            imageLabel
        ])
        
        goalsStack1.addArrangedSubviews([
            goalsStack2,
            holder2
        ])
        
        
        goalsStack2.addArrangedSubviews([
            goalImageView,
            goalLabelStack
        ])
        
        goalLabelStack.addArrangedSubviews([
            goalsLabel,
            openGoalLabel,
            finishedGoalLabel
        
        ])
        holder2.addAutoLayoutSubview(nextPreviousOtherGoalStack)
        nextPreviousOtherGoalStack.centerInSuperview()
        nextPreviousOtherGoalStack.heightAnchor.constraint(equalTo: holder2.heightAnchor).isActive = true

        
        nextPreviousOtherGoalStack.addArrangedSubviews([
            previousWeekGoalLabel,
            nextWeekGoalLabel,
            otherWeeksGoalLabel,
        ])

        
        quoteStack.addArrangedSubviews([
            quoteStackWithPencil,
            quoteButton,
            quoteLabel,
            quoteSignature
        ])
        
        quoteStackWithPencil.addArrangedSubviews([
            pencilQuoteButton,
            quoteOfTheWeek
        ])
}
}
