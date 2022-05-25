//
//  File.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 5/10/22.
//

import UIKit
import Firebase


struct Goal {
    let id: String
    var goal: String
    let dateStamp: Double
    let author: String
}

class GoalsVC: UIViewController {
    
    private var weekAndYear: WeekAndYear

    init(weekAndYear: WeekAndYear) {

        self.weekAndYear = weekAndYear
        super.init(nibName: nil, bundle: nil)
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(GoalTableViewCell.self,
                           forCellReuseIdentifier: GoalTableViewCell.identifier)

        return tableView
    }()

    private var goals = [Goal]()
    var editedGoalIndex: Int?  
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
          
        view.backgroundColor = .systemBlue
        view.addAutoLayoutSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self

        let sunday = Calendar.current.date(from: DateComponents(calendar: .current, timeZone: .current, era: nil, year: nil, month: nil, day: nil, hour: 12, minute: 0, second: 0, nanosecond: 0, weekday: 1, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: weekAndYear.week, yearForWeekOfYear: weekAndYear.year))
        let saturday = Calendar.current.date(from: DateComponents(calendar: .current, timeZone: .current, era: nil, year: nil, month: nil, day: nil, hour: 12, minute: 0, second: 0, nanosecond: 0, weekday: 7, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: weekAndYear.week, yearForWeekOfYear: weekAndYear.year))
        
        let weeks = "\(sunday!.dateString()) - \(saturday!.dateString())"
        
        title = "Goals: \(weeks)"
        
        goals.removeAll()

        FirebaseAPI.getGoals() {result in
            if let allGoals = result {
                self.goals = allGoals.filter({goal in
                    let goalDate = Date(timeIntervalSince1970: goal.dateStamp)
                    let goalWeekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: goalDate)
                    return self.weekAndYear == goalWeekAndYear
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        tableView.reloadData()

            navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .done,
            target: self,
            action: #selector(addItem)
            )
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    @objc private func addItem() {
        let vc = TextInputVC(textType: .goal)
        vc.delegate = self
        vc.showModal(vc: self)
    }
}

extension GoalsVC: TextInputVCDelegate {
    func didSubmitText(text: String, textType: TextInputVC.TextType, date: Date?) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let dateStamp = date?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        let weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date.init(timeIntervalSince1970: dateStamp))
        if let editedGoalIndex = editedGoalIndex {
            goals[editedGoalIndex].goal = text
            FirebaseAPI.editGoal(goal:goals[editedGoalIndex])
        }
        else {
            let id = FirebaseAPI.addGoal(goal: Goal(id: "",
                                                    goal: text,
                                                    dateStamp: dateStamp,
                                                    author: uid))
            if self.weekAndYear == weekAndYear {
                goals.append(Goal(id: id!,
                              goal: text,
                              dateStamp: dateStamp,
                              author: uid))
            }
        }
        tableView.reloadData()
    }
}

extension GoalsVC: GoalTableViewCellDelegate {
    func didTapPencil(goalIndex: Int) {
        editedGoalIndex = goalIndex
        let vc = TextInputVC(textType: .goal)
        vc.delegate = self
        vc.showModal(vc: self)
    }
}

extension GoalsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GoalTableViewCell.identifier,
                                                 for: indexPath) as! GoalTableViewCell
        cell.delegate = self
        cell.goalIndex = indexPath.item
        cell.textLabel?.numberOfLines = 0
        FirebaseAPI.getFullName(uid: goals[indexPath.item].author) {result in
            if let fullName = result {
                cell.textLabel?.text = self.goals[indexPath.item].goal + "\n\n" + fullName.firstName
            }
        }
        cell.textLabel?.text = goals[indexPath.item].goal + "\n\n" + goals[indexPath.item].author
        cell.contentView.height(constant: 100)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {


      if editingStyle == .delete {
        print("Deleted")
          let removeGoal = self.goals.remove(at: indexPath.item)
          self.tableView.deleteRows(at: [indexPath], with: .automatic)
          FirebaseAPI.removeGoal(goal: removeGoal)

        }
    }

}

