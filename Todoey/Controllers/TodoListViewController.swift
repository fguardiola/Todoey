//
//  ViewController.swift
//  Todoey
//
//  Created by 67621177 on 13/09/2018.
//  Copyright © 2018 67621177. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var todoData = [Item]();
//    var userDefauts = UserDefaults.standard //DB in which you can store dsts for persistency
    
    // Get path to user files current app & add a component to store our items
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    // This DB is unique to this app
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //load data from userdefaults if exist
        print(dataFilePath)
//        if let items = userDefauts.array(forKey: "ToDoArray") as? [Item]{
//            todoData = items
//        }
        let item1 = Item()
        item1.title = "Llamer coxinilla"
        todoData.append(item1)
        
        let item2 = Item()
        item2.title = "Concertar"
        todoData.append(item2)
        
        let item3 = Item()
        item3.title = "Disfrutar de la vida"
        todoData.append(item3)
        
        loadItems()
    }

   //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoData.count;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // This line can cause problems. cells are being reused so when cell dsappear from screen is going to be used for last elmenet of the list (List is long) so the check mark is going to stay. To avoid that we nee to have different objects for each element (Data model)
        
        print("cellrowat indexpath called")
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
                let newItem = Item()
                newItem.title = accesibleTextField.text!;
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
        let encoder = PropertyListEncoder()
        do{
            let dataToEncode = try encoder.encode(self.todoData)
            try dataToEncode.write(to: self.dataFilePath!)
        }catch{
            print("Error encoding item arra, \(error)")
        }
    }
    func loadItems(){
        //decode dat from items plist
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                self.todoData = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding item array \(error)")
            }
        }
        
    }
}

