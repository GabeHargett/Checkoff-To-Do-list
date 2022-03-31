//
//  FirstVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 3/30/22.
//


import UIKit
import SwiftUI


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
    let myTextField: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 300.00, height: 50.00))
        
    weak var delegate: FirstVCDelegate?
    var isCompleted: Bool?
  
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .systemBlue
        tableView.dataSource = self
        view.addAutoLayoutSubview(tableView)
        tableView.fillSuperview()
        title = "Week \(weekData.weekNumber)"
        
        myTextField.center = self.view.center
        myTextField.placeholder = "Place holder text"
        //myTextField.text = "UITextField example"
        myTextField.borderStyle = UITextField.BorderStyle.line
        myTextField.backgroundColor = .white
        myTextField.textColor = UIColor.blue
        myTextField.isHidden = true
        self.view.addSubview(myTextField)
        
        let barButtonItem = UIBarButtonItem(title: "Next Week", style: .done, target: self, action: #selector(didTapToolBarButton))

        if weekData.weekNumber < 7 {
            navigationItem.rightBarButtonItem = barButtonItem
        }
        else if weekData.weekNumber == 7 {
            
        }
        
        weekData.tasks.removeAll()

        if let taskTitles = UserDefaults.standard.array(forKey: "Week\(weekData.weekNumber)Titles") as? [String],

           let taskCompletes = UserDefaults.standard.array(forKey: "Week\(weekData.weekNumber)Completes") as? [Bool] {

            for index in 0..<taskTitles.count {

                weekData.tasks.append(WeekTask(title: taskTitles[index], isComplete: taskCompletes[index]))

            }

        }

        tableView.reloadData()

            
        
        let add = UIBarButtonItem(title: "Add To-Do task", style: .done, target: self, action: #selector(addItem))
        toolbarItems = [add]
        navigationController?.setToolbarHidden(false, animated: false)
        
    }
    
   
    @objc private func didTapToolBarButton() {
        let vc = FirstVC(weekData: WeekData(weekNumber: weekData.weekNumber + 1, tasks: []))
        navigationController?.pushViewController(vc, animated: true)
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //tableView.frame = view.bounds
    }
    
    @objc private func addItem() {
        //myTextField.isHidden = false
        let vc = TextInputVC()
        vc.delegate = self
        vc.showModal(vc: self)
    }
}

extension FirstVC: TextInputVCDelegate {
    func didSubmitText(text: String) {
        weekData.tasks.append(WeekTask(title: text, isComplete: false))
        
        UserDefaults.standard.set(weekData.tasks.map({$0.title}), forKey: "Week\(weekData.weekNumber)Titles")

        UserDefaults.standard.set(weekData.tasks.map({$0.isComplete}), forKey: "Week\(weekData.weekNumber)Completes")
        
        tableView.reloadData()
        
        myTextField.text = nil
    }
}

extension FirstVC: CustomTableViewCellDelegate {
    func didCheckBox(taskIndex: Int) {
        print("checked")
        weekData.tasks[taskIndex].isComplete.toggle()
        delegate?.didUpdateData(weekData: weekData)
        UserDefaults.standard.set(weekData.tasks.map({$0.isComplete}), forKey: "Week\(weekData.weekNumber)Completes")
//       delegate?.hideText(isCompleted: true)
    }
}

extension FirstVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
        return weekData.tasks.count

    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier,
                                                 for: indexPath) as! CustomTableViewCell
        cell.delegate = self
        cell.taskIndex = indexPath.item
        cell.textLabel?.text = weekData.tasks[indexPath.item].title
        if weekData.tasks[indexPath.item].isComplete {
            cell.checkbox1.toggle()
        }
        return cell


    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

      if editingStyle == .delete {
        print("Deleted")
          self.weekData.tasks.remove(at: indexPath.item)
          self.tableView.deleteRows(at: [indexPath], with: .automatic)
          delegate?.didUpdateData(weekData: weekData)
          
          UserDefaults.standard.set(weekData.tasks.map({$0.title}), forKey: "Week\(weekData.weekNumber)Titles")

          UserDefaults.standard.set(weekData.tasks.map({$0.isComplete}), forKey: "Week\(weekData.weekNumber)Completes")
      }
    
    }
}
