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
    @Persisted var dateCreated: Double = Date().timeIntervalSince1970
    @Persisted(originProperty: "todos") var parentCategory: LinkingObjects<Category>
}
