//
//  FirstVC.swift
//  Checkoff To-Do list App
//
//  Created by Gabe Hargett on 3/30/22.
//


import UIKit
import Firebase

class WeeksVC: UIViewController {
    
    enum Section: Int {
        case incomplete = 0
        case completed = 1
    }
    
    private let baseView = WeeksView()
    
    override func loadView() {
        view = baseView
    }
    
    private var weekAndYear: WeekAndYear
    private let groupID: String
    public var dummy: Dummy?
    private let sections: [Section] = [.incomplete, .completed]
    private let serverKey = "AAAACGeB3PI:APA91bHMp1ssgQnkL7jbSjM00hdTtT0OBgsYYVGJfnKiJsWawXEjqgjb7b_foELO5MKuKs8uAIL0x3gXrbn8_grffFAGtWrq-NyfM09yEudyZFrI_wVAOPB6VUEAghSKXJbkmkdFbzsf"
    
    
    init(groupID: String, weekAndYear: WeekAndYear) {
        self.weekAndYear = weekAndYear
        self.groupID = groupID
        super.init(nibName: nil, bundle: nil)
    }
    
    private var tasks = [Task]()
    private var editedTaskIndex: Int?
    //    let textInput = TextInputVC(textType: .task)
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView.tableView.dataSource = self
        setupNavbar()
        loadTasks()
        print(dummy?.myName)
    }
    
    private func setupNavbar() {
        let sunday = Calendar.current.date(from: DateComponents(calendar: .current, timeZone: .current, era: nil, year: nil, month: nil, day: nil, hour: 12, minute: 0, second: 0, nanosecond: 0, weekday: 1, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: weekAndYear.week, yearForWeekOfYear: weekAndYear.year))
        let saturday = Calendar.current.date(from: DateComponents(calendar: .current, timeZone: .current, era: nil, year: nil, month: nil, day: nil, hour: 12, minute: 0, second: 0, nanosecond: 0, weekday: 7, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: weekAndYear.week, yearForWeekOfYear: weekAndYear.year))
        
        let weeks = "\(sunday!.dateString()) - \(saturday!.dateString())"
        
        title = "\(weeks)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .done,
            target: self,
            action: #selector(addItem)
        )
    }
    
    private func loadTasks() {
        FirebaseAPI.getTasks(groupID: groupID) {result in
            if let allTasks = result {
                self.tasks = allTasks.filter({task in
                    let taskDate = Date(timeIntervalSince1970: task.dateStamp)
                    let taskWeekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: taskDate)
                    return self.weekAndYear == taskWeekAndYear
                })
                DispatchQueue.main.async {
                    self.baseView.tableView.reloadData()
                }
            }
        }
    }
    
    @objc private func addItem() {
        let vc = TextInputVC(textType: .task)
        vc.delegate = self
        vc.showModal(vc: self)
    }
    
    func sendNotification(title: String, uid: String, message: String) {
        FirebaseAPI.getDeviceID(uid: uid) {deviceID in
                        guard let deviceID = deviceID else {
                            return
                        }
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : deviceID,
                                           "notification" : ["title" : title, "body" : message]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(self.serverKey)", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
}

extension WeeksVC: TextInputVCDelegate {
    func didSubmitText(text: String, text2: String?, textType: TextInputVC.TextType, date: Date?) {
        let dateStamp = date?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        let weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date.init(timeIntervalSince1970: dateStamp))
        
        if let editedTaskIndex = editedTaskIndex {
            self.editedTaskIndex = nil
            tasks[editedTaskIndex].dateStamp = dateStamp
            tasks[editedTaskIndex].title = text
            FirebaseAPI.editTask(task:tasks[editedTaskIndex], groupID: groupID)
            FirebaseAPI.editTaskDate(task:tasks[editedTaskIndex], groupID: groupID)
        } else {
            if let personalUid = FirebaseAPI.currentUserUID(),
               let id = FirebaseAPI.addTask(task: Task(id: "",
                                                       title: text,
                                                       isComplete: false,
                                                       dateStamp: dateStamp,
                                                       author: personalUid),
                                            groupID: groupID),
               self.weekAndYear == weekAndYear {
                tasks.append(Task(id: id, title: text, isComplete: false, dateStamp: dateStamp, author: personalUid))
                FirebaseAPI.getFullName(uid: personalUid) {result in
                    if let fullName = result {
                        FirebaseAPI.getUIDsForGroup(groupID: self.groupID) {result in
                            if let uids = result {
                                for uid in uids {
                                    if uid != personalUid {
                                        self.sendNotification(title: "\(fullName.firstName) created a new task", uid: uid, message: "\"\(text)\"")
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        baseView.tableView.reloadData()
    }
}

extension WeeksVC: TaskCellDelegate {
    func didTapPencil(task: Task) {
        if let taskIndex = tasks.firstIndex(where: {$0.id == task.id}) {
            
            editedTaskIndex = taskIndex
            let vc = TextInputVC(textType: .task)
            vc.textField.text = task.title
//            vc.dateInput.text = task.dateStamp
            vc.delegate = self
            vc.showModal(vc: self)
        }
    }
    
    func didCheckBox(task: Task) {
        if let taskIndex = tasks.firstIndex(where: {$0.id == task.id}) {
            tasks[taskIndex].isComplete.toggle()
            FirebaseAPI.completeTask(task: tasks[taskIndex], groupID: groupID)
            baseView.tableView.reloadData()
        }
    }
}

extension WeeksVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .incomplete:
            return tasks.filter({!$0.isComplete}).count
        case .completed:
            return tasks.filter({$0.isComplete}).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as! TaskCell
        cell.delegate = self
        
        let task: Task
        switch sections[indexPath.section] {
        case .incomplete:
            task = tasks.filter({!$0.isComplete})[indexPath.item]
        case .completed:
            task = tasks.filter({$0.isComplete})[indexPath.item]
        }
        cell.configureCell(task: task)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            let task: Task
            switch sections[indexPath.section] {
            case .incomplete:
                task = tasks.filter({!$0.isComplete})[indexPath.item]
            case .completed:
                task = tasks.filter({$0.isComplete})[indexPath.item]
            }
            if let taskIndex = tasks.firstIndex(where: {$0.id == task.id}) {
                let removeTask = self.tasks.remove(at: taskIndex)
                self.baseView.tableView.deleteRows(at: [indexPath], with: .automatic)
                FirebaseAPI.removeTask(task: removeTask, groupID: groupID)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section] {
        case .incomplete:
            return "Incomplete tasks"
        case .completed:
            return "Completed tasks"
        }
    }
}

class WeeksView: UIView {
    
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        configureSubviews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureSubviews() {
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
    }
    
    private func configureLayout() {
        addAutoLayoutSubview(tableView)
        tableView.fillSuperview()
    }
}
