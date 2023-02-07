//
//  CategoryVC.swift
//  ToDoApp
//
//  Created by Edwin Cardenas on 2/5/23.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryVC: SwipeTableVC {
    
    let realm = try! Realm()
    var categoriesList: Results<Category>?

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
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categoriesList?[indexPath.row]
        let backgroundColor = category?.backgroundColor ?? "#000000"
        
        cell.textLabel?.text = category?.name ?? "No Categories Added Yet"
        cell.backgroundColor = UIColor(hexString: backgroundColor)
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ToDoList") as? ToDoListVC {
            let selectedCategory = categoriesList?[indexPath.row]
 
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
        newCategory.backgroundColor = UIColor.randomFlat().hexValue()
        
        saveCategory(newCategory)
        
        let indexPath = IndexPath(row: categoriesList!.count - 1, section: 0)
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
        categoriesList = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categoriesList?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
        }
    }

}
