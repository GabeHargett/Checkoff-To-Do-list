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
}


class FirebaseAPI {



    
    let storage = Storage.storage().reference()
    
    static func addQuote(quotePoop: Quote) {
        let ref = Database.database().reference().child("Quote")
        ref.setValue(["quote": quotePoop.text, "author": quotePoop.author])
    }
 
    static func getQuote(completion: @escaping (Quote?) -> ()) {
        let ref = Database.database().reference().child("Quote")
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
//    static func addAuthor(author: Author) -> String? {
//        let ref = Database.database().reference().child("Author").childByAutoId()
//        ref.setValue(["author": author.author])
//        return ref.key
//    }
//    static func editAuthor(author: Author) {
//        let ref = Database.database().reference().child("Author").child(author.id).child("author")
//        ref.setValue(author.author)
//    }
//
//    static func getAuthor(completion: @escaping ([Author]?) -> ()) {
//        let ref = Database.database().reference().child("Author")
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            var authors = [Author]()
//            for child in snapshot.children.allObjects as! [DataSnapshot] {
//                if let value = child.value as? [String: Any] {
//                       if let author = value["author"] as? String {
//                        authors.append(Author(id:child.key, author: author))
//                    }
//                }
//            }
//            completion(authors)
//        }, withCancel: {error in
//            completion(nil)
//        })
//    }
    static func addUser(user: User) {
        let ref = Database.database().reference().child("Users").child(user.id)
        ref.setValue(["fullName": ["firstName": user.fullName.firstName, "lastName": user.fullName.lastName], "dateJoined": user.dateJoined])
    }
    
    static func getFullName(uid: String, completion: @escaping (FullName?) -> ()) {
        let ref = Database.database().reference().child("Users").child(uid).child("fullName")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let fullNameDict = snapshot.value as? [String: Any], let firstName = fullNameDict["firstName"] as? String, let lastName = fullNameDict["lastName"] as? String {
                completion(FullName(firstName: firstName, lastName: lastName))
            } else {
                completion(nil)
            }

        }, withCancel: {error in
            completion(nil)
        })
    }
    
    static func addGoal(goal: Goal) -> String? {
        let ref = Database.database().reference().child("Goals").childByAutoId()
        ref.setValue(["goal": goal.goal, "dateStamp": goal.dateStamp, "author": goal.author])
        return ref.key
    }

    static func editGoal(goal: Goal) {
        let ref = Database.database().reference().child("Goals").child(goal.id).child("goal")
        ref.setValue(goal.goal)
    }
    static func removeGoal(goal: Goal) {
        let ref = Database.database().reference().child("Goals").child(goal.id)
        ref.removeValue()
    }
    

    static func getGoals(completion: @escaping ([Goal]?) -> ()) {
        let ref = Database.database().reference().child("Goals")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var goals = [Goal]()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? [String: Any] {
                    if let goal = value["goal"] as? String,
                       let dateStamp = value["dateStamp"] as? Double,
                       let author = value["author"] as? String {
                        goals.append(Goal(id:child.key, goal: goal, dateStamp: dateStamp, author: author))
                    }
                }
            }
            completion(goals)

        }, withCancel: {error in
            completion(nil)
        })
    }
    
    static func addTask(task: Task) -> String? {
        let ref = Database.database().reference().child("Tasks").childByAutoId()
        ref.setValue(["title": task.title , "author": task.author, "dateStamp": task.dateStamp, "isComplete": task.isComplete ])
        return ref.key
    }
    static func completeTask(task: Task) {
        let ref = Database.database().reference().child("Tasks").child(task.id).child("isComplete")
        ref.setValue(task.isComplete)
    }
    static func editTask(task: Task) {
        let ref = Database.database().reference().child("Tasks").child(task.id).child("title")
        ref.setValue(task.title)
    }
    static func removeTask(task: Task) {
        let ref = Database.database().reference().child("Tasks").child(task.id)
        ref.removeValue()
    }

    static func getTasks(completion: @escaping ([Task]?) -> ()) {
        let ref = Database.database().reference().child("Tasks")
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
    static func downloadImage(completion: @escaping (UIImage?) -> ()) {
            let ref = Storage.storage().reference().child("images/couplePhoto")
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
    static func uploadImage(image: UIImage, completion: @escaping () -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            return
        }
        let imageURL = "images/couplePhoto"
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
}
