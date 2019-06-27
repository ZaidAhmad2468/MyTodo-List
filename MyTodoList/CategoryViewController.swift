//
//  CategoryViewController.swift
//  MyTodoList
//
//  Created by Apple on 6/17/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var  categoryArray = [Category]()
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //    cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = categoryArray[indexPath.row]
        cell.textLabel?.text = item.name
        
      //  cell.accessoryType = item.done ?.checkmark : .none
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MyTodoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow  {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        
    }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Items to MyTodoList", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Items", style: .default) { (action) in
            
            
            let newItem = Category(context: self.context)
            //newItem.done = false
          //  newItem.title = textField.text!
            newItem.name = textField.text!
            
            self.categoryArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Todo"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true,completion:nil )
        
    }
    
    func saveItems() {
        // let encoder = PropertyListEncoder()
        do{
            try context.save()
        }catch {
            print("Error while encoding\(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    func loadItems(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
            
        }catch {
            
            print("Did not fetch data\(error)")
        }
        
    }
    
}
    

