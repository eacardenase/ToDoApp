//
//  ToDo.swift
//  ToDoApp
//
//  Created by Edwin Cardenas on 2/6/23.
//

import Foundation
import RealmSwift

class ToDo: Object {
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
