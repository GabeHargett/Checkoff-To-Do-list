//
//  HomeViewController.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 3/30/22.
//
import Firebase
import UIKit

struct Quote {
    var text: String
    var author: String
}

class HomeViewController: UIViewController  {
    
    override func loadView() {
        view = baseView
    }
    
    let baseView = HomeView()
    public let date = Date()
    private var temporaryQuote: Quote?
    
    override func viewDidLoad(){
        super.viewDidLoad()
                
        title = "Home"
        navigationItem.hidesBackButton = true

        configureBackground()
        downloadImage()
        setUpDidTaps()
        getQuote()
        Practice.startPractice()
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
                    self.baseView.finishedTaskLabel.text = "\(completedTask) Finished Task"
                    self.baseView.openTaskLabel.text = "\(currentWeekTask.count - completedTask) Open Task"
                }
            }
        }
    }
    
    private func downloadImage() {
        if let data = UserDefaults.standard.data(forKey: "homeImage") {
            let image = UIImage.init(data: data)
            self.baseView.couplePhoto.image = image
            self.baseView.couplePhoto.isHidden = false
            self.baseView.imageAddButton.isHidden = true
        }
        FirebaseAPI.downloadImage() {
            image in self.baseView.couplePhoto.image = image
            if let data = image?.jpegData(compressionQuality: 0.7) {
                UserDefaults.standard.set(data, forKey: "homeImage")
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.baseView.couplePhoto.isHidden = false
                self.baseView.imageAddButton.isHidden = true
            })
        }
    }
    
    private func getQuote() {
        FirebaseAPI.getQuote() {result in
            DispatchQueue.main.async {
                if let quote = result {
                    self.updateQuoteButton(quote: quote)
                }
            }
        }
    }
    
    private func updateQuoteButton(quote: Quote) {
        self.baseView.quoteLabel.text =  "\"" + quote.text + "\""
        self.baseView.quoteButton.isHidden = true
        self.baseView.quoteSignature.text = "- " + quote.author
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
        let vc = SettingsVC()
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

    func setUpDidTaps() {
            
            let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(didTapCurrentWeek))
            baseView.currentWeekStack.addGestureRecognizer(tapGesture1)
            
            let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(didTapPreviousWeek))
            baseView.previousWeekLabel.addGestureRecognizer(tapGesture2)
            
            let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(didTapNextWeek))
            baseView.nextWeekLabel.addGestureRecognizer(tapGesture3)
                    
            let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(didTapOtherWeek))
            baseView.otherWeeksLabel.addGestureRecognizer(tapGesture4)
            
            let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(didTapGoalsStack))
            baseView.goalsStack2.addGestureRecognizer(tapGesture5)
            
            let tapGesture6 = UITapGestureRecognizer(target: self, action: #selector(didTapPreviousGoalWeek))
            baseView.previousWeekGoalLabel.addGestureRecognizer(tapGesture6)

            let tapGesture7 = UITapGestureRecognizer(target: self, action: #selector(didTapNextGoalWeek))
            baseView.nextWeekGoalLabel.addGestureRecognizer(tapGesture7)
                    
            let tapGesture8 = UITapGestureRecognizer(target: self, action: #selector(didTapOtherGoalWeek))
            baseView.otherWeeksGoalLabel.addGestureRecognizer(tapGesture8)

            let tapGesture9 = UITapGestureRecognizer(target: self, action: #selector(addQuote))
            baseView.quoteButton.addGestureRecognizer(tapGesture9)
            
            let tapGesture10 = UITapGestureRecognizer(target: self, action: #selector(addQuote))
            baseView.pencilQuoteButton.addGestureRecognizer(tapGesture10)
            
            let tapGesture11 = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
            baseView.imageAddButton.addGestureRecognizer(tapGesture11)
            
            let tapGesture12 = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
            baseView.imageButton.addGestureRecognizer(tapGesture12)

}
    
    @objc private func didTapCurrentWeek() {
        guard let weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()) else{
            return
        }
        let vc = WeeksVC(weekAndYear: weekAndYear)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapPreviousWeek() {
        guard var weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()) else{
            return
        }
        weekAndYear.week -= 1
        let vc = WeeksVC(weekAndYear: weekAndYear)
        navigationController?.pushViewController(vc, animated: true)        
    }

    @objc private func didTapNextWeek() {
        guard var weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()) else{
            return
        }
        weekAndYear.week += 1
        let vc = WeeksVC(weekAndYear: weekAndYear)
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
        let vc = GoalsVC(weekAndYear: weekAndYear)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapNextGoalWeek() {
        guard var weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()) else{
            return
        }
        weekAndYear.week += 1
        let vc = GoalsVC(weekAndYear: weekAndYear)
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
        let vc = GoalsVC(weekAndYear: weekAndYear)
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
        

        switch textType {
            
        case .quote:
            self.temporaryQuote = Quote(text: text, author: "")
            let vc = TextInputVC(textType: .author)
            vc.delegate = self
            vc.showModal(vc: self)
        case .goal:
            break
        case .task:
            break
        case .author:
            if var temporaryQuote = temporaryQuote {
                temporaryQuote.author = text
                updateQuoteButton(quote: temporaryQuote)
                FirebaseAPI.addQuote(quote: temporaryQuote)
            }
        }
    }
}


extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
    [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage" )]as? UIImage {
            baseView.couplePhoto.image = image
            FirebaseAPI.uploadImage(image: image) {
                print("image Uploaded")
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.baseView.couplePhoto.isHidden = false
                self.baseView.imageAddButton.isHidden = true
            })
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension HomeViewController: DatePickerVCDelegate {
    
    func didSubmitDate(date: Date?) {
        let dateStamp = date?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        guard let weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date.init(timeIntervalSince1970: dateStamp)) else {
            return
        }
        let vc = WeeksVC(weekAndYear: weekAndYear)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSubmitGoalDate(date: Date?) {
        let dateStamp = date?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        guard let weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date.init(timeIntervalSince1970: dateStamp)) else {
            return
        }
        let vc = GoalsVC(weekAndYear: weekAndYear)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
