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
    }
}

enum PhotoType: Int {
    case group
    case profile
}

class HomeViewController: UIViewController, SettingsVCDelegate, ProfileViewDelegate, EditProfileViewVCDelegate  {

    override func loadView() {
        view = baseView
    }
    
    let baseView = HomeView()
    public let date = Date()
    private var currentQuote: Quote?
    private var allGoals: Goal?
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
                
        configureTitle()
        navigationItem.hidesBackButton = true
        
        configureBackground()
        downloadImage()
        setUpDidTaps()
        getQuote()
//        Practice.startPractice()
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
    
    private func getGoalCount() {
        FirebaseAPI.getGoals(groupID: groupID) {result in
            if let allGoals = result {
//                let currentWeekGoal = allGoals.filter({goal in
//                    let goalDate = Date(timeIntervalSince1970: goal.dateStamp)
//                    let goalWeekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: goalDate)
//                    return DateAnalyzer.getWeekAndYearFromDate(date: Date()) == goalWeekAndYear
//                })
                DispatchQueue.main.async {
                    var completedGoals = 0
                    for goal in allGoals {
                        if goal.isComplete {
                            completedGoals += 1
                        }
                    }
                    self.baseView.finishedGoalLabel.text = "\(completedGoals) Finished Goals"
                    self.baseView.openGoalLabel.text = "\(allGoals.count - completedGoals) Started Goals"
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
                        profileView.delegate = self
                        self.baseView.profileViewStack.addArrangedSubview(profileView)
                    }
                }
            } else {
                print("No users fuck")
            }
        }
    }
    private func profileViewFor(uid: String) -> ProfileView? {
        for view in baseView.profileViewStack.arrangedSubviews {
            if let profileView = view as? ProfileView {
                if profileView.uid == uid {
                    return profileView
                }
            }
        }
        return nil
    }
    
    func didUpdateImage(profileImage: UIImage) {
        guard let uid = FirebaseAPI.currentUserUID(), let profileView = profileViewFor(uid: uid) else {
            return
        }
        profileView.updateImage(profileImage: profileImage)
    }
    
    func didUpdateEmoji(emojiString: String) {
        guard let uid = FirebaseAPI.currentUserUID(), let profileView = profileViewFor(uid: uid) else {
            return
        }
        profileView.updateEmoji(emojiString: emojiString)
    }
    
    func updateProfileView(image: UIImage?, emoji: String?, uid: String) {
        let vc = EditProfileViewVC(initialProfileImage: image, initialEmoji: emoji, uid: uid)
            vc.delegate = self
            vc.showModal(vc: self)
    }
    
    func updateColor() {
        guard let uid = FirebaseAPI.currentUserUID(), let profileView = profileViewFor(uid: uid) else {
            return
        }
        baseView.setColors()
        configureBackground()
        profileView.profileImage.tintColor = .mainColor1
        
    }
    
    func updateGroupName() {
        configureTitle()
    }
    
    func configureTitle() {
        FirebaseAPI.getGroupTitle(groupID: groupID) {title in
            self.title = title
        }
    }
    
    private func downloadImage() {
        FirebaseAPI.downloadImage(groupID: groupID) {
            image in
            if image == nil {
               return
            }
            self.baseView.couplePhoto.image = image
            UIView.animate(withDuration: 0.5, animations: {
            })
        }
    }
    
    private func getQuote() {
        FirebaseAPI.getQuote(groupID: groupID) {result in
            self.currentQuote = result
            DispatchQueue.main.async {
                if let quote = result {
                    self.updateQuoteButton(quote: quote)
                }
                self.updateQuoteUI()
            }
        }
    }
    
    private func updateQuoteUI() {
        if self.currentQuote != nil {
            self.baseView.quoteGradient.isHidden = false
            self.baseView.quoteStack.isHidden = false
            self.baseView.addQuote.isHidden = true
        } else {
            self.baseView.quoteGradient.isHidden = true
            self.baseView.quoteStack.isHidden = true
            self.baseView.addQuote.isHidden = false
        }
    }
    
    private func updateQuoteButton(quote: Quote) {
        self.baseView.quoteLabel.text =  "\"" + quote.text + "\""
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
    
    private func restrictedUI() {
        let customAlert = ModalJesus(title: "Status: Restricted", description: "Your status is restricted by means this app cannot change.")
        customAlert.addAction(ModalJesusAction(title: "Cancel", style: false))
        customAlert.showModal(vc: self)
    }
    
    private func deniedUI() {
        let customAlert = ModalJesus(title: "Status: Denied", description: "Allow access to your photos to continue")
        customAlert.addAction(ModalJesusAction(title: "Open Settings", style: true, action: {self.goToPrivacySettings()}))
        customAlert.addAction(ModalJesusAction(title: "Cancel", style: false))
        customAlert.showModal(vc: self)
    }
    
    private func goToPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url) else {
                assertionFailure("Not able to open App privacy settings")
                return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func selectPhotos() {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }

        
    @objc private func didTapImageAddButton(tapGesture: UITapGestureRecognizer) {
        guard let tag = tapGesture.view?.tag, let phototype = PhotoType.init(rawValue: tag)
        else{
            return
        }
        self.photoType = phototype
        showImagePicker()
    }
    private func showImagePicker() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
            switch status {
                
            case .notDetermined:
                break
            case .restricted:
                DispatchQueue.main.async {
                    self.restrictedUI()
                }
            case .denied:
                DispatchQueue.main.async {
                    self.deniedUI()
                }
            case .authorized:
                DispatchQueue.main.async {
                
                let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
                vc.delegate = self
                vc.allowsEditing = true
                self.present(vc, animated: true)
                }
            case .limited:
                DispatchQueue.main.async {
                    let vc = UIImagePickerController()
                    vc.sourceType = .photoLibrary
                    vc.delegate = self
                    vc.allowsEditing = true
                    self.present(vc, animated: true)
                }
            @unknown default:
                break
            }
        })
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
        
        let tapGesture95 = UITapGestureRecognizer(target: self, action: #selector(addQuote))
        baseView.quoteStack.addGestureRecognizer(tapGesture95)
        let tapGesture9 = UITapGestureRecognizer(target: self, action: #selector(addQuote))
        baseView.addQuote.addGestureRecognizer(tapGesture9)
        
        let tapGesture10 = UITapGestureRecognizer(target: self, action: #selector(didTapImageAddButton))
        baseView.editPhotoButton.addGestureRecognizer(tapGesture10)
        baseView.editPhotoButton.tag = PhotoType.group.rawValue

//        let tapGesture12 = UITapGestureRecognizer(target: self, action: #selector(didTapImageAddButton))
//        baseView.profileViewStack.addGestureRecognizer(tapGesture12)
//        baseView.profileViewStack.tag = PhotoType.profile.rawValue




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
    
    @objc private func didTapGoalsStack() {
        let vc = GoalsVC(groupID: groupID)
        navigationController?.pushViewController(vc, animated: true)
    }
        
    @objc private func addGoals() {
            let vc = TextInputVC(textType: .goal)
            vc.delegate = self
            vc.showModal(vc: self)
        }
    
    @objc private func addQuote() {
            let vc = TextInputVC(textType: .quote)
        if let currentQuote = currentQuote {
            vc.textField.text = currentQuote.text
            vc.textField2.text = currentQuote.author
        }
        vc.delegate = self
        vc.showModal(vc: self)
    }
}

extension HomeViewController: TextInputVCDelegate {
    func didSubmitText(text: String, text2: String?, textType: TextInputVC.TextType, date: Date?) {
        
        switch textType {
        case .quote:
            if text != "", let authorText = text2 {
                let newQuote = Quote(text: text, author: authorText)
                self.currentQuote = newQuote
                updateQuoteUI()
                updateQuoteButton(quote: newQuote)
                FirebaseAPI.addQuote(quote: newQuote, groupID: groupID)
            }
        case .goal:
            break
        case .task:
            break
        case .groupName:
            break
        case .editTitle:
            break
        }
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
                               [UIImagePickerController.InfoKey : Any]) {
        
        switch photoType {
        case.group:

            if let image = info[.editedImage]as? UIImage {
                baseView.couplePhoto.image = image
                FirebaseAPI.uploadImage(groupID: groupID, image: image) {
                    ImageAssetHelper.clearImage(imageURL: "images/\(self.groupID)/couplePhoto")

                    print("image Uploaded")
                }
                UIView.animate(withDuration: 0.5, animations: {
                })
            }
            else {
                let customAlert = ModalJesus(title: "Status: Limited", description: "Please allow access to your photos in settings or select more photos below.")
                customAlert.addAction(ModalJesusAction(title: "Select Photos", style: true, action: {self.selectPhotos()}))
                customAlert.addAction(ModalJesusAction(title: "Open Settings", style: true, action: {self.goToPrivacySettings()}))
                customAlert.addAction(ModalJesusAction(title: "Cancel", style: false))
                customAlert.showModal(vc: self)
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
        guard var weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()) else{
            return
        }
        
        let vc = GoalsVC(groupID: groupID)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
