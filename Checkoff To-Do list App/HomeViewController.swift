//
//  HomeViewController.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 3/30/22.
//
import Firebase
import UIKit
import SwiftUI



class HomeViewController: UIViewController  {
    
    
    
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CustomCollectionViewCell.self,
                                forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)

        return collectionView
    }()
    

    private var goals = [Goal]()
    private var goal: Goal?


    public let date = Date()
    private let label1 = UILabel()
    private let label2 = UILabel()
    private let label6 = UILabel()
    private let imageView = UIImageView(image: UIImage(systemName: "list.bullet.rectangle"))
    private let hiarchyStack = UIStackView()
    private let currentWeekTaskLabel = UILabel()
    
    private let goalsAddButton = CustomButton(type: .imageAndLabel)
    private let plusButton = CustomButton(type: .image)
    private let pencilImageButton = CustomButton(type: .image)
    private let pencilQuoteButton = CustomButton(type: .image)
    private let imageAddButton = CustomButton(type: .imageAndLabel)
    public let quoteButton = CustomButton(type: .imageAndLabel)

    private let quoteLabel = UILabel()
    private let quoteSignature = UILabel()

    private let couplePhoto = UIImageView()
    private let scrollStack = ScrollableStackView()
    var editedGoalIndex: Int?

    

    
//    public let textInputVC = TextInputVC(textType: 0)
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        
        setupStackView()
        configureBackground()
        configureCollectionView()
