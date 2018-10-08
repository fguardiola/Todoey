//
//  ViewController.swift
//  Todoey
//
//  Created by 67621177 on 13/09/2018.
//  Copyright © 2018 67621177. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var todoData = [Item]();
    //optional because is going to be nil till its set by the other vc
    var selectedCategory: Category? {
        didSet{
            // at this point we know we have a selected category
            loadItems()
        }
    }
    //we need to ccess the APPdelegate class context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var userDefauts = UserDefaults.standard //DB in which you can store dsts for persistency
    
    // Get path to user files current app & add a component to store our items
//    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    // This DB is unique to this app
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
    }

   //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoData.count;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // This line can cause problems. cells are being reused so when cell disappear from screen is going to be used for last elemenet of the list (List is long) so the check mark is going to stay. To avoid that we need to have different objects for each element (Data model)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = todoData[indexPath.row]
    
        
        //we have a reference of the object
        cell.textLabel?.text = item.title;
        
        
        cell.accessoryType = item.done ? .checkmark : .none
       

        //reload data
        return cell;
    }
    //MARK - TableViewController Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //change the done property
        let item = todoData[indexPath.row]
        //remove an item would be. Order matters
        /*
        let item = todoData[indexPath.row]
        context.delete(item)
        todoData.remove(at: indexPath.row)
        self.saveData()
         */
        item.done = !item.done
        //reload data to reflect the accesory type change
        self.tableView.reloadData()
        self.saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        //We need to have access to the textfield that is local to alert.addTextField . We need to give access to that var otside
        var accesibleTextField = UITextField() //create an object
        
        let alert = UIAlertController(title: "Add a new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //Handle user clicks
            if (accesibleTextField.text?.count)! > 0 {
               
                let newItem = Item(context: self.context)
                newItem.title = accesibleTextField.text!;
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.todoData.append(newItem)
                //Persist data
                // Breaking cause we are trying to save custom objects. Not a good use of userDefaults. Need NSCoder
                //self.userDefauts.set(self.todoData, forKey: "TodosArray")
                //even if you have added the item it s not going to be diplayed unless you reload the table
                self.tableView.reloadData()
                //saving dta NScoder
               self.saveData()
                
            }
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New todoey"
            accesibleTextField = alertTextField // Objects are references so we are pointing to the same obj
//            print(alertTextField.text)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    func saveData (){
        do{
            try context.save()
        }catch{
               print("Error saving context \(error)")
        }
    }
    // internal and external parameters with default value
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil){
       //we need to load only items for selected category but from the search you can have another predicate
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            request.predicate  = categoryPredicate
        }
    
        do{
            todoData = try context.fetch(request)
        }catch{
            print("Error fetching the context: \(error)")
        }
        tableView.reloadData()
    }
}

//MARK:- Search bar methods
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Reload table view with data from the query
        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        String comparisons are by default case and diacritic sensitive. You can modify an operator using the key characters c and d within square braces to specify case and diacritic insensitivity respectively, for example firstName BEGINSWITH[cd]
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //sort the data back
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with:request, predicate: predicate)
        
    }
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        loadItems()
//    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            DispatchQueue.main.async {
                //dismiss keyboard and the focus on the search bar
                searchBar.resignFirstResponder()
            }
            loadItems()
        }
    }
}

