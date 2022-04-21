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
    
    let textlabel = UILabel()
    private var goals = [Goal]()

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
        
        textlabel.textColor = .black
        textlabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        textlabel.textAlignment = .center
        textlabel.centerInSuperview()
        addAutoLayoutSubview(textlabel)

//        textlabel.text = goals[indexPath.item].goal

    }
    
    func configure(key: String) {
        textlabel.text = key.capitalized
    }
}
