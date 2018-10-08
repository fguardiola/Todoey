//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by 67621177 on 05/10/2018.
//  Copyright © 2018 67621177. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    //Mark: - Tableview DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
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
            destinationVC.selectedCategory = categories[indexPath.row]
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
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text
                self.categories.append(newCategory)
                self.saveData()
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
    func saveData(){
        //save context to persist data
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
         self.tableView.reloadData()
    }
    
    func loadCategories(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        // use context to fetch categories
        do{
         try categories = context.fetch(request)
        }catch{
            print("Error fetching categories \(error)")
        }
        tableView.reloadData()
    }
}
