//
//  Category.swift
//  ToDoApp
//
//  Created by Edwin Cardenas on 2/6/23.
//

import Foundation
import UIKit
import RealmSwift

class Category: Object {
    @Persisted var name: String = ""
    @Persisted var backgroundColor: String = ""
    @Persisted var todos = List<ToDo>()
}