//        view.addAutoLayoutSubview(spinner)
        
        //let quoteLabelSave = UserDefaults.standard.string(forKey: "quote")
        FirebaseAPI.getQuote() {result in
            DispatchQueue.main.async {
                if let quote =  result {
                    self.quoteLabel.text =  "\"" + quote + "\""
                    self.quoteButton.isHidden = true
                } else {
                    self.quoteButton.isHidden = false
                }
            }
        }
        FirebaseAPI.getAuthor() {result in
            DispatchQueue.main.async {
                if let author =  result {
                    self.quoteSignature.text = "- " + author
                }
            }
        }
        
        FirebaseAPI.getGoals() {result in
            if let goals = result {
                self.goals = goals
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        
        
//        let quoteButtonSave = UserDefaults.standard.bool(forKey: "hidingButton")
//        quoteButton.isHidden = quoteButtonSave
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    private func configureCollectionView() {
        collectionView.register(UICollectionViewCell.self,
        forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground

    }
    

    
    func configureBackground() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        )
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Times New Roman Bold", size: 27)!]
    }
    
    @objc private func didTapSettings() {
        let vc = PracticeVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func didTapImageAddButton(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
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
        let quoteStack = UIStackView()
        let quoteOfTheWeek = UnderlinedLabel()
        let imageStack = UIStackView()
        let imageAddOnStack = UnderlinedLabel()
        let goalsStack = UIStackView()
        let goalsLabel = UnderlinedLabel()
        let quoteStackWithPencil = UIStackView()
        let imageStackWithPencil = UIStackView ()
        let goalsStackWithPencil = UIStackView ()
        
        labelStack.axis = .vertical
        
        scrollStack.stackView.spacing = 12
        scrollStack.stackView.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        scrollStack.stackView.isLayoutMarginsRelativeArrangement = true
        
        view.addAutoLayoutSubview(scrollStack)
        scrollStack.fillSuperview()
        
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
        
        label6.text = "  Other Weeks"
        label6.addBorders(color: .black, thickness: 1)
        label6.height(constant: 40)
        label6.cornerRadius(radius: 8)

        
        label3.text = "Current week task"
        label3.font = UIFont.systemFont(ofSize: 21)
        
        label4.text = "3 open task"
        
        label5.text = "4 finished task"
        
        quoteStack.addBorders(color: .black, thickness: 1)
        quoteStack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        quoteStack.axis = .vertical
        quoteStack.spacing = 12
        quoteStack.isLayoutMarginsRelativeArrangement = true
        quoteStack.cornerRadius(radius: 8)
        
        quoteStackWithPencil.layoutMargins = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 16)
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

        quoteLabel.textAlignment = .center
        quoteLabel.font = UIFont.systemFont(ofSize: 20)

        quoteSignature.textAlignment = .right
        quoteSignature.font = UIFont.systemFont(ofSize: 15)
        
        
        imageStack.addBorders(color: .black, thickness: 1)
        imageStack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        imageStack.axis = .vertical
        imageStack.spacing = 12
        imageStack.isLayoutMarginsRelativeArrangement = true
        imageStack.cornerRadius(radius: 8)
        
        imageStackWithPencil.layoutMargins = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 16)
        imageStackWithPencil.axis = .horizontal
        imageStackWithPencil.isLayoutMarginsRelativeArrangement = true
                
        plusButton.setImage(image:UIImage(systemName: "plus"),color:.systemGray)
        plusButton.setImageWidth(size: 22)
        plusButton.setImageHeight(size: 22)
        plusButton.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        plusButton.quickConfigure(font: .systemFont(ofSize: 15), titleColor: .black, backgroundColor: .systemGray4, cornerRadius: 8)
        plusButton.isUserInteractionEnabled = true

        pencilImageButton.setImage(image:UIImage(systemName: "photo"),color:.systemGray)
        pencilImageButton.setImageWidth(size: 25)
        pencilImageButton.setImageHeight(size: 25)
        pencilImageButton.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        pencilImageButton.quickConfigure(font: .systemFont(ofSize: 15), titleColor: .black, backgroundColor: .systemGray4, cornerRadius: 8)
        pencilImageButton.isUserInteractionEnabled = true

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

        
        goalsStack.addBorders(color: .black, thickness: 1)
        goalsStack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        goalsStack.axis = .vertical
        goalsStack.spacing = 12
        goalsStack.isLayoutMarginsRelativeArrangement = true
        goalsStack.cornerRadius(radius: 8)
                
        goalsStackWithPencil.layoutMargins = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 16)
        goalsStackWithPencil.axis = .horizontal
        goalsStackWithPencil.isLayoutMarginsRelativeArrangement = true
        
        collectionView.height(constant: 30)
        
        goalsLabel.text = "Couple Goals of the Week"
        goalsLabel.textAlignment = .center
        goalsLabel.font = UIFont.systemFont(ofSize: 21)
        
        
        scrollStack.stackView.addArrangedSubviews([
            stackView1,
            label6,
            imageStack,
            goalsStack,
            quoteStack
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
                
        imageStack.addArrangedSubviews([
            imageStackWithPencil,
            imageAddButton,
            couplePhoto
        ])
        
        imageStackWithPencil.addArrangedSubviews([
            pencilImageButton,
            imageAddOnStack
        ])
        
        goalsStack.addArrangedSubviews([
            goalsStackWithPencil,
            collectionView
        ])
        
        goalsStackWithPencil.addArrangedSubviews([
            plusButton,
            goalsLabel
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

        stackView1.isUserInteractionEnabled = true
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(didTapCurrentWeek))
        stackView1.addGestureRecognizer(tapGesture3)
        
        label6.isUserInteractionEnabled = true
        let tapGesture10 = UITapGestureRecognizer(target: self, action: #selector(didTapOtherWeek))
        label6.addGestureRecognizer(tapGesture10)

                
        plusButton.isUserInteractionEnabled = true
        let tapGesture9 = UITapGestureRecognizer(target: self, action: #selector(addGoals))
        plusButton.addGestureRecognizer(tapGesture9)
            
        quoteButton.isUserInteractionEnabled = true
        let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(addQuote))
        quoteButton.addGestureRecognizer(tapGesture5)
        
        pencilQuoteButton.isUserInteractionEnabled = true
        let tapGesture8 = UITapGestureRecognizer(target: self, action: #selector(addQuote))
        pencilQuoteButton.addGestureRecognizer(tapGesture8)
        
        imageAddButton.isUserInteractionEnabled = true
        let tapGesture6 = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        imageAddButton.addGestureRecognizer(tapGesture6)
        
        pencilImageButton.isUserInteractionEnabled = true
        let tapGesture7 = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        pencilImageButton.addGestureRecognizer(tapGesture7)

        }
    
    @objc private func didTapCurrentWeek() {
        guard let weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()) else{
            return
        }
//        weekAndYear.week -= 1
        let vc = FirstVC(weekAndYear: weekAndYear)
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func didTapOtherWeek() {
        let vc = DatePickerVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func addPhoto() {
        let vc = UIImagePickerController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
        
    @objc private func addGoals() {
        let vc = TextInputVC(textType: .goal)
        vc.delegate = self
        vc.showModal(vc: self)
    }
    
    @objc private func addQuote() {
        let vc = TextInputVC(textType: .quote)
        vc.delegate = self
        vc.showModal(vc: self)
    }

}

extension HomeViewController: TextInputVCDelegate {
    func didSubmitText(text: String, textType: TextInputVC.TextType) {
        
        if let editedGoalIndex = editedGoalIndex {
            goals[editedGoalIndex].goal = text
            FirebaseAPI.editGoal(goal: goals[editedGoalIndex])
            self.editedGoalIndex = nil
            
            collectionView.reloadData()
            return
        }

        switch textType {
            
        case .quote:
            quoteLabel.text =  "\"" + text + "\""
            quoteButton.isHidden = true
            let vc = TextInputVC(textType: .author)
            vc.delegate = self
            vc.showModal(vc: self)
            FirebaseAPI.setQuote(quote: text)
        case .goal:
            goals.append(Goal(id: "", goal: text, dateStamp: Date().timeIntervalSince1970, author: "Gabe"))
            FirebaseAPI.addGoal(goal: Goal(id: "", goal: text, dateStamp: Date().timeIntervalSince1970, author: "Gabe"))
            collectionView.reloadData()
        case .task:
            break
        case .author:
            quoteSignature.text = "- " + text
            FirebaseAPI.setAuthor(quote: text)
            
        }

        collectionView.reloadData()
    }
}


extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
    [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage" )]as? UIImage {
            couplePhoto.image = image
            UIView.animate(withDuration: 0.5, animations: {
                self.couplePhoto.isHidden = false
                self.imageAddButton.isHidden = true
            })
        }
        picker.dismiss(animated: true, completion: nil)

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier,
                                                      for: indexPath) as! CustomCollectionViewCell
        cell.cornerRadius(radius: 8)
        cell.backgroundColor = .systemGray4
        cell.goalIndex = indexPath.item
        cell.configure(goal: goals[indexPath.item])
        cell.delegate = self


//        cell.textLabel?.text = goals[indexPath.item].goal



         return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 300, height: 30)
    }
    
}

extension HomeViewController: CustomCollectionViewCellDelegate {
    
    func didTapTrash(goalIndex: Int) {
        FirebaseAPI.removeGoal(goal: goals[goalIndex])
        self.goals.remove(at: goalIndex)
        self.collectionView.deleteItems(at: [IndexPath(item: goalIndex, section: 0)])

    }
    

    
    func didTapCVPencil(goalIndex: Int) {
        editedGoalIndex = goalIndex
        let vc = TextInputVC(textType: .goal)
        vc.delegate = self
        vc.showModal(vc: self)
        

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
