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
    func configure(index: Int, goal: Goal) {
        self.goal = goal
        textLabel.text = "\(index)"
//        let gradeString: String = problem.grade == -1 ? "V?" : "V\(problem.grade ?? 0)"
//        if isSearch {
//            titleLabel.text = "\(problem.title ?? ""), \(gradeString)"
//        } else {
//            titleLabel.text = "\(index). \(problem.title ?? ""), \(gradeString)"
//        }
//        if isSearch {
//            self.subtitleLabel.isHidden = false
//            getAreaTitle(cragID: problem.cragID, areaID: problem.areaID)
//        }
//        starsImageView.image = UIImage(named: "\(problem.stars ?? -1)star")
//
//        let sunImager: String
//        switch problem.sun {
//        case .noSun:
//            sunImager = "nosun"
//        case .morningLim:
//            sunImager = "amlim"
//        case .morningFull:
//            sunImager = "amsun"
//        case .allDayLim:
//            sunImager = "lotslim"
//        case .allDayFull:
//            sunImager = "lotssun"
//        case .eveningLim:
//            sunImager = "latelim"
//        case .eveningFull:
//            sunImager = "latesun"
//        default:
//            sunImager = "none"
//        }
//        sunImageView.image = UIImage(named: sunImager)
//
//        if let pads = problem.pads {
//            padCountLabel.text = "= \(pads)"
//        } else {
//            padCountLabel.text = "= ?"
//        }
    }
}
