//
//  ViewController.swift
//  MyTodoList
//
//  Created by Apple on 5/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RealmSwift

class MyTodoViewController: UITableViewController {
    
    
    var  todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
    didSet{
      loadItems()
    }
    }
    
    //print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    
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
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mytodo", for: indexPath)
        
    //    cell.textLabel?.text = itemArray[indexPath.row].title
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ?.checkmark : .none
        }else {
            cell.textLabel?.text = "No Items Added"
        }

        
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row]
        {
            do{
                try realm.write {
                item.done = !item.done
                }
                
            }catch {
                print("Error while saving \(error)")
            }
           

        }
         tableView.reloadData()
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//
//
//      //  itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)

    }

    //Mark :- My Add Items Button
    
    @IBAction func addItems(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Items to MyTodoList", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Items", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                         let newItem = Item()
                         newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                    
                }catch{
                    print("Error saving new items \(error)")
                }
                self.tableView.reloadData()
            }
//
//            newItem.done = false
//
//            newItem.parentCategory = self.selectedCategory
//
//
//            self.itemArray.append(newItem)
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Todo"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true,completion:nil )
    }
    
 

    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
//        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        request.predicate = predicate
//
//        do {
//            itemArray = try context.fetch(request)
//
//        }catch {
//
//            print("Did not fetch data\(error)")
//        }

        }

    }
// Mark:- Search controller delegates

extension MyTodoViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@ ", searchBar.text!)
//        request.predicate = predicate
//
//        let sortDis = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDis]
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "title", ascending: true)




//        do {
//            itemArray = try context.fetch(request)
//
//        }catch {
//
//            print("Did not fetch data\(error)")
//        }
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


