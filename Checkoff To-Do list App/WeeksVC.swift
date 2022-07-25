//
//  FirstVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 3/30/22.
//


import UIKit
import Firebase

struct WeekAndYear: Equatable {
    var week: Int
    var year: Int
}

class DateAnalyzer {
    static func getWeekAndYearFromDate(date: Date) -> WeekAndYear? {
        let allComponents = Calendar.current.dateComponents([.year, .weekOfYear], from: date)
        guard let weekOfYear = allComponents.weekOfYear,
              let year = allComponents.year else {
            return nil
        }
        return WeekAndYear(week: weekOfYear, year: year)
    }
    
    static func getMonthAndYearFromDate(date: Date) -> MonthAndYear? {
        let allComponents = Calendar.current.dateComponents([.year, .month], from: date)
        guard let monthOfYear = allComponents.month,
              let year = allComponents.year else {
            return nil
        }
        return MonthAndYear(dateMonth: monthOfYear, year: year)
    }


}

extension Date {
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd YY"
        return dateFormatter.string(from: self)
    }
}
class NameCache {
    static let shared = NameCache()
    var nameDictionary: [String: FullName] = [:]
    func insertName(uid: String, name: FullName) {
        nameDictionary[uid] = name
    }
    func getName(uid: String) -> FullName? {
        return nameDictionary[uid]
    }
}


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
    private let sections: [Section] = [.incomplete, .completed]
    
    init(groupID: String, weekAndYear: WeekAndYear) {
        self.weekAndYear = weekAndYear
        self.groupID = groupID
        super.init(nibName: nil, bundle: nil)
    }
    
    private var tasks = [Task]()
    private var editedTaskIndex: Int?
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView.tableView.dataSource = self
        setupNavbar()
        loadTasks()
        //navigationController?.setToolbarHidden(false, animated: false)
    }
    
    private func setupNavbar() {
        let sunday = Calendar.current.date(from: DateComponents(calendar: .current, timeZone: .current, era: nil, year: nil, month: nil, day: nil, hour: 12, minute: 0, second: 0, nanosecond: 0, weekday: 1, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: weekAndYear.week, yearForWeekOfYear: weekAndYear.year))
        let saturday = Calendar.current.date(from: DateComponents(calendar: .current, timeZone: .current, era: nil, year: nil, month: nil, day: nil, hour: 12, minute: 0, second: 0, nanosecond: 0, weekday: 7, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: weekAndYear.week, yearForWeekOfYear: weekAndYear.year))
        
        let weeks = "\(sunday!.dateString()) - \(saturday!.dateString())"
        
        title = "Tasks: \(weeks)"
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
}

extension WeeksVC: TextInputVCDelegate {
    func didSubmitText(text: String, text2: String?, textType: TextInputVC.TextType, date: Date?) {
        let dateStamp = date?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        let weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date.init(timeIntervalSince1970: dateStamp))
        if let editedTaskIndex = editedTaskIndex {
            self.editedTaskIndex = nil
            tasks[editedTaskIndex].title = text
            FirebaseAPI.editTask(task:tasks[editedTaskIndex], groupID: groupID)
        } else {
            if let uid = FirebaseAPI.currentUserUID(),
               let id = FirebaseAPI.addTask(task: Task(id: "",
                                                       title: text,
                                                       isComplete: false,
                                                       dateStamp: dateStamp,
                                                       author: uid),
                                            groupID: groupID),
               self.weekAndYear == weekAndYear {
                tasks.append(Task(id: id, title: text, isComplete: false, dateStamp: dateStamp, author: uid))
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
