//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by 67621177 on 05/10/2018.
//  Copyright © 2018 67621177. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    var categories : Results<Category>?
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    //Mark: - Tableview DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No categories been added yet"
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    //Mark: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // perform segue to go to specific category
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //we have to select a especific category to load itmes on next view
        let destinationVC = segue.destination as! TodoListViewController
       
        if  let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
   
    //Mark: - Add New Category
    @IBAction func addCategoryBtnPressed(_ sender: UIBarButtonItem) {
        //Show alert with texfield to create a new category
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            //Add a new category
            if (textField.text?.count)! > 0{
                let newCategory = Category()
                newCategory.name = textField.text!
                //results is an auto pdating container
//                self.categories.append(newCategory)
                self.save(category: newCategory)
            }
        }
        //add textField on alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New category"
            textField = alertTextField
        }
        alert.addAction(alertAction)
        
        present(alert, animated: true)
        
    }
    
    // MARK: - Data manipulation methods
    func save(category: Category){
        do{
            try realm.write{
                realm.add(category)
                self.tableView.reloadData()
               
            }
        }catch{
            print("Error trying to save entry \(error)")
        }
        
    }
//    func saveData(){
//        //save context to persist data
//        do{
//            try context.save()
//        }catch{
//            print("Error saving context \(error)")
//        }
//         self.tableView.reloadData()
//    }
//
    func loadCategories(){
       // use context to fetch categories
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}
