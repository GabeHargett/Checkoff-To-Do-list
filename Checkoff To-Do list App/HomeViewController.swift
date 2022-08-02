//
//  HomeViewController.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 3/30/22.
//
import Firebase
import UIKit
import Photos

class GroupManager {
    static var shared = GroupManager()
    
    func getCurrentGroupID() -> String? {
        return UserDefaults.standard.string(forKey: "CurrentGroupID")
    }
    func setCurrentGroupID(groupID: String) {
        UserDefaults.standard.set(groupID, forKey: "CurrentGroupID")
    }
    
    func clearGroupID() {
        UserDefaults.standard.set(nil, forKey: "CurrentGroupID")
        UserDefaults.standard.set(nil, forKey: "homeImage")
        UserDefaults.standard.set(nil, forKey: "profileImage")

    }
}

enum PhotoType: Int {
    case group
    case profile
}

class HomeViewController: UIViewController, SettingsVCDelegate, ProfileViewDelegate  {
    
    
    
    override func loadView() {
        view = baseView
    }
    
    let baseView = HomeView()
    public let date = Date()
    private var temporaryQuote: Quote?
    private var user: User?
    private let groupID: String
    var photoType: PhotoType?
    
    init(groupID: String) {
        self.groupID = groupID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func viewDidLoad(){
        super.viewDidLoad()
                
        title = "Home"
        navigationItem.hidesBackButton = true
        
        self.hideKeyboardWhenTappedAround()
        configureBackground()
        downloadImage()
        downloadProfileImage()
        setUpDidTaps()
        getQuote()
        Practice.startPractice()
        addProfileViewsForUIDs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getTaskCount()
        getGoalCount()
    }

    
    private func getTaskCount() {
        FirebaseAPI.getTasks(groupID: groupID) {result in
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
                    self.baseView.finishedTaskLabel.text = "\(completedTask) Finished Tasks"
                    self.baseView.openTaskLabel.text = "\(currentWeekTask.count - completedTask) Open Tasks"
                }
            }
        }
    }
    
    private func addProfileViewsForUIDs() {
        FirebaseAPI.getUIDsForGroup(groupID: groupID) {result in
            if let uids = result {
                for uid in uids {
                    DispatchQueue.main.async {
                        let profileView = ProfileView(uid: uid)
                        self.baseView.profileViewStack.addArrangedSubview(profileView)
                    }
                }
            } else {
                print("No users fuck")
            }
        }
    }
    func updateProfile() {
        
        //profileView's delegate func
        //profileView.delegate = self "need to set delegete to self without creating a new instance."
        //add didTapImageAddButton logic in here with the UITapGestureRecognizer working right
    }
    
    func updateStatus() {
        //profileView's delegate func
        //profileView.delegate = self "need to set delegete to self without creating a new instance."
        //add textFieldtoEmoji logic in here but maybe create the textfield inside profileView?
    }
    
    private func textFieldToEmoji() {
        //I can't call this func when the app is ran, need to figure out how to run this func when the user selects the emoji in the textfield. may need to convert the emoji to string before I save it. 
        if let text = baseView.textfield.text {
            if text.count == baseView.textfield.maxLength {
                FirebaseAPI.addEmoji(groupID: groupID, emoji: text)
            }
        }
    }
    
    func updateColor() {
        baseView.setColors()
        configureBackground()
    }
    
    private func getGoalCount() {
        FirebaseAPI.getGoals(groupID: groupID) {result in
            if let allGoals = result {
                let currentWeekGoal = allGoals.filter({goal in
                    let goalDate = Date(timeIntervalSince1970: goal.dateStamp)
                    let goalWeekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: goalDate)
                    return DateAnalyzer.getWeekAndYearFromDate(date: Date()) == goalWeekAndYear
                })
                DispatchQueue.main.async {
                    var completedGoals = 0
                    for goal in currentWeekGoal {
                        if goal.isComplete {
                            completedGoals += 1
                        }
                    }
                    self.baseView.finishedGoalLabel.text = "\(completedGoals) Finished Goals"
                    self.baseView.openGoalLabel.text = "\(currentWeekGoal.count - completedGoals) Started Goals"
                }
            }
        }
    }
    
    private func downloadImage() {
        if let data = UserDefaults.standard.data(forKey: "homeImage") {
            let image = UIImage.init(data: data)
            self.baseView.couplePhoto.image = image
            self.baseView.couplePhoto.isHidden = false
        }
        FirebaseAPI.downloadImage(groupID: groupID) {
            image in
            if image == nil {
               return
            }
            self.baseView.couplePhoto.image = image
            if let data = image?.jpegData(compressionQuality: 0.7) {
                UserDefaults.standard.set(data, forKey: "homeImage")
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.baseView.couplePhoto.isHidden = false
            })
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
    
    private func getQuote() {
        FirebaseAPI.getQuote(groupID: groupID) {result in
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
        self.baseView.authorLabel.text = "- " + quote.author
    }
    
    private func configureBackground() {
        view.backgroundColor = .mainColor6
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        )
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.tintColor = .mainColor1
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.mainColor1]
}
    
    @objc private func didTapSettings() {
        let vc = SettingsVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
        
    @objc private func didTapImageAddButton(tapGesture: UITapGestureRecognizer) {
        guard let tag = tapGesture.view?.tag, let phototype = PhotoType.init(rawValue: tag)
        else{
            return
        }
        self.photoType = phototype
        PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
            switch status {
                
            case .notDetermined:
                break
            case .restricted:
                break
            case .denied:
                break
            case .authorized:
                DispatchQueue.main.async {
                
                let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
                vc.delegate = self
                vc.allowsEditing = true
                self.present(vc, animated: true)
                }
            case .limited:
                break
            @unknown default:
                break
            }
        })
        //make sure they have access
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
        baseView.addQuote.addGestureRecognizer(tapGesture9)
        
        let tapGesture10 = UITapGestureRecognizer(target: self, action: #selector(didTapImageAddButton))
        baseView.editPhotoButton.addGestureRecognizer(tapGesture10)
        baseView.editPhotoButton.tag = PhotoType.group.rawValue

        let tapGesture11 = UITapGestureRecognizer(target: self, action: #selector(didTapImageAddButton))
        baseView.profilePhoto.addGestureRecognizer(tapGesture11)
        baseView.profilePhoto.tag = PhotoType.profile.rawValue

        let tapGesture12 = UITapGestureRecognizer(target: self, action: #selector(didTapImageAddButton))
        baseView.profileViewStack.addGestureRecognizer(tapGesture12)
        baseView.profileViewStack.tag = PhotoType.profile.rawValue
        
//        let tapGesture14 = UITapGestureRecognizer(target: self, action: #selector(didTapImageAddButton))
//        baseView.editPhotoButton2.addGestureRecognizer(tapGesture14)
//        baseView.editPhotoButton2.tag = PhotoType.group.rawValue




    }
    
    @objc private func didTapCurrentWeek() {
        guard let weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()) else{
            return
        }
        let vc = WeeksVC(groupID: groupID, weekAndYear: weekAndYear)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapPreviousWeek() {
        guard var weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()) else{
            return
        }
        weekAndYear.week -= 1
        let vc = WeeksVC(groupID: groupID, weekAndYear: weekAndYear)
        navigationController?.pushViewController(vc, animated: true)        
    }

    @objc private func didTapNextWeek() {
        guard var weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()) else{
            return
        }
        weekAndYear.week += 1
        let vc = WeeksVC(groupID: groupID, weekAndYear: weekAndYear)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func didTapOtherWeek() {
        let vc = DatePickerVC(goalType: .task)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapPreviousGoalWeek() {
        guard var weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()), var monthAndYear = DateAnalyzer.getMonthAndYearFromDate(date: Date()) else{
            return
        }
        weekAndYear.week -= 1
        let vc = GoalsVC(groupID: groupID, weekAndYear: weekAndYear, monthAndYear: monthAndYear)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapNextGoalWeek() {
        guard var weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()), var monthAndYear = DateAnalyzer.getMonthAndYearFromDate(date: Date()) else{
            return
        }
        weekAndYear.week += 1
        let vc = GoalsVC(groupID: groupID, weekAndYear: weekAndYear, monthAndYear: monthAndYear)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func didTapOtherGoalWeek() {
        let vc = DatePickerVC(goalType: .goal)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapGoalsStack() {
        guard var weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()), var monthAndYear = DateAnalyzer.getMonthAndYearFromDate(date: Date()) else{
            return
        }
        
        let vc = GoalsVC(groupID: groupID, weekAndYear: weekAndYear, monthAndYear: monthAndYear)
        navigationController?.pushViewController(vc, animated: true)
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
    func didSubmitText(text: String, text2: String?, textType: TextInputVC.TextType, date: Date?) {
        

        switch textType {
            
        case .quote:
            self.temporaryQuote = Quote(text: text, author: "")
            if var temporaryQuote = temporaryQuote {
                if let text2 = text2 {
                    temporaryQuote.author = text2
                    updateQuoteButton(quote: temporaryQuote)
                    FirebaseAPI.addQuote(quote: temporaryQuote, groupID: groupID)
                }
            }
        case .goal:
            break
        case .task:
            break
            
        }
    }
}


extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
                               [UIImagePickerController.InfoKey : Any]) {
        switch photoType {
        case.group:
            if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage" )]as? UIImage {
                baseView.couplePhoto.image = image
                FirebaseAPI.uploadImage(groupID: groupID, image: image) {
                    print("image Uploaded")
                }
                UIView.animate(withDuration: 0.5, animations: {
                })
            }
        case.profile:
            if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage" )]as? UIImage {
//                baseView.profilePhoto.image = image
                if let uid = FirebaseAPI.currentUserUID() {
                    FirebaseAPI.uploadProfileImages(uid: uid, image: image) {
                        print("image Uploaded")
                    }
                }
                UIView.animate(withDuration: 0.5, animations: {
                    self.baseView.profilePhoto.isHidden = false
                    //                self.baseView.imageAddButton.isHidden = true
                })
            }
        default:
           break
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
        let vc = WeeksVC(groupID: groupID, weekAndYear: weekAndYear)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSubmitGoalDate(date: Date?) {
        let dateStamp = date?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        guard var weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()), var monthAndYear = DateAnalyzer.getMonthAndYearFromDate(date: Date()) else{
            return
        }
        
        let vc = GoalsVC(groupID: groupID, weekAndYear: weekAndYear, monthAndYear: monthAndYear)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
