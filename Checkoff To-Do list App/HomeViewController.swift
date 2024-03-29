//
//  HomeViewController.swift
//  Checkoff To-Do list App
//
//  Created by Gabe Hargett on 3/30/22.
//
import Firebase
import UIKit
import Photos

struct IceCream {
    var name: String
    var price: Int
    var awesomeness: Int
}

class Dummy {
//    static var shared = Dummy(myName: "hey")
    var myName: String
    init(myName: String) {
        self.myName = myName
    }
}

class HomeViewController: UIViewController  {
    
    override func loadView() {
        view = baseView
    }
    
    let baseView = HomeView()
    public let date = Date()
    let dummyClass = Dummy.init(myName: "Gabe")
    private var currentQuote: Quote?
    private let groupID: String
    let iceCreams: [IceCream] = [
        IceCream(name: "vanilla", price: 4, awesomeness: 5),
        IceCream(name: "choc", price: 4, awesomeness: 5),
        IceCream(name: "straw", price: 4, awesomeness: 5),
        IceCream(name: "rockyroad", price: 4, awesomeness: 5),
        IceCream(name: "superman", price: 4, awesomeness: 5),
        IceCream(name: "napolean", price: 4, awesomeness: 5)]
    
    init(groupID: String) {
        self.groupID = groupID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if let getIceCream = getIceCream(name: "choc") {
            print(getIceCream)
        }
        configureBackground()
        downloadImage()
        setUpTapGestures()
        getQuote()
        addProfileViewsForUIDs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getTaskCount()
        getGoalCount()
    }
    
    func getIceCream(name: String) -> IceCream? {
        for iceCream in iceCreams {
            if name == iceCream.name{
                return iceCream
            }
        }
        return nil
    }
//    func updateDeviceID(deviceID: String, completion: @escaping () -> ()) {
//
//            guard let uid = FirebaseAPI.shared.currentUserID() else {
//
//                completion()
//
//                return
//
//            }
//
//            let ref = Database.database().reference().child("Users").child(uid).child("deviceID")
//
//            ref.setValue(deviceID) {error, ref in
//
//                completion()
//
//            }
//
//        }
//
//        func getDeviceID(uid: String, completion: @escaping (String?) -> ()) {
//
//            let ref = Database.database().reference().child("Users").child(uid).child("deviceID")
//
//            ref.observeSingleEvent(of: .value, with: {snapshot in
//
//                completion(snapshot.value as? String)
//
//            })
//
//        }

    
    private func configureBackground() {
        FirebaseAPI.getGroupTitle(groupID: groupID) {title in
            self.title = title
        }
        view.backgroundColor = .mainColor6
        navigationItem.hidesBackButton = true
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
                    self.baseView.finishedTasksLabel.text = "\(completedTask) Finished Tasks"
                    self.baseView.openTasksLabel.text = "\(currentWeekTask.count - completedTask) Open Tasks"
                }
            }
        }
    }
    
    private func getGoalCount() {
        FirebaseAPI.getGoals(groupID: groupID) {result in
            if let allGoals = result {
                DispatchQueue.main.async {
                    var completedGoals = 0
                    for goal in allGoals {
                        if goal.isComplete {
                            completedGoals += 1
                        }
                    }
                    self.baseView.finishedGoalsLabel.text = "\(completedGoals) Finished Goals"
                    self.baseView.startedGoalsLabel.text = "\(allGoals.count - completedGoals) Started Goals"
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
            self.baseView.addQuoteButtonStack.isHidden = true
        } else {
            self.baseView.quoteGradient.isHidden = true
            self.baseView.quoteStack.isHidden = true
            self.baseView.addQuoteButtonStack.isHidden = false
        }
    }
    
    private func updateQuoteButton(quote: Quote) {
        self.baseView.quoteLabel.text =  "\"" + quote.text + "\""
        self.baseView.quoteSignature.text = "- " + quote.author
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
    
    @objc private func showImagePicker() {
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
    
    func setUpTapGestures() {
        baseView.currentWeekTasksStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCurrentWeek)))
        baseView.previousWeekLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPreviousWeek)))
        baseView.nextWeekLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapNextWeek)))
        baseView.otherWeeksLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOtherWeek)))
        baseView.mainGoalsStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapGoalsStack)))
        baseView.quoteStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addQuote)))
        baseView.addQuoteButtonStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addQuote)))        
        baseView.editPhotoButtonStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagePicker)))
    }
    
    @objc private func didTapCurrentWeek() {
        guard let weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date()) else{
            return
        }
        let vc = WeeksVC(groupID: groupID, weekAndYear: weekAndYear)
        vc.dummy = self.dummyClass
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
    
    @objc private func didTapSettings() {
        let vc = SettingsVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: ProfileViewDelegate {
    
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
}

extension HomeViewController:  EditProfileViewVCDelegate {
    
    func updateProfileView(image: UIImage?, emoji: String?, uid: String) {
        let vc = EditProfileViewVC(initialProfileImage: image, initialEmoji: emoji, uid: uid)
        vc.delegate = self
        vc.showModal(vc: self)
    }
}

extension HomeViewController: SettingsVCDelegate{
    func updateColor() {
        guard let uid = FirebaseAPI.currentUserUID(), let profileView = profileViewFor(uid: uid) else {
            return
        }
        baseView.setColors()
        configureBackground()
        profileView.profileImage.tintColor = .mainColor1
        
    }
    
    func updateGroupName() {
        configureBackground()
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
        
        if let image = info[.editedImage]as? UIImage {
            baseView.couplePhoto.image = image
            FirebaseAPI.uploadImage(groupID: groupID, image: image) {
                ImageAssetHelper.clearImage(imageURL: "images/\(self.groupID)/couplePhoto")
            }
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
}
