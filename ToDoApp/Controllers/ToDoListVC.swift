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
        "Be an iOS expert",
        "Read Fahrenheit 421",
        "Find happyness"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemsArray = items
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDo))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
        }
        
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
        
        itemsArray.insert(todo, at: 0)
        
        self.defaults.set(self.itemsArray, forKey: "ToDoListArray")

        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }

}

