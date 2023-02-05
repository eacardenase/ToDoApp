//
//  CategoryVC.swift
//  ToDoApp
//
//  Created by Edwin Cardenas on 2/5/23.
//

import UIKit
import CoreData

class CategoryVC: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoriesArray: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDoCategory))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        loadCategories()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categoriesArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(categoriesArray[indexPath.row])
    }

    @objc func addToDoCategory() {
        let ac = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            
            guard let category = ac?.textFields?[0].text else { return }
            
            self?.submitCategory(category)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submitCategory(_ category: String) {
        if category.count < 3 {
            return
        }
        
        let newCategory = Category(context: context)
        newCategory.name = category
        
        categoriesArray.insert(newCategory, at: categoriesArray.count)
        
        saveCategories()
        
        let indexPath = IndexPath(row: categoriesArray.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoriesArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        tableView.reloadData()
    }

}
