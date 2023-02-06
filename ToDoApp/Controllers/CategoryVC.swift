//
//  CategoryVC.swift
//  ToDoApp
//
//  Created by Edwin Cardenas on 2/5/23.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryVC: UITableViewController {
    
    let realm = try! Realm()
    var categoriesArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDoCategory))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = .systemCyan
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        
        loadCategories()
        
        tableView.rowHeight = 80.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categoriesArray?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        cell.textLabel?.text = category?.name ?? "No Categories Added Yet"
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ToDoList") as? ToDoListVC {
            let selectedCategory = categoriesArray?[indexPath.row]
 
            vc.selectedCategory = selectedCategory
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - Adding new categories

    @objc func addToDoCategory() {
        let ac = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            
            guard let category = ac?.textFields?[0].text else { return }
            
            self?.submitCategory(category)
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func submitCategory(_ category: String) {
        if category.count < 3 {
            return
        }
        
        let newCategory = Category()
        newCategory.name = category
        
        saveCategory(newCategory)
        
        let indexPath = IndexPath(row: categoriesArray!.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategory(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category: \(error)")
        }
    }
    
    func loadCategories() {
        categoriesArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }

}

//MARK: - SwipeTableViewDelegate

extension CategoryVC: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            if let category = self.categoriesArray?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(category)
                    }
                } catch {
                    print("Error updating ToDo: \(error)")
                }
            }
            
            let index = IndexPath(row: indexPath.row, section: 0)
            tableView.deleteRows(at: [index], with: .automatic)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }

        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }
    
    
}
