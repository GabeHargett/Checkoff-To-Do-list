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
    
    private var goals = [Goal]()
    public let date = Date()
    
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
    var editedGoalIndex: Int?

    override func viewDidLoad(){
        super.viewDidLoad()
                
        title = "Home"

        setupStackView()
        configureBackground()
//        getTaskCount()
        downloadImage()
        getQuote()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getTaskCount()
    }
    
    private func getTaskCount() {
        FirebaseAPI.getTasks() {result in
            if let allTasks = result {
                let currentWeekTask = allTasks.filter({task in
                    let taskDate = Date(timeIntervalSince1970: task.dateStamp)
                    let taskWeekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: taskDate)
                    return DateAnalyzer.getWeekAndYearFromDate(date: Date()) == taskWeekAndYear
                                                                    
                })
                DispatchQueue.main.async {
                    var completedTask = 0
                    for task in currentWeekTask {
                        if task.isComplete {
                            completedTask += 1
                        }
                    }
                    self.finishedTaskLabel.text = "\(completedTask) Finished Task"
                    self.openTaskLabel.text = "\(currentWeekTask.count - completedTask) Open Task"
                }
            }
        }
    }
    
    private func downloadImage() {
        FirebaseAPI.downloadImage() {
            image in self.couplePhoto.image = image
            UIView.animate(withDuration: 0.5, animations: {
                self.couplePhoto.isHidden = false
                self.imageAddButton.isHidden = true
            })
        }
    }
    
    private func getQuote() {
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
    }
    
    private func getAuthor() {
        FirebaseAPI.getAuthor() {result in
            DispatchQueue.main.async {
                if let author =  result {
                    self.quoteSignature.text = "- " + author
                }
            }
        }
    }
    private func getGoals() {
        FirebaseAPI.getGoals() {result in
            if let goals = result {
                self.goals = goals
                DispatchQueue.main.async {
                }
            }
        }
    }

    private func configureBackground() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        )
        navigationController?.navigationBar.tintColor = .label
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
        
        let currecntWeekPreviousOtherStack = UIStackView()
        let currentWeekStack = UIStackView()
        let nextPreviousOtherGoalStack = UIStackView()
        let nextPreviousOtherStack = UIStackView()
        let currentTaskLabel = UnderlinedLabel()
        let labelStack = UIStackView()
        let quoteStack = UIStackView()
        let quoteOfTheWeek = UnderlinedLabel()
        let imageStack = UIStackView()
        let imageAddOnStack = UnderlinedLabel()
        let goalsStack1 = UIStackView()
        let goalsStack2 = UIStackView()
        let goalsLabel = UnderlinedLabel()
        let quoteStackWithPencil = UIStackView()
        let imageStackWithPencil = UIStackView ()
        
        labelStack.axis = .vertical
        
        scrollStack.stackView.spacing = 12
        scrollStack.stackView.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        scrollStack.stackView.isLayoutMarginsRelativeArrangement = true
        
        view.addAutoLayoutSubview(scrollStack)
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

        
//        goalsStack.addBorders(color: .black, thickness: 1)
//        goalsStack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
//        goalsStack.axis = .vertical
//        goalsStack.spacing = 12
//        goalsStack.isLayoutMarginsRelativeArrangement = true
//        goalsStack.cornerRadius(radius: 8)
        
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


                
        
