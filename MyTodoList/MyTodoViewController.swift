//
//  ViewController.swift
//  MyTodoList
//
//  Created by Apple on 5/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class MyTodoViewController: UITableViewController {
    
    var  itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let item = defaults.array(forKey: "TodoListItem") as? [Item] {
            itemArray = item
        }
            
        let newItem = Item()
        newItem.title = "Mangoes"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Mangoes"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Mangoes"
        itemArray.append(newItem3)
        
        }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mytodo", for: indexPath)
        
    //    cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ?.checkmark : .none
        
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Mark :- My Add Items Button
    
    @IBAction func addItems(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Items to MyTodoList", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Items", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            
            self.defaults.set(self.itemArray, forKey: "TodoListItem")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Todo"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true,completion:nil )
    }
    
}



