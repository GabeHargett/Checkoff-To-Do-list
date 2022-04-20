//
//  WeeksClassVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 3/30/22.
//

//import UIKit
//
//class WeeksClassVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//
//    var weekDatas = [WeekData]()
//
//let tableView = UITableView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        for index in 1...7 {
//            var weekData = WeekData(weekNumber:index, tasks: [])
//
//            if let taskTitles = UserDefaults.standard.array(forKey: "Week\(weekData.weekNumber)Titles") as? [String],
//
//               let taskCompletes = UserDefaults.standard.array(forKey: "Week\(weekData.weekNumber)Completes") as? [Bool] {
//
//                for index in 0..<taskTitles.count {
//
//                    weekData.tasks.append(WeekTask(title: taskTitles[index], isComplete: taskCompletes[index]))
//
//                }
//
//            }
//
//            weekDatas.append(weekData)
//
//
//        }
//
//   setupTableView()
//
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return weekDatas.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: WeekTableViewCell.identifier,
//                                                 for: indexPath) as! WeekTableViewCell
//        cell.backgroundColor = weekDatas[indexPath.item].allTasksComplete() ? .blue : .yellow
//        cell.weekLabel.text = "Week \(weekDatas[indexPath.item].weekNumber)"
//
//
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let week1Data = WeekData(weekNumber: indexPath.item + 1, tasks: [])
//        let vc = FirstVC(weekData: week1Data)
//        vc.delegate = self
//        navigationController?.pushViewController(vc, animated: true)
//
//     }
//
//
//    func setupTableView() {
//        view.addAutoLayoutSubview(tableView)
//        tableView.fillSuperview()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(WeekTableViewCell.self,
//                           forCellReuseIdentifier: WeekTableViewCell.identifier)
//    }
//
//
//}
//
//extension WeeksClassVC: FirstVCDelegate {
//
//    func didUpdateData(weekData: WeekData) {
//        if let index = self.weekDatas.firstIndex(where: {$0.weekNumber == weekData.weekNumber}) {
//            self.weekDatas[index] = weekData
//            tableView.reloadData()
//        }
//    }
//}
//
//class WeekTableViewCell: UITableViewCell {
//
//    static let identifier = "WeekTableViewCell"
//
//    let weekLabel = UILabel()
//
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        weekLabel.text = ""
//        weekLabel.font = UIFont.systemFont(ofSize: 50.0)
//        contentView.addAutoLayoutSubview(weekLabel)
//        weekLabel.fillSuperview()
//    }
//
//
//
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
