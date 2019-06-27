//
//  ViewController.swift
//  MyTodoList
//
//  Created by Apple on 5/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import CoreData

class MyTodoViewController: UITableViewController {
    
    
    var  itemArray = [Item]()
    
    var selectedCategory : Category? {
    didSet{
      loadItems()
    }
    }
    
    //print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if let item = defaults.array(forKey: "TodoListItem") as? [Item] {
//            itemArray = item
 //       }
        
      //  loadItems()
      //  self.tableView.keyboardDismissMode = .onDrag
        
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
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        
      //  itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Mark :- My Add Items Button
    
    @IBAction func addItems(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Items to MyTodoList", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Items", style: .default) { (action) in
            
            
            let newItem = Item(context: self.context)
            newItem.done = false
            newItem.title = textField.text!
            newItem.parentCategory = self.selectedCategory
            
            
            self.itemArray.append(newItem)
            
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

    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest() ){
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        request.predicate = predicate
        
        do {
            itemArray = try context.fetch(request)
            
        }catch {

            print("Did not fetch data\(error)")
        }

        }

    }
// Mark:- Search controller delegates

extension MyTodoViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@ ", searchBar.text!)
        request.predicate = predicate
        
        let sortDis = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDis]
        
        
        
        
        do {
            itemArray = try context.fetch(request)
            
        }catch {
            
            print("Did not fetch data\(error)")
        }
        tableView.reloadData()

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}


