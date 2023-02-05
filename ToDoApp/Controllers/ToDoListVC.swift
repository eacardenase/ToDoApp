//
//  ViewController.swift
//  ToDoApp
//
//  Created by Edwin Cardenas on 2/2/23.
//

import UIKit
import CoreData

class ToDoListVC: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var todosArray = [ToDo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadToDos()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDo))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let todo = todosArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = todo.title
        cell.accessoryType = todo.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = IndexPath(row: indexPath.row, section: 0)
        let todo = todosArray[indexPath.row]
//        todo.done = !todo.done
        
        todosArray.remove(at: indexPath.row)
        context.delete(todo)
        
        saveToDos()
        
        tableView.deleteRows(at: [index], with: .automatic)
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
        
        let newTodo = ToDo(context: context)
        newTodo.title = todo
        newTodo.done = false
        
        todosArray.insert(newTodo, at: todosArray.count)
//        todosArray.append(todo)
        saveToDos()
        
        let indexPath = IndexPath(row: todosArray.count - 1, section: 0)
        
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }
    
    func saveToDos() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func loadToDos() {
        let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        
        do {
            todosArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
    }

}

