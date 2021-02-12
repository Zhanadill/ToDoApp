//
//  ViewController.swift
//  toDoApp
//
//  Created by Жанадил on 2/11/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import UIKit
import RealmSwift

class ItemViewController: UITableViewController {
    var arr: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory:Category?{
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    //MARK: loadItems()
    func loadItems(){
        arr = selectedCategory?.items.sorted(byKeyPath: "date", ascending: false)
        tableView.reloadData()
    }
    
    
    
    //MARK: addButtonPressed()
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "ADD", style: .default){ (action) in
            do{
                try self.realm.write{
                    let newItem = Item()
                    newItem.text = textField.text!
                    newItem.date = Date()
                    self.selectedCategory?.items.append(newItem)
                }
            }catch{
                print("error in adding new item \(error)")
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}



//MARK: UISearchBar Delegate
extension ItemViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        arr = arr?.filter("text CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: false)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
        }
    }
}



//MARK: TableView Methods
extension ItemViewController{
      //DataSource methods
      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return arr?.count ?? 1
      }
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
          cell.textLabel?.text = arr?[indexPath.row].text ?? "No items"
          if let k = arr?[indexPath.row].done{
              cell.accessoryType = k ? .checkmark : .none
          }
          return cell
      }
      
      
      
      //delegate methods
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          if let item = arr?[indexPath.row]{
              do{
                  try realm.write{
                      item.done = !item.done
                  }
              }catch{
                  print("error saving done status \(error)")
              }
          }
          tableView.deselectRow(at: indexPath, animated: true)
          tableView.reloadData()
      }
}
