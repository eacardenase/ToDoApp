//
//  ViewController.swift
//  ToDoApp
//
//  Created by Edwin Cardenas on 2/2/23.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListVC: SwipeTableVC {
    
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadToDos()
        }
    }
    var todoList: Results<ToDo>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDo))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = .systemCyan
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let todo = todoList?[indexPath.row] {
            let darkenPercentage = CGFloat(indexPath.row) / CGFloat(todoList!.count)
            if let backgroundColor = UIColor(hexString: selectedCategory!.backgroundColor)?.darken(byPercentage: darkenPercentage) {
                cell.backgroundColor = backgroundColor
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor, returnFlat: true)
            }
            
            cell.textLabel?.text = todo.title
            cell.accessoryType = todo.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No ToDos Added Yet"
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let todo = todoList?[indexPath.row] {
            do {
                try realm.write {
                    todo.done = !todo.done
                }
            } catch {
                print("Error updating ToDo: \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @objc func addToDo() {
        let ac = UIAlertController(title: "Add ToDo", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in

            guard let todo = ac?.textFields?[0].text else { return }

            self?.submit(todo)
        }

        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(ac, animated: true)
    }
    
    //MARK: - Model Manipulation Methods
    
    func submit(_ todo: String) {
        if todo.count < 3 {
            return
        }
        
        let newTodo = ToDo()
        newTodo.title = todo

        saveToDo(newTodo)
        
        if let todos = todoList {
            let indexPath = IndexPath(row: todos.count - 1, section: 0)

            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func saveToDo(_ todo: ToDo) {
        
        if let currentCategory = selectedCategory {
            do {
                try realm.write {
                    currentCategory.todos.append(todo)
                }
            } catch {
                print("Error saving ToDo: \(error)")
            }
        }
    }
    
    func loadToDos() {
        todoList = selectedCategory?.todos.sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let todo = self.todoList?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(todo)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
        }
    }

}

//MARK: - UISearchBarDelegate

extension ToDoListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text!.isEmpty {
            
            loadToDos()

            DispatchQueue.main.async {
                [weak searchBar] in

                searchBar?.resignFirstResponder()
            }

            return
        }
        
        todoList = todoList?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
}
