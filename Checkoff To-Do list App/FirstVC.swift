//
//  FirstVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 3/30/22.
//


import UIKit
import SwiftUI
import Firebase

struct WeekData {

    var weekNumber: Int
    var tasks: [WeekTask]

    
    func allTasksComplete() -> Bool {
        var allComplete = true
        for task in tasks {
            if !task.isComplete {
                allComplete = false
            }
        }
        return allComplete
    }
}

struct WeekTask {

    var title: String
    var isComplete: Bool

}

struct Task {
    
    let id: String
    var title: String
    var isComplete: Bool
    let dateStamp: Double
    let author: String
}

protocol FirstVCDelegate: AnyObject {
//    func hideText(isCompleted: Bool)
    func didUpdateData(weekData: WeekData)
}


class FirstVC: UIViewController {

    
    private var weekData: WeekData
    

    

    init(weekData: WeekData) {

        self.weekData = weekData
        
        super.init(nibName: nil, bundle: nil)

    }

  
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomTableViewCell.self,
                           forCellReuseIdentifier: CustomTableViewCell.identifier)

        return tableView
        

    }()

    private var items = [String]()
    private var weekdata = [WeekData]()
    private var tasks = [Task]()
    var editedTaskIndex: Int?


    weak var delegate: FirstVCDelegate?
    var isCompleted: Bool?
  
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .systemBlue
        tableView.dataSource = self
        view.addAutoLayoutSubview(tableView)
        tableView.fillSuperview()
        title = "Week Task"
        

        tasks.removeAll()

        FirebaseAPI.getTasks() {result in
            if let tasks = result {
                self.tasks = tasks
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }

        tableView.reloadData()

            
        
//        let add = UIBarButtonItem(title: "Add Task", style: .done, target: self, action: #selector(addItem))
//        navigationItem.rightBarButtonItem = add
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .done,
            target: self,
            action: #selector(addItem)
            )
        navigationController?.setToolbarHidden(false, animated: false)
        
    }
    

        
    
    @objc private func addItem() {
        let vc = TextInputVC(textType: .task)
        vc.delegate = self
        vc.showModal(vc: self)
    }
    
}

extension FirstVC: TextInputVCDelegate {
    func didSubmitText(text: String, textType: TextInputVC.TextType) {
                
        if let editedTaskIndex = editedTaskIndex {
            tasks[editedTaskIndex].title = text
            FirebaseAPI.editTask(task:tasks[editedTaskIndex])
        }
        else {
            let id = FirebaseAPI.addTask(task: Task(id: "", title: text, isComplete: false, dateStamp: Date().timeIntervalSince1970 , author: "Gabe"))
            tasks.append(Task(id: id!, title: text, isComplete: false, dateStamp: Date().timeIntervalSince1970 , author: "Gabe"))

        }
        tableView.reloadData()

    }
}

extension FirstVC: CustomTableViewCellDelegate {
    func didTapPencil(taskIndex: Int) {
        editedTaskIndex = taskIndex
        let vc = TextInputVC(textType: .task)
        vc.delegate = self
        vc.showModal(vc: self)

    }
    
    func didCheckBox(taskIndex: Int) {
//        print("checked")
        tasks[taskIndex].isComplete.toggle()
        delegate?.didUpdateData(weekData: weekData)
        FirebaseAPI.completeTask(task: tasks[taskIndex])
   }
}


extension FirstVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier,
                                                 for: indexPath) as! CustomTableViewCell
        
        cell.delegate = self
        cell.taskIndex = indexPath.item
        cell.textLabel?.text = tasks[indexPath.item].title
        if tasks[indexPath.item].isComplete {
            cell.checkbox1.toggle()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

      if editingStyle == .delete {
        print("Deleted")
          self.tasks.remove(at: indexPath.item)
          self.tableView.deleteRows(at: [indexPath], with: .automatic)
          delegate?.didUpdateData(weekData: weekData)

      }
    
    }
}
