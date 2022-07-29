//
//  ImagePickerVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 7/28/22.
//
//
//import UIKit
//
//class ImagePickerVC: UIImagePickerController {
//    

//    
//    private let photoType: PhotoType
//    private let baseView = HomeView()
//    private let groupID: String
//
//    
//    init(photoType: PhotoType, groupID: String) {
//        self.groupID = groupID
//        self.photoType = photoType
//        super.init(nibName: nil, bundle: nil)
//        }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
//    [UIImagePickerController.InfoKey : Any]) {
//        switch photoType {
//        case .profile:
//            if let image2 = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerSecondImage" )]as? UIImage {
//                baseView.profilePhoto.image = image2
//                FirebaseAPI.uploadImage(groupID: groupID, image: image2) {
//                    print("image Uploaded")
//                }
//                UIView.animate(withDuration: 0.5, animations: {
//                    self.baseView.profilePhoto.isHidden = false
//        //                self.baseView.imageAddButton.isHidden = true
//                })
//            }
//        case .group:
//            if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage" )]as? UIImage {
//                baseView.couplePhoto.image = image
//                FirebaseAPI.uploadImage(groupID: groupID, image: image) {
//                    print("image Uploaded")
//                }
//                UIView.animate(withDuration: 0.5, animations: {
//                    self.baseView.couplePhoto.isHidden = false
//        //                self.baseView.imageAddButton.isHidden = true
//                })
//            }
//        }
//
//
//
//    
//    picker.dismiss(animated: true, completion: nil)
//}
//
//func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//    picker.dismiss(animated: true, completion: nil)
//}
//}
