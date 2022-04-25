//
//  CustomCollectionView.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 4/20/22.
//

import UIKit
import Firebase

protocol CustomCollectionViewCellDelegate: AnyObject {
}

class CustomCollectionViewCell: UICollectionViewCell {
    
    let textLabel = UILabel()
    private var goals = [Goal]()
    private var goal: Goal?


    static let identifier = "CustomCollectionViewCell"
    weak var delegate: CustomCollectionViewCellDelegate?
    var goalIndex: Int?


    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureSubviews() {
        
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        textLabel.textAlignment = .center
        textLabel.centerInSuperview()
        addAutoLayoutSubview(textLabel)

    }
    
//    func configure(key: String) {
//        textLabel.text = key.capitalized
//    }
    func configure(index: Int, text: String, goal: Goal) {
        self.goal = goal
        textLabel.text = text
        goals.append(Goal(goal: text, dateStamp: Date().timeIntervalSince1970, author: "Gabe"))

    }
}
