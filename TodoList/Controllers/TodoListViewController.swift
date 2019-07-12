//
//  TodoListViewController.swift
//  TodoList
//
//  Created by Akash Pawar on 7/12/19.
//  Copyright © 2019 Akash Pawar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // Step: 4
    
   // let defaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Step 7
        

        print(dataFilePath)
        
        //Step 6
        
//        let item1 = Item()
//        item1.title = "Mark"
//        itemArray.append(item1)
//
//        let item2 = Item()
//        item2.title = "David"
//        itemArray.append(item2)
//
//        let item3 = Item()
//        item3.title = "John"
//        itemArray.append(item3)
//
//        let item4 = Item()
//        item4.title = "Josh"
//        itemArray.append(item4)
        
        loadItems()
        
        //Step 5: persist local data storage using NSUserDefaults
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
   //     // Do any additional setup after loading the view.
        

    }
    

    // Mark tableview datasource methods Step :1
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Ternary operator Step: 6
        // value = condition ? valueIfTrue : valueIFfalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }
//        else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Mark Table view delegate methods Step :2
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
//        if itemArray[indexPath.row].done == false{
//            itemArray[indexPath.row].done = true
//        }
//        else {
//            itemArray[indexPath.row].done = false
//        }
        
     //   tableView.reloadData()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Mark add new items Step: 3
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the userclicks add item button on our alert
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
     //       self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
        }
        
            alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField

        }
    
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    
    
}
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array,\(error)")
        }
        
        self.tableView.reloadData()
    }
    

    // Mark Model Manipulation Methods
    // Step 7
    
    //Step 8
    
    func loadItems() {
       if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array \(error)")
            }
        }
    }
    
    
}
