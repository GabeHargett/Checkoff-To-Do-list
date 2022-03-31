//
//  HomeViewController.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 3/30/22.
//

import UIKit

class HomeViewController: UIViewController  {


    let date = Date()
    private let stackView = UIStackView()
    private let label1 = UILabel()
    private let label2 = UILabel()
    private let imageView = UIImageView(image: UIImage(systemName: "list.bullet.rectangle"))
    private let hiarchyStack = UIStackView()
    private let currentWeekTaskLabel = UILabel()
    
    private let goalsAddButton = CustomButton(type: .imageAndLabel)
    private let pencilGoalsIV = UIImageView(image: UIImage(systemName: "pencil"))

    private let imageAddButton = CustomButton(type: .imageAndLabel)
    private let pencilImageIV = UIImageView(image: UIImage(systemName: "pencil"))

    private let quoteButton = CustomButton(type: .imageAndLabel)
    private let pencilQuoteIV = UIImageView(image: UIImage(systemName: "pencil"))
    




    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        
        setupStackView()
        configureBackground()
        setUpMultipleStacks()

    }
    func configureBackground() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: nil
        )
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Times New Roman Bold", size: 27)!]
        

    
    }
    
    
    
    func getComponetsOfDates() {
    
    let components = date.get(.day, .month, .year)
    if let day = components.day, let month = components.month, let year = components.year {
        print("day: \(day), month: \(month), year: \(year)")
        
        }
    }
    
    
    
    private func setupStackView() {
        
        
        let stackView1 = UIStackView()
        let label3 = UILabel()
        let label4 = UILabel()
        let label5 = UILabel()
        let labelStack = UIStackView()
        
        labelStack.axis = .vertical


        view.addAutoLayoutSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView1.axis = .horizontal
        stackView1.addBorders(color: .black, thickness: 1)
        stackView1.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        stackView1.isLayoutMarginsRelativeArrangement = true
        stackView1.alignment = .center
        stackView1.spacing = 12
        stackView1.cornerRadius(radius: 8)
        
        imageView.height(constant: 64)
        imageView.width(constant: 64)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        
        
        label1.text = "  Future Weeks"
        label1.addBorders(color: .black, thickness: 1)
        label1.height(constant: 40)
        label1.layer.cornerRadius = 8


        
        label2.text = "  Past Weeks"
        label2.addBorders(color: .black, thickness: 1)
        label2.height(constant: 40)
        label2.cornerRadius(radius: 8)
        

        label3.text = "Current week task"
        label3.font = UIFont.systemFont(ofSize: 21)
        
        label4.text = "3 open task"
        
        label5.text = "4 finished task"


        
        stackView.addArrangedSubviews([
            stackView1,
            label1,
            label2,

        ])
        
        stackView1.addArrangedSubviews([
            imageView,
            labelStack
        
            ])
        labelStack.addArrangedSubviews([
            label3,
            label4,
            label5
            ])
        
    }
    
    private func setUpMultipleStacks() {
        
        let quoteStack = UIStackView()
        let quoteOfTheWeek = UILabel()
        let quoteSignature = UILabel()
        let imageStack = UIStackView()
        let imageAddOnStack = UILabel()
        let goalsStack = UIStackView()
        let goalsLabel = UILabel()
        let pencilQuote = UIStackView()
        let pencilImage = UIStackView ()
        let pencilGoals = UIStackView ()

        
        
        hiarchyStack.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        hiarchyStack.axis = .vertical
        hiarchyStack.spacing = 12
        hiarchyStack.isLayoutMarginsRelativeArrangement = true
        
        view.addAutoLayoutSubview(hiarchyStack)
        
        NSLayoutConstraint.activate([
            hiarchyStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hiarchyStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            hiarchyStack.widthAnchor.constraint(equalTo: view.widthAnchor),
            ])

        
        quoteStack.addBorders(color: .black, thickness: 1)
        quoteStack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        quoteStack.axis = .vertical
        quoteStack.spacing = 12
        quoteStack.isLayoutMarginsRelativeArrangement = true
        quoteStack.cornerRadius(radius: 8)
        
        pencilQuote.layoutMargins = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 16)
        pencilQuote.axis = .horizontal
        pencilQuote.spacing = 0
        pencilQuote.isLayoutMarginsRelativeArrangement = true
        
        pencilQuoteIV.height(constant: 28)
        pencilQuoteIV.width(constant: 28)
        pencilQuoteIV.contentMode = .scaleAspectFit
        pencilQuoteIV.tintColor = .black

        
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
        
        quoteSignature.text = "\"(Author) - Autofill \""
        quoteSignature.textAlignment = .right
        quoteSignature.font = UIFont.systemFont(ofSize: 12)
        
        
        imageStack.addBorders(color: .black, thickness: 1)
        imageStack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        imageStack.axis = .vertical
        imageStack.spacing = 12
        imageStack.isLayoutMarginsRelativeArrangement = true
        imageStack.cornerRadius(radius: 8)
        
        pencilImage.layoutMargins = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 16)
        pencilImage.axis = .horizontal
        pencilImage.isLayoutMarginsRelativeArrangement = true
        
        pencilImageIV.height(constant: 28)
        pencilImageIV.width(constant: 28)
        pencilImageIV.contentMode = .scaleAspectFit
        pencilImageIV.tintColor = .black

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

        
        goalsStack.addBorders(color: .black, thickness: 1)
        goalsStack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        goalsStack.axis = .vertical
        goalsStack.spacing = 12
        goalsStack.isLayoutMarginsRelativeArrangement = true
        goalsStack.cornerRadius(radius: 8)
        
        pencilGoals.layoutMargins = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 16)
        pencilGoals.axis = .horizontal
        pencilGoals.isLayoutMarginsRelativeArrangement = true
        
        pencilGoalsIV.height(constant: 28)
        pencilGoalsIV.width(constant: 28)
        pencilGoalsIV.contentMode = .scaleAspectFit
        pencilGoalsIV.tintColor = .black

        goalsLabel.text = "Couple Goals of the Week"
        goalsLabel.textAlignment = .center
        goalsLabel.font = UIFont.systemFont(ofSize: 21)


        goalsAddButton.setImage(image:UIImage(systemName: "link.badge.plus"),color:.systemGray)
        goalsAddButton.setTitle(title: "Tap Here To Set Couple Goals")
        goalsAddButton.setImageWidth(size: 26)
        goalsAddButton.setImageHeight(size: 26)
        goalsAddButton.quickConfigure(
                    font: .systemFont(ofSize: 15), titleColor: .black, backgroundColor: .systemGray4, cornerRadius: 8)
        goalsAddButton.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        goalsAddButton.isUserInteractionEnabled = true
        
        hiarchyStack.addArrangedSubviews([
            imageStack,
            goalsStack,
            quoteStack
        ])
        
        imageStack.addArrangedSubviews([
            pencilImage,
            imageAddButton
        ])
        
        pencilImage.addArrangedSubviews([
            pencilImageIV,
            imageAddOnStack
        ])
        
        goalsStack.addArrangedSubviews([
            pencilGoals,
            goalsAddButton
        ])
        
        pencilGoals.addArrangedSubviews([
            pencilGoalsIV,
            goalsLabel
        ])

        quoteStack.addArrangedSubviews([
            pencilQuote,
            quoteButton,
            quoteSignature
        ])
        
        pencilQuote.addArrangedSubviews([
            pencilQuoteIV,
            quoteOfTheWeek
        ])

        
        goalsAddButton.isUserInteractionEnabled = true
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(addGoals))
        goalsAddButton.addGestureRecognizer(tapGesture4)
            
        quoteButton.isUserInteractionEnabled = true
        let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(addQuote))
        quoteButton.addGestureRecognizer(tapGesture5)

            
        

        }
    

    @objc private func didTapGoalsButton() {
        let vc = TextInputVC(textType: 0)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc private func addGoals() {
        let vc = TextInputVC(textType: 0)
        vc.delegate = self
        vc.showModal(vc: self)
    }
    @objc private func addQuote() {
        let vc = TextInputVC(textType: 1)
        vc.delegate = self
        vc.showModal(vc: self)
    }
}

