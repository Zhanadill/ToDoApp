//
//  CategoryViewController.swift
//  toDoApp
//
//  Created by Жанадил on 2/12/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: RootViewController {
    var categoryArr: Results<Category>?
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
        loadCategories()
    }
    
    
    
    //MARK: loadItems()
       func loadCategories(){
           categoryArr = (realm.objects(Category.self))
           tableView.reloadData()
       }
    
    
    
    //MARK: addButtonPressed()
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
               let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
               let action = UIAlertAction(title: "ADD", style: .default){ (action) in
                   let newCategory = Category()
                   newCategory.name = textField.text!
                   self.save(category: newCategory)
                   self.tableView.reloadData()
               }
               alert.addTextField{ (alertTextField) in
                   alertTextField.placeholder = "create new category"
                   textField = alertTextField
               }
               alert.addAction(action)
               present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: save()
    func save(category: Category){
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("error in storing category")
        }
        tableView.reloadData()
    }
    
    //MARK: deleteCell
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        do{
            try realm.write{
                if let k = categoryArr?[indexPath.row]{
                    realm.delete(k)
                }
            }
        }catch{
            print("error in deleting category")
        }
    }
}



//MARK: TableView Methods
extension CategoryViewController {
       //DataSource methods
       override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return categoryArr?.count ?? 1
       }
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
         UITableViewCell {
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            cell.textLabel?.text = categoryArr?[indexPath.row].name ?? "No Categories"
            return cell
       }
       
     
       
       //Delegate methods
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           performSegue(withIdentifier: "segue1", sender: self)
       }
     
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if let selectedVC = segue.destination as? ItemViewController{
             if let indexpath = tableView.indexPathForSelectedRow{
                 if let k=categoryArr?[indexpath.row]{
                     selectedVC.selectedCategory = k
                 }
             }
          }
       }
}
