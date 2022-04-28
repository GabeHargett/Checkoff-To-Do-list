//
//  CustomCollectionView.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 4/20/22.
//

import UIKit
import Firebase

protocol CustomCollectionViewCellDelegate: AnyObject {
    func didTapCVPencil(goalIndex: Int)

}

class CustomCollectionViewCell: UICollectionViewCell {
    
    let textLabel = UILabel()
    private var goals = [Goal]()
    private var goal: Goal?
    var taskIndex: Int?
    
    public let myImageView2: UIImageView = {
        let imageView2 = UIImageView(image: UIImage(systemName: "pencil"))
        imageView2.tintColor = .black
        imageView2.isUserInteractionEnabled = true

        return imageView2
    }()

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
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 15)
        addAutoLayoutSubview(textLabel)
        //start new line after 46 characters
        
        
        addAutoLayoutSubview(myImageView2)
        NSLayoutConstraint.activate([
            myImageView2.rightAnchor.constraint(equalTo: rightAnchor,constant: -10),
            myImageView2.centerYAnchor.constraint(equalTo: centerYAnchor),
            myImageView2.widthAnchor.constraint(equalToConstant: 25),
            myImageView2.heightAnchor.constraint(equalToConstant: 25),
        ])
//        NSLayoutConstraint.activate([
//            textLabel.rightAnchor.constraint(equalTo: rightAnchor,constant: -10),
//            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//            textLabel.widthAnchor.constraint(equalToConstant: 25),
//            textLabel.heightAnchor.constraint(equalToConstant: 25),
//        ])
        
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(didTapCollectionViewPencil))
        myImageView2.addGestureRecognizer(gesture2)
    }
    
    func configure(goal: Goal) {
        self.goal = goal
        textLabel.text = goal.goal
    }

    @objc func didTapCollectionViewPencil() {
        if let goalIndex = goalIndex {
            delegate?.didTapCVPencil(goalIndex: goalIndex)
        }
    }
}
extension CustomCollectionViewCell: TextInputVCDelegate {
    func didSubmitText(text: String, textType: TextInputVC.TextType) {
    }
}
