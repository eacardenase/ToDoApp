//
//  ViewController.swift
//  ToDoApp
//
//  Created by Edwin Cardenas on 2/2/23.
//

import UIKit

class ToDoListVC: UITableViewController {
    
    let defaults = UserDefaults.standard
    var itemsArray = [
        ToDo(title: "Be an iOS expert", done: false),
        ToDo(title: "Read Fahrenheit 421", done: true),
        ToDo(title: "Find happyness", done: false),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [ToDo] {
            itemsArray = items
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDo))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let todo = itemsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = todo.title
        cell.accessoryType = todo.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath)
        
        let todo = itemsArray[indexPath.row]
        todo.done = !todo.done
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @objc func addToDo() {
        let ac = UIAlertController(title: "Add ToDo", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            
            guard let todo = ac?.textFields?[0].text else { return }
            
            self?.submit(todo)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ todo: String) {
        if todo.count < 3 {
            return
        }
        
        let newTodo = ToDo(title: todo, done: false)
        
        itemsArray.insert(newTodo, at: 0)
        
        self.defaults.set(self.itemsArray, forKey: "ToDoListArray")

        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }

}

