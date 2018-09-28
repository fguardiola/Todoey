//
//  ViewController.swift
//  Todoey
//
//  Created by 67621177 on 13/09/2018.
//  Copyright © 2018 67621177. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var todoData = ["Llamar coxinilla","Concertar cita","Disfrutar de la vida"];
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

   //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoData.count;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = todoData[indexPath.row];
        return cell;
    }
    //MARK - TableViewController Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none;
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        //We need to have access to the textfield that is local to alert.addTextField . We need to give access to that var otside
        var accesibleTextField = UITextField() //create an object
        
        let alert = UIAlertController(title: "Add a new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //Handle user clicks
            if (accesibleTextField.text?.count)! > 0 {
                self.todoData.append(accesibleTextField.text!)
                //even if you have added the item it s not going to be diplayed unless you reload the table
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
}

