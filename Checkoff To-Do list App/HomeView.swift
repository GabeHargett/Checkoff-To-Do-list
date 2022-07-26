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
    let quoteSignature = UILabel()

    private let imageView = UIImageView(image: UIImage(systemName: "list.bullet.rectangle"))
    private let goalImageView = UIImageView(image: UIImage(systemName: "list.bullet.rectangle"))
    private let hiarchyStack = UIStackView()
    private let currentWeekTaskLabel = UILabel()
    private let view = UIView()
    
    private let scrollStack = ScrollableStackView()
    private let weekStack = UIStackView()
    private let nextPreviousOtherGoalStack = HorizontalScrollableStackView()
    private let nextPreviousOtherStack = HorizontalScrollableStackView()
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
    
    private func setupStackView() {
        for view in [currentWeekStack, previousWeekLabel, nextWeekLabel, otherWeeksLabel, goalsStack2, previousWeekGoalLabel, nextWeekGoalLabel,
                     otherWeeksGoalLabel, quoteButton, pencilQuoteButton, imageAddButton, imageButton] {
            view.isUserInteractionEnabled = true
        }
                
        labelStack.axis = .vertical
        goalLabelStack.axis = .vertical

        
        scrollStack.stackView.spacing = 12
        scrollStack.stackView.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        scrollStack.stackView.isLayoutMarginsRelativeArrangement = true
        
        addAutoLayoutSubview(scrollStack)
        scrollStack.fillSuperview()
        
        weekStack.addBorders(color: .black, thickness: 1)
        weekStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        weekStack.axis = .vertical
        weekStack.spacing = 12
        weekStack.isLayoutMarginsRelativeArrangement = true
        weekStack.cornerRadius(radius: 8)

        
        currentWeekStack.axis = .horizontal
        currentWeekStack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        currentWeekStack.isLayoutMarginsRelativeArrangement = true
        currentWeekStack.alignment = .center
        currentWeekStack.spacing = 12
        currentWeekStack.cornerRadius(radius: 8)
        
//        testStack.axis = .vertical
//        testStack.spacing = 0
//        testStack.alignment = .center

        
        nextPreviousOtherStack.stackView.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 10, right: 12)
        nextPreviousOtherStack.stackView.isLayoutMarginsRelativeArrangement = true
        nextPreviousOtherStack.stackView.alignment = .center
        nextPreviousOtherStack.stackView.spacing = 12
        nextPreviousOtherStack.stackView.cornerRadius(radius: 8)

        nextPreviousOtherGoalStack.stackView.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 10, right: 12)
        nextPreviousOtherGoalStack.stackView.isLayoutMarginsRelativeArrangement = true
        nextPreviousOtherGoalStack.stackView.spacing = 12
        nextPreviousOtherGoalStack.stackView.alignment = .center
        nextPreviousOtherGoalStack.stackView.cornerRadius(radius: 8)

        
        imageView.height(constant: 55)
        imageView.width(constant: 55)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        
        goalImageView.height(constant: 55)
        goalImageView.width(constant: 55)
        goalImageView.contentMode = .scaleAspectFit
        goalImageView.tintColor = .black

        nextWeekLabel.text = " Next Week "
//        nextWeekLabel.addBorders(color: .black, thickness: 1)
        nextWeekLabel.height(constant: 40)
        nextWeekLabel.cornerRadius(radius: 8)
        

        previousWeekLabel.text = " Previous Week "
//        previousWeekLabel.addBorders(color: .black, thickness: 1)
        previousWeekLabel.height(constant: 40)
        previousWeekLabel.cornerRadius(radius: 8)

        
        otherWeeksLabel.text = " Other Weeks "
//        otherWeeksLabel.addBorders(color: .black, thickness: 1)
        otherWeeksLabel.height(constant: 40)
        otherWeeksLabel.cornerRadius(radius: 8)
        

        nextWeekGoalLabel.text = " Next Week "
//        nextWeekGoalLabel.addBorders(color: .black, thickness: 1)
        nextWeekGoalLabel.height(constant: 40)
        nextWeekGoalLabel.cornerRadius(radius: 8)



        previousWeekGoalLabel.text = " Previous Week "
//        previousWeekGoalLabel.addBorders(color: .black, thickness: 1)
        previousWeekGoalLabel.height(constant: 40)
        previousWeekGoalLabel.cornerRadius(radius: 8)
                
        otherWeeksGoalLabel.text = " Other Weeks "
//        otherWeeksGoalLabel.addBorders(color: .black, thickness: 1)
        otherWeeksGoalLabel.height(constant: 40)
        otherWeeksGoalLabel.cornerRadius(radius: 8)


        
        currentTaskLabel.text = "Current Week Tasks"
        currentTaskLabel.font = UIFont.systemFont(ofSize: 21)
                
        quoteStack.addBorders(color: .black, thickness: 1)
        quoteStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 16)
        quoteStack.axis = .vertical
        quoteStack.spacing = 12
        quoteStack.isLayoutMarginsRelativeArrangement = true
        quoteStack.cornerRadius(radius: 8)
        
        
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
        
        
        imageStack.addBorders(color: .black, thickness: 1)
        imageStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 16)
        imageStack.axis = .vertical
        imageStack.spacing = 12
        imageStack.isLayoutMarginsRelativeArrangement = true
        imageStack.cornerRadius(radius: 8)
        
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

        imageAddButton.setImage(image:UIImage(systemName: "photo"),color:.systemGray)
        imageAddButton.setTitle(title: "Tap Here To Insert Your Picture")
        imageAddButton.setImageWidth(size: 26)
        imageAddButton.setImageHeight(size: 26)
        imageAddButton.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

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
        goalsStack1.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        goalsStack1.axis = .vertical
        goalsStack1.spacing = 12
        goalsStack1.isLayoutMarginsRelativeArrangement = true
        goalsStack1.cornerRadius(radius: 8)

        goalsLabel.text = "Couple Goals of the Week"
        goalsLabel.textAlignment = .left
        goalsLabel.font = UIFont.systemFont(ofSize: 21)
        goalsLabel.numberOfLines = 0
                
        scrollStack.stackView.addArrangedSubviews([
            weekStack,
            imageStack,
            goalsStack1,
            quoteStack
        ])
        
        weekStack.addArrangedSubviews([
            currentWeekStack,
            nextPreviousOtherStack,
        ])
//        testStack.addArrangedSubviews([
//            nextPreviousOtherStack
//        ])
        currentWeekStack.addArrangedSubviews([
            imageView,
            labelStack
        ])
        
        nextPreviousOtherStack.stackView.addArrangedSubviews([
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
            imageLabel
        ])
        
        goalsStack1.addArrangedSubviews([
            goalsStack2,
            nextPreviousOtherGoalStack
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
        
        nextPreviousOtherGoalStack.stackView.addArrangedSubviews([
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
