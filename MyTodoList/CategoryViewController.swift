//
//  CategoryViewController.swift
//  MyTodoList
//
//  Created by Apple on 6/17/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var  categories : Results<Category>?
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        //print(Realm.Configuration.defaultConfiguration.fileURL)

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //    cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = categories?[indexPath.row]
        cell.textLabel?.text = item?.name ?? "No Category found"
        
      //  cell.accessoryType = item.done ?.checkmark : .none
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MyTodoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow  {
            destinationVC.selectedCategory = categories?[indexPath.row]
        
    }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Items to MyTodoList", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Items", style: .default) { (action) in
            
            
            let newCategory = Category()
            //newItem.done = false
          //  newItem.title = textField.text!
            newCategory.name = textField.text!
            
        
            
            self.saveItems(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Todo"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true,completion:nil )
        
    }
    
    func saveItems(category :Category) {
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("Error while encoding\(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    func loadCategory(){
        
         categories = realm.objects(Category.self)
        
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//            categoryArray = try context.fetch(request)
//
//        }catch {
//
//            print("Did not fetch data\(error)")
//        }
        
    }
    
}
    