extension HomeViewController: TextInputVCDelegate {
    func didSubmitText(text: String) {
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

extension UIView {
    
    func addShadow(shadowColor: UIColor, shadowOpacity: Float, shadowRadius: CGFloat, shadowOffset: CGSize) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
    }
    
    func addBorders(color: UIColor, thickness: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = thickness
    }
    
    func cornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func centerInSuperview() {
        guard let superview = self.superview else { return }
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
            ])
    }
    
    func height(constant: CGFloat) {
        setConstraint(value: constant, attribute: .height)
    }
    
    func width(constant: CGFloat) {
        setConstraint(value: constant, attribute: .width)
    }
    
    private func removeConstraint(attribute: NSLayoutConstraint.Attribute) {
        constraints.forEach {
            if $0.firstAttribute == attribute {
                removeConstraint($0)
            }
        }
    }
    
    private func setConstraint(value: CGFloat, attribute: NSLayoutConstraint.Attribute) {
        removeConstraint(attribute: attribute)
        let constraint =
            NSLayoutConstraint(item: self,
                               attribute: attribute,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1,
                               constant: value)
        self.addConstraint(constraint)
    }
    
    public func fillSuperview() {
        guard let superview = self.superview else { return }
        activate(
            leftAnchor.constraint(equalTo: superview.leftAnchor),
            rightAnchor.constraint(equalTo: superview.rightAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        )
    }
    
    @discardableResult
    public func fillSuperviewLayoutMargins() -> (left: NSLayoutConstraint, right: NSLayoutConstraint, top: NSLayoutConstraint, bottom: NSLayoutConstraint) {
        guard let superview = self.superview else {
            fatalError("\(self) has not been added as a subview")
        }
        let left = leftAnchor.constraint(equalTo: superview.leftMargin)
        let right = rightAnchor.constraint(equalTo: superview.rightMargin)
        let top = topAnchor.constraint(equalTo: superview.topMargin)
        let bottom = bottomAnchor.constraint(equalTo: superview.bottomMargin)
        activate(left, right, top, bottom)
        return (left, right, top, bottom)
    }
    
    @discardableResult
    public func fillSuperviewMargins() -> (left: NSLayoutConstraint, right: NSLayoutConstraint, top: NSLayoutConstraint, bottom: NSLayoutConstraint) {
        guard let superview = self.superview else {
            fatalError("\(self) has not been added as a subview")
        }
        let left = leftAnchor.constraint(equalTo: superview.leftAnchor, constant: superview.layoutMargins.left)
        let right = rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -superview.layoutMargins.right)
        let top = topAnchor.constraint(equalTo: superview.topAnchor, constant: superview.layoutMargins.top)
        let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -superview.layoutMargins.bottom)
        activate(left, right, top, bottom)
        return (left, right, top, bottom)
    }
    
    public func activate(_ constraints: NSLayoutConstraint...) {
        NSLayoutConstraint.activate(constraints)
    }
    
    func addAutoLayoutSubview(_ subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var leftMargin: NSLayoutXAxisAnchor {
        return layoutMarginsGuide.leftAnchor
    }
    
    private var leadingMargin: NSLayoutXAxisAnchor {
        return layoutMarginsGuide.leadingAnchor
    }
    
    private var rightMargin: NSLayoutXAxisAnchor {
        return layoutMarginsGuide.rightAnchor
    }
    
    private var trailingMargin: NSLayoutXAxisAnchor {
        return layoutMarginsGuide.trailingAnchor
    }
    
    private var centerXMargin: NSLayoutXAxisAnchor {
        return layoutMarginsGuide.centerXAnchor
    }
    
    private var widthMargin: NSLayoutDimension {
        return layoutMarginsGuide.widthAnchor
    }
    
    private var topMargin: NSLayoutYAxisAnchor {
        return layoutMarginsGuide.topAnchor
    }
    
    private var bottomMargin: NSLayoutYAxisAnchor {
        return layoutMarginsGuide.bottomAnchor
    }
    
    private var centerYMargin: NSLayoutYAxisAnchor {
        return layoutMarginsGuide.centerYAnchor
    }
    
    private var heightMargin: NSLayoutDimension {
        return layoutMarginsGuide.heightAnchor
    }
    
    func makeToast(view: UIView, duration: Double) {
        self.addSubview(view)
        UIView.animate(withDuration: 0.6, delay: duration, options: .curveEaseOut, animations: {
             view.alpha = 0.0
        }, completion: {(isCompleted) in
            view.removeFromSuperview()
        })
    }
}

extension UIStackView {
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach(addArrangedSubview)
    }
}

extension UILabel {
    func quickConfigure(textAlignment: NSTextAlignment, font: UIFont, textColor: UIColor, numberOfLines: Int = 1) {
        self.textAlignment = textAlignment
        self.font = font
        self.textColor = textColor
        self.numberOfLines = numberOfLines
    }
}
