//
//  FirebaseAPI.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 4/7/22.
//

import Foundation
import Firebase
import UIKit




class FirebaseAPI {
    
    let storage = Storage.storage().reference()

    
    static func setQuote(quote: String) {
        let ref = Database.database().reference().child("Quote")
        ref.setValue(quote)
    }
    
    static func getQuote(completion: @escaping (String?) -> ()) {
        let ref = Database.database().reference().child("Quote")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let quote = snapshot.value as? String {
                completion(quote)
            } else {
                completion(nil)
            }

        }, withCancel: {error in
            completion(nil)
        })
    }
    
    static func setAuthor(quote: String) {
        let ref = Database.database().reference().child("Author")
        ref.setValue(quote)
    }
    
    static func getAuthor(completion: @escaping (String?) -> ()) {
        let ref = Database.database().reference().child("Author")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let quote = snapshot.value as? String {
                completion(quote)
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