//        collectionView.height(constant: 30)
        
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
            nextWeekLabel,
            previousWeekLabel,
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
            nextWeekGoalLabel,
            previousWeekGoalLabel,
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

        currentWeekStack.isUserInteractionEnabled = true
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(didTapCurrentWeek))
        currentWeekStack.addGestureRecognizer(tapGesture3)
        
        previousWeekLabel.isUserInteractionEnabled = true
        let tapGesture12 = UITapGestureRecognizer(target: self, action: #selector(didTapPreviousWeek))
        previousWeekLabel.addGestureRecognizer(tapGesture12)
        
        nextWeekLabel.isUserInteractionEnabled = true
        let tapGesture13 = UITapGestureRecognizer(target: self, action: #selector(didTapNextWeek))
        nextWeekLabel.addGestureRecognizer(tapGesture13)
                
        otherWeeksLabel.isUserInteractionEnabled = true
        let tapGesture10 = UITapGestureRecognizer(target: self, action: #selector(didTapOtherWeek))
        otherWeeksLabel.addGestureRecognizer(tapGesture10)
        
        goalsStack2.isUserInteractionEnabled = true
        let tapGesture14 = UITapGestureRecognizer(target: self, action: #selector(didTapGoalsStack))
        goalsStack2.addGestureRecognizer(tapGesture14)
        
        previousWeekGoalLabel.isUserInteractionEnabled = true
        let tapGesture22 = UITapGestureRecognizer(target: self, action: #selector(didTapPreviousGoalWeek))
        previousWeekGoalLabel.addGestureRecognizer(tapGesture22)

        nextWeekGoalLabel.isUserInteractionEnabled = true
        let tapGesture20 = UITapGestureRecognizer(target: self, action: #selector(didTapNextGoalWeek))
        nextWeekGoalLabel.addGestureRecognizer(tapGesture20)
                
        otherWeeksGoalLabel.isUserInteractionEnabled = true
        let tapGesture21 = UITapGestureRecognizer(target: self, action: #selector(didTapOtherGoalWeek))
        otherWeeksGoalLabel.addGestureRecognizer(tapGesture21)

        quoteButton.isUserInteractionEnabled = true
        let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(addQuote))
        quoteButton.addGestureRecognizer(tapGesture5)
        
        pencilQuoteButton.isUserInteractionEnabled = true
        let tapGesture8 = UITapGestureRecognizer(target: self, action: #selector(addQuote))
        pencilQuoteButton.addGestureRecognizer(tapGesture8)
        
        imageAddButton.isUserInteractionEnabled = true
        let tapGesture6 = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        imageAddButton.addGestureRecognizer(tapGesture6)
        
        imageButton.isUserInteractionEnabled = true
        let tapGesture7 = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        imageButton.addGestureRecognizer(tapGesture7)

        }
    
    @objc private func didTapCurrentWeek() {
        guard let weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()) else{
            return
        }
        let vc = FirstVC(weekAndYear: weekAndYear)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapPreviousWeek() {
        guard var weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()) else{
            return
        }
        weekAndYear.week -= 1
        let vc = FirstVC(weekAndYear: weekAndYear)
        navigationController?.pushViewController(vc, animated: true)        
    }

    @objc private func didTapNextWeek() {
        guard var weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()) else{
            return
        }
        weekAndYear.week += 1
        let vc = FirstVC(weekAndYear: weekAndYear)
        navigationController?.pushViewController(vc, animated: true)
    }


    @objc private func didTapOtherWeek() {
        let vc = DatePickerVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapPreviousGoalWeek() {
        guard var weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()) else{
            return
        }
        weekAndYear.week -= 1
        let vc = GoalVC(weekAndYear: weekAndYear)
        navigationController?.pushViewController(vc, animated: true)
    }

    
    @objc private func didTapNextGoalWeek() {
        guard var weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()) else{
            return
        }
        weekAndYear.week += 1
        let vc = GoalVC(weekAndYear: weekAndYear)
        navigationController?.pushViewController(vc, animated: true)
    }


    @objc private func didTapOtherGoalWeek() {
        let vc = DatePickerVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapGoalsStack() {
        guard let weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()) else{
            return
        }
        let vc = GoalVC(weekAndYear: weekAndYear)
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
    func didSubmitText(text: String, textType: TextInputVC.TextType, date: Date?) {
        
        if let editedGoalIndex = editedGoalIndex {
            goals[editedGoalIndex].goal = text
            FirebaseAPI.editGoal(goal: goals[editedGoalIndex])
            self.editedGoalIndex = nil

//            collectionView.reloadData()
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
//            FirebaseAPI.addGoal(goal: Goal(id: "", goal: text, dateStamp: Date().timeIntervalSince1970, author: "Gabe"))
       case .task:
            break
        case .author:
            quoteSignature.text = "- " + text
            FirebaseAPI.setAuthor(quote: text)
            
        }

//        collectionView.reloadData()
    }
}


extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
    [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage" )]as? UIImage {
            couplePhoto.image = image
            FirebaseAPI.uploadImage(image: image) {
                print("image Uploaded")
            }
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

//extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return goals.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier,
//                                                      for: indexPath) as! CustomCollectionViewCell
//        cell.cornerRadius(radius: 8)
//        cell.backgroundColor = .systemGray4
//        cell.goalIndex = indexPath.item
//        cell.configure(goal: goals[indexPath.item])
//        cell.delegate = self
//
//
////        cell.textLabel?.text = goals[indexPath.item].goal
//
//
//
//         return cell
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: 300, height: 30)
//    }
//
//}

//extension HomeViewController: CustomCollectionViewCellDelegate {
//
//    func didTapTrash(goalIndex: Int) {
//        FirebaseAPI.removeGoal(goal: goals[goalIndex])
//        self.goals.remove(at: goalIndex)
//        self.collectionView.deleteItems(at: [IndexPath(item: goalIndex, section: 0)])
//
//    }
//
//
//
//    func didTapCVPencil(goalIndex: Int) {
//        editedGoalIndex = goalIndex
//        let vc = TextInputVC(textType: .goal)
//        vc.delegate = self
//        vc.showModal(vc: self)
//
//
//    }
//}

extension HomeViewController: DatePickerVCDelegate {
    
func didSubmitDate(date: Date?) {
    let dateStamp = date?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
    guard let weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date.init(timeIntervalSince1970: dateStamp)) else {
      return
    }
    let vc = FirstVC(weekAndYear: weekAndYear)
    navigationController?.pushViewController(vc, animated: true)

    }
    func didSubmitGoalDate(date: Date?) {
        let dateStamp = date?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        guard let weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date.init(timeIntervalSince1970: dateStamp)) else {
          return
        }
        let vc = GoalVC(weekAndYear: weekAndYear)
        navigationController?.pushViewController(vc, animated: true)

        }
}

