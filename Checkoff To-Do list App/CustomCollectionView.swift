//
//  CustomCollectionView.swift
//  Checkoff To-Do list App
//
//  Created by Gabe Hargett on 4/20/22.
//

//import UIKit
//import Firebase
//
//protocol CustomCollectionViewCellDelegate: AnyObject {
//    func didTapCVPencil(goalIndex: Int)
//    func didTapTrash(goalIndex: Int)
//
//}
//
//class CustomCollectionViewCell: UICollectionViewCell {
//    
//    let textLabel = UILabel()
//    private var goals = [Goal]()
//    private var goal: Goal?
//    var taskIndex: Int?
//
//    
//    public let myImageView2: UIImageView = {
//        let imageView2 = UIImageView(image: UIImage(systemName: "pencil"))
//        imageView2.tintColor = .black
//
//        imageView2.isUserInteractionEnabled = true
//
//        return imageView2
//    }()
//    
//    public let myImageView3: UIImageView = {
//        let imageView3 = UIImageView(image: UIImage(systemName: "trash.fill"))
//        imageView3.tintColor = .black
//        imageView3.isUserInteractionEnabled = true
//        
//
//        return imageView3
//    }()
//
//    static let identifier = "CustomCollectionViewCell"
//    weak var delegate: CustomCollectionViewCellDelegate?
//    var goalIndex: Int?
//
//
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        backgroundColor = .black
//        
//        configureSubviews()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    private func configureSubviews() {
//        
//        textLabel.textColor = .black
//        textLabel.textAlignment = .center
//        textLabel.font = UIFont.systemFont(ofSize: 15)
//        addAutoLayoutSubview(textLabel)
//        
//        myImageView2.contentMode = .scaleAspectFit
//        
//        myImageView3.contentMode = .scaleAspectFit
//
//        //start new line after 46 characters
//        
//        
//        addAutoLayoutSubview(myImageView2)
//        NSLayoutConstraint.activate([
//            myImageView2.rightAnchor.constraint(equalTo: rightAnchor,constant: -40),
//            myImageView2.centerYAnchor.constraint(equalTo: centerYAnchor),
//            myImageView2.widthAnchor.constraint(equalToConstant: 26),
//            myImageView2.heightAnchor.constraint(equalToConstant: 26),
//        ])
//        
//        addAutoLayoutSubview(myImageView3)
//        NSLayoutConstraint.activate([
//            myImageView3.rightAnchor.constraint(equalTo: rightAnchor,constant: -10),
//            myImageView3.centerYAnchor.constraint(equalTo: centerYAnchor),
//            myImageView3.widthAnchor.constraint(equalToConstant: 24),
//            myImageView3.heightAnchor.constraint(equalToConstant: 24),
//        ])
//        
//        
//        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(didTapCollectionViewPencil))
//        myImageView2.addGestureRecognizer(gesture2)
//        
//        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(didTapTrash))
//        myImageView3.addGestureRecognizer(gesture3)
//
//    }
//    
//    func configure(goal: Goal) {
//        self.goal = goal
//        textLabel.text = goal.goal
//    }
//    
//
//    @objc func didTapCollectionViewPencil() {
//        if let goalIndex = goalIndex {
//            delegate?.didTapCVPencil(goalIndex: goalIndex)
//        }
//    }
//
//    @objc func didTapTrash() {
//        if let goalIndex = goalIndex {
//            delegate?.didTapTrash(goalIndex: goalIndex)
//        }
//    }
//}
//extension CustomCollectionViewCell: TextInputVCDelegate {
//    func didSubmitText(text: String, textType: TextInputVC.TextType, date: Date?) {
//    }
//}
