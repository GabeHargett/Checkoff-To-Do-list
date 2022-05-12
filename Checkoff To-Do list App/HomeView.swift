//
//  HomeView.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 5/12/22.
//

import UIKit

class HomeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        setupStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    private let nextWeekLabel = UILabel()
    private let previousWeekLabel = UILabel()
    private let otherWeeksLabel = UILabel()
    private let openTaskLabel = UILabel()
    private let finishedTaskLabel = UILabel()
    
    private let nextWeekGoalLabel = UILabel()
    private let previousWeekGoalLabel = UILabel()
    private let otherWeeksGoalLabel = UILabel()

    private let imageView = UIImageView(image: UIImage(systemName: "list.bullet.rectangle"))
    private let goalImageView = UIImageView(image: UIImage(systemName: "list.bullet.rectangle"))
    private let hiarchyStack = UIStackView()
    private let currentWeekTaskLabel = UILabel()
    
    private let goalsAddButton = CustomButton(type: .imageAndLabel)
    private let plusButton = CustomButton(type: .image)
    private let imageButton = CustomButton(type: .image)
    private let pencilQuoteButton = CustomButton(type: .image)
    private let imageAddButton = CustomButton(type: .imageAndLabel)
    private let quoteButton = CustomButton(type: .imageAndLabel)

    private let quoteLabel = UILabel()
    private let quoteSignature = UILabel()

    private let couplePhoto = UIImageView()
    private let scrollStack = ScrollableStackView()
    private let currecntWeekPreviousOtherStack = UIStackView()
    private let currentWeekStack = UIStackView()
    private let nextPreviousOtherGoalStack = UIStackView()
    private let nextPreviousOtherStack = UIStackView()
    private let currentTaskLabel = UnderlinedLabel()
    private let labelStack = UIStackView()
    private let quoteStack = UIStackView()
    private let quoteOfTheWeek = UnderlinedLabel()
    private let imageStack = UIStackView()
    private let imageAddOnStack = UnderlinedLabel()
    private let goalsStack1 = UIStackView()
    private let goalsStack2 = UIStackView()
    private let goalsLabel = UnderlinedLabel()
    private let quoteStackWithPencil = UIStackView()
    private let imageStackWithPencil = UIStackView ()



    private func setupStackView() {
                
        labelStack.axis = .vertical
        
        scrollStack.stackView.spacing = 12
        scrollStack.stackView.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        scrollStack.stackView.isLayoutMarginsRelativeArrangement = true
        
        addAutoLayoutSubview(scrollStack)
        scrollStack.fillSuperview()
        
        currecntWeekPreviousOtherStack.addBorders(color: .black, thickness: 1)
        currecntWeekPreviousOtherStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        currecntWeekPreviousOtherStack.axis = .vertical
        currecntWeekPreviousOtherStack.spacing = 12
        currecntWeekPreviousOtherStack.isLayoutMarginsRelativeArrangement = true
        currecntWeekPreviousOtherStack.cornerRadius(radius: 8)

        
        currentWeekStack.axis = .horizontal
        currentWeekStack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        currentWeekStack.isLayoutMarginsRelativeArrangement = true
        currentWeekStack.alignment = .center
        currentWeekStack.spacing = 12
        currentWeekStack.cornerRadius(radius: 8)
        
        nextPreviousOtherStack.axis = .horizontal
        nextPreviousOtherStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 16)
        nextPreviousOtherStack.isLayoutMarginsRelativeArrangement = true
        nextPreviousOtherStack.alignment = .center
        nextPreviousOtherStack.spacing = 12
        nextPreviousOtherStack.cornerRadius(radius: 8)

        nextPreviousOtherGoalStack.axis = .horizontal
        nextPreviousOtherGoalStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        nextPreviousOtherGoalStack.isLayoutMarginsRelativeArrangement = true
        nextPreviousOtherGoalStack.alignment = .center
        nextPreviousOtherGoalStack.spacing = 12
        nextPreviousOtherGoalStack.cornerRadius(radius: 8)

        
        imageView.height(constant: 64)
        imageView.width(constant: 64)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        
        goalImageView.height(constant: 64)
        goalImageView.width(constant: 64)
        goalImageView.contentMode = .scaleAspectFit
        goalImageView.tintColor = .black

        
        nextWeekLabel.text = " Next Week "
        nextWeekLabel.addBorders(color: .black, thickness: 1)
        nextWeekLabel.height(constant: 40)
        nextWeekLabel.layer.cornerRadius = 8
        
        previousWeekLabel.text = " Previous Week "
        previousWeekLabel.addBorders(color: .black, thickness: 1)
        previousWeekLabel.height(constant: 40)
        previousWeekLabel.cornerRadius(radius: 8)
        
        otherWeeksLabel.text = " Other Weeks "
        otherWeeksLabel.addBorders(color: .black, thickness: 1)
        otherWeeksLabel.height(constant: 40)
        otherWeeksLabel.cornerRadius(radius: 8)
        
        nextWeekGoalLabel.text = " Next Week "
        nextWeekGoalLabel.addBorders(color: .black, thickness: 1)
        nextWeekGoalLabel.height(constant: 40)
        nextWeekGoalLabel.layer.cornerRadius = 8
        
        previousWeekGoalLabel.text = " Previous Week "
        previousWeekGoalLabel.addBorders(color: .black, thickness: 1)
        previousWeekGoalLabel.height(constant: 40)
        previousWeekGoalLabel.cornerRadius(radius: 8)
                
        otherWeeksGoalLabel.text = " Other Weeks "
        otherWeeksGoalLabel.addBorders(color: .black, thickness: 1)
        otherWeeksGoalLabel.height(constant: 40)
        otherWeeksGoalLabel.cornerRadius(radius: 8)


        
        currentTaskLabel.text = "Current Week Tasks"
        currentTaskLabel.font = UIFont.systemFont(ofSize: 21)
        
        openTaskLabel.text = "3 open task"
        
        finishedTaskLabel.text = "4 finished task"
        
        quoteStack.addBorders(color: .black, thickness: 1)
        quoteStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 16)
        quoteStack.axis = .vertical
        quoteStack.spacing = 12
        quoteStack.isLayoutMarginsRelativeArrangement = true
        quoteStack.cornerRadius(radius: 8)
        
        quoteStackWithPencil.layoutMargins = UIEdgeInsets(top: 10, left: 8, bottom: 0, right: 16)
        quoteStackWithPencil.axis = .horizontal
        quoteStackWithPencil.spacing = 0
        quoteStackWithPencil.isLayoutMarginsRelativeArrangement = true
                
        quoteOfTheWeek.text = "Quote of the week"
        quoteOfTheWeek.textAlignment = .center
        quoteOfTheWeek.font = UIFont.systemFont(ofSize: 21)
        
        quoteButton.setImage(image:UIImage(systemName: "quote.bubble"),color:.systemGray)
        quoteButton.setTitle(title: "Tap Here to Insert A Quote")
        quoteButton.setImageWidth(size: 26)
        quoteButton.setImageHeight(size: 26)
        quoteButton.quickConfigure(
                    font: .systemFont(ofSize: 15), titleColor: .black, backgroundColor: .systemGray4, cornerRadius: 8)
        quoteButton.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        quoteButton.isUserInteractionEnabled = true

        quoteLabel.textAlignment = .left
        quoteLabel.numberOfLines = 0
        quoteLabel.font = UIFont.systemFont(ofSize: 20)

        quoteSignature.textAlignment = .right
        quoteSignature.font = UIFont.systemFont(ofSize: 15)
        
        
        imageStack.addBorders(color: .black, thickness: 1)
        imageStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 16)
        imageStack.axis = .vertical
        imageStack.spacing = 12
        imageStack.isLayoutMarginsRelativeArrangement = true
        imageStack.cornerRadius(radius: 8)
        
        imageStackWithPencil.layoutMargins = UIEdgeInsets(top: 10, left: 8, bottom: 0, right: 16)
        imageStackWithPencil.axis = .horizontal
        imageStackWithPencil.isLayoutMarginsRelativeArrangement = true
                
        plusButton.setImage(image:UIImage(systemName: "plus"),color:.systemGray)
        plusButton.setImageWidth(size: 22)
        plusButton.setImageHeight(size: 22)
        plusButton.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        plusButton.quickConfigure(font: .systemFont(ofSize: 15), titleColor: .black, backgroundColor: .systemGray4, cornerRadius: 8)
        plusButton.isUserInteractionEnabled = true

        imageButton.setImage(image:UIImage(systemName: "photo"),color:.systemGray)
        imageButton.setImageWidth(size: 25)
        imageButton.setImageHeight(size: 25)
        imageButton.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        imageButton.quickConfigure(font: .systemFont(ofSize: 15), titleColor: .black, backgroundColor: .systemGray4, cornerRadius: 8)
        imageButton.isUserInteractionEnabled = true

        pencilQuoteButton.setImage(image:UIImage(systemName: "pencil"),color:.systemGray)
        pencilQuoteButton.setImageWidth(size: 25)
        pencilQuoteButton.setImageHeight(size: 25)
        pencilQuoteButton.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        pencilQuoteButton.quickConfigure(font: .systemFont(ofSize: 15), titleColor: .black, backgroundColor: .systemGray4, cornerRadius: 8)
        pencilQuoteButton.isUserInteractionEnabled = true

        
        imageAddOnStack.text = "Couple Picture of the Week"
        imageAddOnStack.textAlignment = .center
        imageAddOnStack.font = UIFont.systemFont(ofSize: 21)

        imageAddButton.setImage(image:UIImage(systemName: "photo"),color:.systemGray)
        imageAddButton.setTitle(title: "Tap Here To Insert Your Picture")
        imageAddButton.setImageWidth(size: 26)
        imageAddButton.setImageHeight(size: 26)
        imageAddButton.quickConfigure(
                    font: .systemFont(ofSize: 15), titleColor: .black, backgroundColor: .systemGray4, cornerRadius: 8)
        imageAddButton.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        imageAddButton.isUserInteractionEnabled = true
        
        couplePhoto.isHidden = true
        couplePhoto.cornerRadius(radius: 8)
        couplePhoto.addBorders(color: .black, thickness: 1)
        couplePhoto.height(constant: 300)
        
        goalsStack2.axis = .horizontal
        goalsStack2.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        goalsStack2.isLayoutMarginsRelativeArrangement = true
        goalsStack2.alignment = .center
        goalsStack2.spacing = 12
        goalsStack2.cornerRadius(radius: 8)
        
        goalsStack1.addBorders(color: .black, thickness: 1)
        goalsStack1.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        goalsStack1.axis = .vertical
        goalsStack1.spacing = 12
        goalsStack1.isLayoutMarginsRelativeArrangement = true
        goalsStack1.cornerRadius(radius: 8)

        goalsLabel.text = "Couple Goals of the Week"
        goalsLabel.textAlignment = .center
        goalsLabel.font = UIFont.systemFont(ofSize: 21)
                
        scrollStack.stackView.addArrangedSubviews([
            currecntWeekPreviousOtherStack,
            imageStack,
            goalsStack1,
            quoteStack
        ])
        
        currecntWeekPreviousOtherStack.addArrangedSubviews([
            currentWeekStack,
            nextPreviousOtherStack,
        ])
        
        currentWeekStack.addArrangedSubviews([
            imageView,
            labelStack
        ])
        
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
            imageAddButton,
            couplePhoto
        ])
                
        imageStackWithPencil.addArrangedSubviews([
            imageButton,
            imageAddOnStack
        ])
        
        goalsStack1.addArrangedSubviews([
            goalsStack2,
            nextPreviousOtherGoalStack
        ])
        
        goalsStack2.addArrangedSubviews([
            goalImageView,
            goalsLabel
        ])
        
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
