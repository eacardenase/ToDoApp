//
//  ViewController.swift
//  ToDoApp
//
//  Created by Edwin Cardenas on 2/2/23.
//

import UIKit

class ToDoListVC: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDos.plist")
    var itemsArray = [ToDo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadToDos()
        
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
        
        let todo = itemsArray[indexPath.row]
        todo.done = !todo.done
        
        saveToDos()
        
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
    
    //MARK - Model Manipulation Methods
    
    func submit(_ todo: String) {
        if todo.count < 3 {
            return
        }
        
        let newTodo = ToDo(title: todo, done: false)
        
        itemsArray.insert(newTodo, at: 0)
        
        saveToDos()
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }
    
    func saveToDos() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemsArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding ToDos array \(error)")
        }
    }
    
    func loadToDos() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                itemsArray = try decoder.decode([ToDo].self, from: data)
            } catch {
                print("Error decoding ToDos array \(error)")
            }
            
        }
    }

}

