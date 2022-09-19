//
//  HomeModal.swift
//  Checkoff To-Do list App
//
//  Created by Gabe Hargett on 9/19/22.
//

import UIKit

struct WeekAndYear: Equatable {
    var week: Int
    var year: Int
}

struct Quote {
    var text: String
    var author: String
}

struct Task {
    let id: String
    var title: String
    var isComplete: Bool
    var dateStamp: Double
    let author: String
}

struct Goal {
    let id: String
    var title: String
    var dateStamp: Double
    var isComplete: Bool
    let author: String
}

