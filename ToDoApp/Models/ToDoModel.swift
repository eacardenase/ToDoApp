//
//  ToDoModel.swift
//  ToDoApp
//
//  Created by Edwin Cardenas on 2/3/23.
//

import Foundation

class ToDo: Codable {
    let title: String
    var done: Bool
    
    init(title: String, done: Bool) {
        self.title = title
        self.done = done
    }
}
