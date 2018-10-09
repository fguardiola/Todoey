//
//  ViewController.swift
//  Todoey
//
//  Created by 67621177 on 13/09/2018.
//  Copyright © 2018 67621177. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    let realm = try! Realm()
    var todoData : Results<Item>?
    //optional because is going to be nil till its set by the other vc
    var selectedCategory: Category? {
        didSet{
            // at this point we know we have a selected category
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        loadItems()
    }

   //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoData?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // This line can cause problems. cells are being reused so when cell disappear from screen is going to be used for last elemenet of the list (List is long) so the check mark is going to stay. To avoid that we need to have different objects for each element (Data model)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoData?[indexPath.row]{
             cell.textLabel?.text = item.title
             cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No todos added yet"
        }
       

        //reload data
        return cell;
    }
    //MARK - TableViewController Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoData?[indexPath.row]{
            //Update done prperty
            do{
                try realm.write{
                    //if you wanted to delete
//                    realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        //We need to have access to the textfield that is local to alert.addTextField . We need to give access to that var otside
        var accesibleTextField = UITextField() //create an object
        
        let alert = UIAlertController(title: "Add a new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //Handle user clicks
            if (accesibleTextField.text?.count)! > 0 {
               
                if let currentCategory = self.selectedCategory{
                    do{
                        try self.realm.write{
                            //we have to add an item to that selected category
                            let newItem = Item()
                            newItem.title = accesibleTextField.text!
                            newItem.dateCreated = Date()
                            // this is set as default
                            //  newItem.done = false
                            //newItem.parentCategory = self.selectedCategory //we can do it the other way around
                            currentCategory.items.append(newItem)
                        }
                    }catch{
                        print("Error tring to save todo \(error)")
                    }
                   
                }
            
                self.tableView.reloadData()
                
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
    // internal and external parameters with default value
    func loadItems(){
        todoData = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//MARK:- Search bar methods
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Query with realm
        //todoData = todoData?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        //order by date created
        todoData = todoData?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
         tableView.reloadData()
    }

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

