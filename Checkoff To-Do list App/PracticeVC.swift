//
//  PracticeVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 4/27/22.
//

import UIKit

class PracticeVC: UIViewController {
    
    private let boxWithLabel = BoxWithLabel()
    private let boxWithTwoLabels = BoxWithTwoLabels()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let weekAndYear = DateAnalyzer.getWeekAndYearFromDate(date: Date())
//        print(weekAndYear)
//        let sunday = Calendar.current.date(from: DateComponents(calendar: .current, timeZone: .current, era: nil, year: nil, month: nil, day: nil, hour: 12, minute: 0, second: 0, nanosecond: 0, weekday: 1, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: weekAndYear!.week, yearForWeekOfYear: weekAndYear!.year))
//        let saturday = Calendar.current.date(from: DateComponents(calendar: .current, timeZone: .current, era: nil, year: nil, month: nil, day: nil, hour: 12, minute: 0, second: 0, nanosecond: 0, weekday: 7, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: weekAndYear!.week, yearForWeekOfYear: weekAndYear!.year))
//        print(sunday?.timeIntervalSince1970)
//        
        setupBoxes()
    }
    
    private func setupBoxes() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        view.addAutoLayoutSubview(stack)
        stack.fillSuperview()
        stack.addArrangedSubviews([boxWithLabel, boxWithTwoLabels])
        boxWithLabel.changeText(text: "tanners cool")
        boxWithTwoLabels.setStackViewSpacing(spacing: 30)
    }
    
}

class BoxWithLabel: UIView {
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addAutoLayoutSubview(label)
        label.centerInSuperview()
        label.text = "I'm a label"
    }
    func changeText(text: String) {
        label.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class BoxWithTwoLabels: UIView {
    
    private let stack = UIStackView()
    private let leftLabel = UILabel()
    private let rightLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addAutoLayoutSubview(stack)
        stack.centerInSuperview()
        leftLabel.text = "I'm a left label"
        rightLabel.text = "I'm a right label"
        stack.addArrangedSubviews([leftLabel, rightLabel])
    }
    func setStackViewSpacing(spacing: CGFloat) {
        stack.spacing = spacing
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

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
}
