//
//  FirebaseAPI.swift
//  Checkoff To-Do list App
//
//  Created by Gabe Hargett on 4/7/22.
//

import Firebase
import UIKit



class FirebaseAPI {
    
    let storage = Storage.storage().reference()
    
    static func currentUserUID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    static func addUser(user: User) {
        let ref = Database.database().reference().child("Users").child(user.id)
        ref.setValue(["fullName": ["firstName": user.fullName.firstName, "lastName": user.fullName.lastName], "dateJoined": user.dateJoined])
    }
    
    static func updateDeviceID(deviceID: String, uid: String, completion: @escaping () -> ()) {
        let ref = Database.database().reference().child("Users").child(uid).child("deviceID")
        ref.setValue(deviceID) {error, ref in
            completion()
        }
    }
    
    static func getDeviceID(uid: String, completion: @escaping (String?) -> ()) {
        let ref = Database.database().reference().child("Users").child(uid).child("deviceID")
        ref.observeSingleEvent(of: .value, with: {snapshot in
            completion(snapshot.value as? String)
        })
    }
    
    static func getFullName(uid: String, completion: @escaping (FullName?) -> ()) {
        if let nameCache = NameCache.shared.getName(uid: uid) {
            completion(nameCache)
            return
        }
        let ref = Database.database().reference().child("Users").child(uid).child("fullName")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let fullNameDict = snapshot.value as? [String: Any], let firstName = fullNameDict["firstName"] as? String, let lastName = fullNameDict["lastName"] as? String {
                let fullName = FullName(firstName: firstName, lastName: lastName)
                completion(fullName)
                NameCache.shared.insertName(uid: uid, name: fullName)
            } else {
                completion(nil)
            }

        }, withCancel: {error in
            completion(nil)
        })
    }
    
    static func addGoal(goal: Goal, groupID: String) -> String? {
        let groupRef = FirebaseAPI.getGroupRef(groupID: groupID)
        let ref = groupRef.child("Goals").childByAutoId()
        ref.setValue(["title": goal.title, "dateStamp": goal.dateStamp, "isComplete": goal.isComplete, "author": goal.author])
        return ref.key
        
    }
    static func completeGoal(goal: Goal, groupID: String) {
        let groupRef = FirebaseAPI.getGroupRef(groupID: groupID)
        let ref = groupRef.child("Goals").child(goal.id).child("isComplete")
        ref.setValue(goal.isComplete)
    }

    static func editGoal(goal: Goal, groupID: String) {
        let groupRef = FirebaseAPI.getGroupRef(groupID: groupID)
        let ref = groupRef.child("Goals").child(goal.id).child("title")
        ref.setValue(goal.title)
    }
    static func editGoalDate(goal: Goal, groupID: String) {
        let groupRef = FirebaseAPI.getGroupRef(groupID: groupID)
        let ref = groupRef.child("Goals").child(goal.id).child("dateStamp")
        ref.setValue(goal.dateStamp)
    }

    static func removeGoal(goal: Goal, groupID: String) {
        let groupRef = FirebaseAPI.getGroupRef(groupID: groupID)
        let ref = groupRef.child("Goals").child(goal.id)
        ref.removeValue()
    }
    

    static func getGoals(groupID: String, completion: @escaping ([Goal]?) -> ()) {
        let groupRef = FirebaseAPI.getGroupRef(groupID: groupID)
        let ref = groupRef.child("Goals")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var goals = [Goal]()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? [String: Any] {
                    if let title = value["title"] as? String,
                       let dateStamp = value["dateStamp"] as? Double,
                       let isComplete = value["isComplete"] as? Bool,
                       let author = value["author"] as? String {
                        goals.append(Goal(id:child.key, title: title, dateStamp: dateStamp, isComplete: isComplete, author: author))
                    }
                }
            }
            completion(goals)

        }, withCancel: {error in
            completion(nil)
        })
    }
    static func getGroupRef(groupID: String) -> DatabaseReference {
        return Database.database().reference().child("Groups").child(groupID)
    }
    
    static func setGroupToken(groupID: String, token: String) {
        let ref = Database.database().reference().child("GroupTokens")
        ref.setValue([token: groupID])
    }
    
    static func readGroupToken(token: String, completion: @escaping (String?) -> ()) {
        let ref = Database.database().reference().child("GroupTokens").child(token)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            completion(snapshot.value as? String)

        }, withCancel: {error in
            completion(nil)
        })
    }
    
    static func getGroupUserID(groupID: String) -> DatabaseReference? {
        if let uid = FirebaseAPI.currentUserUID() {
            return Database.database().reference().child("UserGroups").child(uid).child(groupID)
        }
        return nil
    }
    
    static func getGroupTitle(groupID: String, completion: @escaping (String?) -> ()) {
        if let title = UserDefaults.standard.string(forKey: "groupTitle\(groupID)") {
            completion(title)
        }
        let ref = Database.database().reference().child("Groups").child(groupID).child("title")
        ref.observeSingleEvent(of: .value, with: {snapshot in
            if let title = snapshot.value as? String {
                UserDefaults.standard.set(title, forKey: "groupTitle\(groupID)")
                completion(title)
            } else {
                completion(nil)
            }
        })
    }
    static func setGroupTitle(groupID: String, title: String) {
    let ref = Database.database().reference().child("Groups").child(groupID).child("title")
        ref.setValue(title)
    }
    
    static func addGroup(title: String, completion: @escaping (String?) -> ()) {
        guard let uid = FirebaseAPI.currentUserUID() else {
            return
        }
        let ref = Database.database().reference().child("Groups").childByAutoId()
        ref.setValue(["title": title])
        if let groupID = ref.key {
            let ref = Database.database().reference().child("UserGroups").child(uid)
            ref.setValue(["groups": [groupID]])
            UserDefaults.standard.set(groupID, forKey: "CurrentGroupID")
            let ref2 = Database.database().reference().child("Groups").child(groupID).child("users")
            ref2.setValue([uid]){error, ref in
                completion(groupID)
            }
        }
    }
    
    static func getUserGroups(completion: @escaping ([String]?) -> ()) {
        guard let uid = FirebaseAPI.currentUserUID() else {
            return
        }
        let ref = Database.database().reference().child("UserGroups").child(uid).child("groups")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            completion(snapshot.value as? [String])

        }, withCancel: {error in
            completion(nil)
        })
    }
    
    static func joinGroup(groupID: String, completion: @escaping () -> ()) {
        guard let uid = FirebaseAPI.currentUserUID() else {
            return
        }
        
        let ref = Database.database().reference().child("UserGroups").child(uid)
        ref.setValue(["groups": [groupID]])
        let ref2 = Database.database().reference().child("Groups").child(groupID).child("users")
        ref2.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var currentUsersIDs = snapshot.value as? [String] ?? []
            currentUsersIDs.append(uid)
            ref2.setValue(currentUsersIDs) {error, ref in
                completion()
            }

        }, withCancel: {error in
            
        })
    }
    
    static func addEmoji(emoji: String) {
        guard let uid = FirebaseAPI.currentUserUID() else {
            return
        }
        let ref = Database.database().reference().child("Users").child(uid).child("emoji")
        ref.setValue(emoji)
    }
    
    static func getEmoji(uid: String, completion: @escaping (String?) -> ()) {
        let ref = Database.database().reference().child("Users").child(uid).child("emoji")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
                completion(snapshot.value as? String)
            }, withCancel: {error in
                completion(nil)
            })
    }
    
    static func addQuote(quote: Quote, groupID: String) {
        let groupRef = FirebaseAPI.getGroupRef(groupID: groupID)
        let ref = groupRef.child("Quote")
        ref.setValue(["quote": quote.text, "author": quote.author])
    }
 
    static func getQuote(groupID: String, completion: @escaping (Quote?) -> ()) {
        let groupRef = FirebaseAPI.getGroupRef(groupID: groupID)
        let ref = groupRef.child("Quote")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let quoteDict = snapshot.value as? [String: Any], let quote = quoteDict["quote"] as? String, let author = quoteDict["author"] as? String {
                completion(Quote(text: quote, author: author))
            } else {
                completion(nil)
            }

        }, withCancel: {error in
            completion(nil)
        })
    }
    
    
    static func addTask(task: Task, groupID: String) -> String? {
        let groupRef = FirebaseAPI.getGroupRef(groupID: groupID)
        let ref = groupRef.child("Tasks").childByAutoId()
        ref.setValue(["title": task.title , "author": task.author, "dateStamp": task.dateStamp, "isComplete": task.isComplete ])
        return ref.key
    }
    static func completeTask(task: Task, groupID: String) {
        let groupRef = FirebaseAPI.getGroupRef(groupID: groupID)
        let ref = groupRef.child("Tasks").child(task.id).child("isComplete")
        ref.setValue(task.isComplete)
    }
    static func editTask(task: Task, groupID: String) {
        let groupRef = FirebaseAPI.getGroupRef(groupID: groupID)
        let ref = groupRef.child("Tasks").child(task.id).child("title")
        ref.setValue(task.title)
    }
    static func editTaskDate(task: Task, groupID: String) {
        let groupRef = FirebaseAPI.getGroupRef(groupID: groupID)
        let ref = groupRef.child("Tasks").child(task.id).child("dateStamp")
        ref.setValue(task.dateStamp)
    }
    static func removeTask(task: Task, groupID: String) {
        let groupRef = FirebaseAPI.getGroupRef(groupID: groupID)
        let ref = groupRef.child("Tasks").child(task.id)
        ref.removeValue()
    }

    static func getTasks(groupID: String, completion: @escaping ([Task]?) -> ()) {
        let groupRef = FirebaseAPI.getGroupRef(groupID: groupID)
        let ref = groupRef.child("Tasks")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var tasks = [Task]()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? [String: Any] {
                    if let author = value["author"] as? String,
                       let dateStamp = value["dateStamp"] as? Double,
                        let title = value["title"] as? String,
                       let isComplete = value["isComplete"] as? Bool {
                        tasks.append(Task(id:child.key, title: title, isComplete: isComplete, dateStamp: dateStamp, author: author))
                    }
                }
            }
            completion(tasks)

        }, withCancel: {error in
            completion(nil)
        })
    }
    static func downloadImage(groupID: String, completion: @escaping (UIImage?) -> ()) {
        let imagePath = "images/\(groupID)/couplePhoto"
        ImageAssetHelper.downloadImage(imageURL: imagePath, completion: { result in
        completion(result) })
//            let ref = Storage.storage().reference().child("images/\(groupID)/couplePhoto")
//            ref.getData(maxSize: 1024 * 1024 * 2) { data, error in
//                if let error = error {
//                    print(error)
//                    completion(nil)
//                } else {
//                    if let data = data, let image = UIImage(data: data) {
//                        completion(image)
//                    }
//                }
//            }
        }
    static func uploadImage(groupID: String, image: UIImage, completion: @escaping () -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            return
        }
        let imageURL = "images/\(groupID)/couplePhoto"
        let storageRef = Storage.storage().reference().child(imageURL)
        let newMetadata = StorageMetadata()
        storageRef.putData(imageData, metadata: newMetadata) { (metadata, error) in
            guard metadata != nil else {
                completion()
                // Uh-oh, an error occurred!
                return
            }
            completion()
        }
    }
    
    
    static func getUIDsForGroup(groupID: String, completion: @escaping ([String]?) -> ()) {
        let ref = Database.database().reference().child("Groups").child(groupID).child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            completion(snapshot.value as? [String])
            
        }, withCancel: {error in
            completion(nil)
        })
    }
    
    static func downloadProfileImage(uid: String, completion: @escaping (UIImage?) -> ()) {
        let imagePath = "images/\(uid)/profilePhoto"
        ImageAssetHelper.downloadImage(imageURL: imagePath, completion: { result in
        completion(result) })
//        let ref = Storage.storage().reference().child("images/\(uid)/profilePhoto")
//        ref.getData(maxSize: 1024 * 1024 * 2) { data, error in
//            if let error = error {
//                print(error)
//                completion(nil)
//            } else {
//                if let data = data, let image = UIImage(data: data) {
//                    completion(image)
//                } else {
//                    completion(nil)
//                }
//            }
//        }
    }
    
    static func uploadProfileImages(uid: String, image: UIImage, completion: @escaping () -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            return
        }
        let imageURL = "images/\(uid)/profilePhoto"
        let storageRef = Storage.storage().reference().child(imageURL)
        let newMetadata = StorageMetadata()
        storageRef.putData(imageData, metadata: newMetadata) { (metadata, error) in
            guard metadata != nil else {
                completion()
                // Uh-oh, an error occurred!
                return
            }
            completion()
            let ref = Database.database().reference().child("Users").child(uid).child("imageRef")
            ref.setValue(imageURL)
        }
    }
}
