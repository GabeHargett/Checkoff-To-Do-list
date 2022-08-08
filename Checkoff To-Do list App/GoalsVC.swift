//
//  File.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 5/10/22.
//

import UIKit
import Firebase





class GoalsVC: UIViewController {
 
    
    
    enum Section: Int {
        case incomplete = 0
        case completed = 1
    }
    
    private let baseView = GoalsView()
    
    override func loadView() {
        view = baseView
    }
    private let groupID: String
    private let sections: [Section] = [.incomplete, .completed]
    
    init(groupID: String) {
        self.groupID = groupID
        super.init(nibName: nil, bundle: nil)
    }
    
    private var goals = [Goal]()
    private var editedGoalIndex: Int?
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView.tableView.dataSource = self
        setupNavBar()
        loadGoals()
    }
    
    private func setupNavBar() {
        title = "Group Goals"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .done,
            target: self,
            action: #selector(addItem)
        )
    }
    private func loadGoals() {
        FirebaseAPI.getGoals(groupID: groupID) {result in
            if let allGoals = result {
                self.goals = allGoals
                DispatchQueue.main.async {
                    self.baseView.tableView.reloadData()
                }
            }
        }
    }
    
    @objc private func addItem() {
        let vc = TextInputVC(textType: .goal)
        vc.delegate = self
        vc.showModal(vc: self)
    }
}

extension GoalsVC: TextInputVCDelegate {
    func didSubmitText(text: String, text2: String?, textType: TextInputVC.TextType, date: Date?) {
        let dateStamp = date?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
//        let weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date.init(timeIntervalSince1970: dateStamp))
        if let editedGoalIndex = editedGoalIndex {
            self.editedGoalIndex = nil
            goals[editedGoalIndex].title = text
            FirebaseAPI.editGoal(goal:goals[editedGoalIndex], groupID: groupID)
        }
        else {
            if let uid = FirebaseAPI.currentUserUID(),
               let id = FirebaseAPI.addGoal(goal: Goal(id: "",
                                                       title: text,
                                                       dateStamp: dateStamp,
                                                       isComplete: false,
                                                       author: uid),
                                            groupID: groupID) {
                goals.append(Goal(id: id,
                                  title: text,
                                  dateStamp: dateStamp,
                                  isComplete: false,
                                  author: uid))
            }
        }
        baseView.tableView.reloadData()
    }
}

extension GoalsVC: GoalCellDelegate {
    func didTapPencil(goal: Goal) {
        if let goalIndex = goals.firstIndex(where: {$0.id == goal.id}) {
            editedGoalIndex = goalIndex
            let vc = TextInputVC(textType: .goal)
            vc.textField.text = goal.title
            vc.delegate = self
            vc.showModal(vc: self)
        }
    }
    
    func didCheckBox(goal: Goal) {
        if let goalIndex = goals.firstIndex(where: {$0.id == goal.id}) {
            goals[goalIndex].isComplete.toggle()
            FirebaseAPI.completeGoal(goal: goals[goalIndex], groupID: groupID)
            baseView.tableView.reloadData()
        }
    }
}

extension GoalsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .incomplete:
            return goals.filter({!$0.isComplete}).count
        case .completed:
            return goals.filter({$0.isComplete}).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GoalCell.identifier, for: indexPath) as! GoalCell
        cell.delegate = self
        let goal: Goal
        switch sections[indexPath.section] {
        case .incomplete:
            goal = goals.filter({!$0.isComplete})[indexPath.item]
        case .completed:
            goal = goals.filter({$0.isComplete})[indexPath.item]
        }
        cell.configureCell(goal: goal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            let goal: Goal
            switch sections[indexPath.section] {
            case .incomplete:
                goal = goals.filter({!$0.isComplete})[indexPath.item]
            case .completed:
                goal = goals.filter({$0.isComplete})[indexPath.item]
            }
            if let goalIndex = goals.firstIndex(where: {$0.id == goal.id}) {
                let removeGoal = self.goals.remove(at: goalIndex)
                self.baseView.tableView.deleteRows(at: [indexPath], with: .automatic)
                FirebaseAPI.removeGoal(goal: removeGoal, groupID: groupID)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section] {
        case .incomplete:
            return "Incomplete goals"
        case .completed:
            return "Completed goals"
        }
    }
}
class GoalsView: UIView {
    
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
        tableView.register(GoalCell.self, forCellReuseIdentifier: GoalCell.identifier)
    }
    
    private func configureLayout() {
        addAutoLayoutSubview(tableView)
        tableView.fillSuperview()
    }
}

