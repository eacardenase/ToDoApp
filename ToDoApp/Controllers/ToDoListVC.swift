//
//  ViewController.swift
//  ToDoApp
//
//  Created by Edwin Cardenas on 2/2/23.
//

import UIKit
import RealmSwift

class ToDoListVC: UITableViewController {
    
    var selectedCategory: Category? {
        didSet {
//            loadToDos()
        }
    }
    var todosArray = [ToDo]()

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
        
        navigationController?.navigationBar.tintColor = UIColor.white
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
        
        let todo = todosArray[indexPath.row]
        todo.done = !todo.done
//        let index = IndexPath(row: indexPath.row, section: 0)
//        todosArray.remove(at: indexPath.row)
//        context.delete(todo)
//        tableView.deleteRows(at: [index], with: .automatic)
        
//        saveToDos()
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @objc func addToDo() {
//        let ac = UIAlertController(title: "Add ToDo", message: nil, preferredStyle: .alert)
//        ac.addTextField()
//
//        let submitAction = UIAlertAction(title: "Submit", style: .default) {
//            [weak self, weak ac] _ in
//
//            guard let todo = ac?.textFields?[0].text else { return }
//
//            self?.submit(todo)
//        }
//
//        ac.addAction(submitAction)
//        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//
//        present(ac, animated: true)
    }
    
    //MARK: - Model Manipulation Methods
    
//    func submit(_ todo: String) {
//        if todo.count < 3 {
//            return
//        }
//
//        let newTodo = ToDo()
//        newTodo.title = todo
//        newTodo.done = false
//        newTodo.parentCategory =
//
//        todosArray.insert(newTodo, at: todosArray.count)
////        todosArray.append(todo)
//        saveToDos()
//
//        let indexPath = IndexPath(row: todosArray.count - 1, section: 0)
//
//        tableView.insertRows(at: [indexPath], with: .automatic)
//
//    }
    
//    func saveToDos() {
//
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context: \(error)")
//        }
//    }
    
//    func loadToDos(with request: NSFetchRequest<ToDo> = ToDo.fetchRequest(), for predicate: NSPredicate? = nil) {
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            todosArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context: \(error)")
//        }
//
//        tableView.reloadData()
//    }

}

//MARK: - UISearchBarDelegate

//extension ToDoListVC: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchBar.text!.isEmpty {
//            loadToDos()
//
//            DispatchQueue.main.async {
//                [weak searchBar] in
//
//                searchBar?.resignFirstResponder()
//            }
//
//            return
//        }
//
//        let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadToDos(with: request, for: predicate)
//    }
//}
