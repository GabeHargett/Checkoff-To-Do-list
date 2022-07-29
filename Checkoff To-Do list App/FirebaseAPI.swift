//
//  FirebaseAPI.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 4/7/22.
//

import Firebase
import UIKit

struct FullName {
    var firstName: String
    var lastName: String
    
    func firstAndLastInitial() -> String {
        var string = ""
        string.append(firstName + " ")
        if let lastFirst = lastName.first {
            string.append(lastFirst)
            string.append(".")
        }
        return string
    }
}

struct User {
    var id: String
    var fullName: FullName
    var dateJoined: Double
    var imageRef: String?
    var emoji: String?
}

struct Quote {
    var text: String
    var author: String
}

struct Task {
    let id: String
    var title: String
    var isComplete: Bool
    let dateStamp: Double
    let author: String
}

struct Goal {
    let id: String
    var title: String
    let dateStamp: Double
    var isComplete: Bool
    let author: String
}


class FirebaseAPI {
    
    let storage = Storage.storage().reference()
    
    static func currentUserUID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    static func addUser(user: User) {
        let ref = Database.database().reference().child("Users").child(user.id)
        ref.setValue(["fullName": ["firstName": user.fullName.firstName, "lastName": user.fullName.lastName], "dateJoined": user.dateJoined])
    }
    static func addUserToGroup(user: User, groupID: String) {
        let ref = Database.database().reference().child("Groups").child(groupID).child(user.id)
        ref.setValue(user.id)
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
            completion(groupID)
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
    
    static func joinGroup(groupID: String) {
        guard let uid = FirebaseAPI.currentUserUID() else {
            return
        }
        
        let ref = Database.database().reference().child("UserGroups").child(uid)
        ref.setValue(["groups": [groupID]])
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
            let ref = Storage.storage().reference().child("images/\(groupID)/couplePhoto")
            ref.getData(maxSize: 1024 * 1024 * 2) { data, error in
                if let error = error {
                    print(error)
                    completion(nil)
                } else {
                    if let data = data, let image = UIImage(data: data) {
                        completion(image)
                    }
                }
            }
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
        }
    }
    static func downloadGroupProfileImages(user: User, groupID: String, completion: @escaping (UIImage?) -> ()) {
            let groupUser = Database.database().reference().child("Groups").child(groupID).child(user.id)
            let groupImageRef = Database.database().reference().child("Users").child(groupUser).child("imageRef")
            let ref = Storage.storage().reference().child("images/\(groupImageRef)/profilePhoto")
            ref.getData(maxSize: 1024 * 1024 * 2) { data, error in
                if let error = error {
                    print(error)
                    completion(nil)
                } else {
                    if let data = data, let image = UIImage(data: data) {
                        completion(image)
                    }
                }
            }
        }
    static func downloadProfileImages(uid: String, completion: @escaping (UIImage?) -> ()) {
            let ref = Storage.storage().reference().child("images/\(uid)/profilePhoto")
            ref.getData(maxSize: 1024 * 1024 * 2) { data, error in
                if let error = error {
                    print(error)
                    completion(nil)
                } else {
                    if let data = data, let image = UIImage(data: data) {
                        completion(image)
                    }
                }
            }
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
            let ref = Database.database().reference().child("Users").child(uid).child("imageRef")
            ref.setValue(imageURL)
        }
    }
}
