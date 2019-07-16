//
//  CategoryTableViewController.swift
//  TodoList
//
//  Created by Akash Pawar on 7/13/19.
//  Copyright © 2019 Akash Pawar. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework
//import SwipeCellKit

class CategoryTableViewController: SwipeTableViewController{
    

    let realm = try! Realm()
    var categories : Results<Category>?
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.separatorStyle = .none
      //  tableView.rowHeight = 80.0

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    
    // Mark TableViewDataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]{
        
      //  if let category = categories?[indexPath.row]{
        cell.textLabel?.text = categories?[indexPath.row].name
            
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
        cell.backgroundColor = categoryColour
        cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
//      cell.delegate = sel
       }
        return cell
        
    }
    
    //Mark TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        tableView.reloadData()
    }
    
    //Mark Data Manipulation methods
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving Category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//
//        do {
//        categories = try context.fetch(request)
//        } catch {
//            print("Error loading categories \(error)")
//
//        }
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // Delete data from Swipe
    
    override func updateModel(at indexpath: IndexPath) {
        
        super.updateModel(at: indexpath)
        if let categoryForDeletion = self.categories?[indexpath.row] {
        
            do{
                try self.realm.write {
                self.realm.delete(categoryForDeletion)
                }
            }catch {
                print("Error deleting category \(error)")
                            //    print("Item deleted")
                            // handle action by updating model with deletion
                }
                        // tableView.reloadData()
        }
    }

        
    
    
    // Mark Add new Categories
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textfield.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
  //          self.categories.append(newCategory)
            
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textfield = field
            textfield.placeholder = "Add a new Category"
        }
        
        present(alert, animated: true, completion: nil)
    }

}


