//
//  TodoListViewController.swift
//  TodoList
//
//  Created by Akash Pawar on 7/12/19.
//  Copyright © 2019 Akash Pawar. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    


    
    // Step 8
    
 //   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Step: 4
    
   // let defaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Step 9
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.separatorStyle = .none
        //Step 7
        

       // print(dataFilePath)
        
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
        
        
//        Step 10
        
        
         // loadItems()
        
        //Step 5: persist local data storage using NSUserDefaults
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
   //     // Do any additional setup after loading the view.
        
            
    }
    
    override func  viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        guard let colorHex = selectedCategory?.colour else {fatalError()}
        updateNavBar(withHexCode: colorHex)

        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {

            updateNavBar(withHexCode: "1D9BF6")
      }

    // Mark Nav Bar Setup methods
    
    func updateNavBar(withHexCode colourHexCode: String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exists.")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else {fatalError()}
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        searchBar.barTintColor = navBarColour

        
    }
    

    // Mark tableview datasource methods Step :1
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
        cell.textLabel?.text = item.title
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat( todoItems!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            
                
            
        // Ternary operator Step: 6
        // value = condition ? valueIfTrue : valueIFfalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No Items Added"
        }
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
        
        if let item = todoItems?[indexPath.row]{
            do {
            try realm.write {
  //              realm.delete(item)
                item.done = !item.done
            }
            }catch{
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
       // print(itemArray[indexPath.row])
        
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        

 //       context.delete(itemArray[indexPath.row])
 //       itemArray.remove(at: indexPath.row)
          //saveItems()
        
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
            
            if let currentCategory = self.selectedCategory{

            do {
            try self.realm.write {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                currentCategory.items.append(newItem)
                }
                
            }catch{
                print("Error saving new items, \(error)")
            }
            }
            self.tableView.reloadData()
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
            
     //       self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
     //       self.saveItems()
        }
        
            alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField

        }
    
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    
    
}
//    func saveItems() {
//  //      let encoder = PropertyListEncoder()
//
//        do {
//           try context.save()
////            let data = try encoder.encode(itemArray)
////            try data.write(to: dataFilePath!)
//        } catch {
//            print("Error saving context,\(error)")
//        }
//
//        self.tableView.reloadData()
//    }
    

    // Mark Model Manipulation Methods
    // Step 7
    
    //Step 8
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate{
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }
//        else{
//            request.predicate = categoryPredicate
//
//        }
////        let compoundpredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
////        request.predicate = compoundpredicate
//
//        //Step 9
//
//
// //       let request : NSFetchRequest<Item> = Item.fetchRequest()
//        do {
//        itemArray = try context.fetch(request)
//        }
//        catch {
//            print("Error fetching data from context \(error)")
//        }
//       if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error decoding item array \(error)")
//            }
//        }
//    }

    }
    
    override func updateModel(at indexpath: IndexPath) {
        if let item = todoItems?[indexpath.row]{
            do{
                try realm.write{
                realm.delete(item)
            }
            } catch{
                print("Error deleting items\(error)")
            }
    }
    }
}

// Mark - Search Bar methods

extension TodoListViewController : UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    
            tableView.reloadData()
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate
//
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//
//        loadItems(with: request, predicate: predicate)
//        do {
//            itemArray = try context.fetch(request)
//        }
//        catch {
//            print("Error fetching data from context \(error)")
//        }

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //Step 11
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

}
