//
//  ViewController.swift
//  toDoApp
//
//  Created by Жанадил on 2/11/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UITableViewController {
    var arr: Results<Item>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //MARK: loadItems()
    func loadItems(){
        arr = (realm.objects(Item.self)).sorted(byKeyPath:"date", ascending: false)
        tableView.reloadData()
    }
    
    
    //MARK: -TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aaa", for: indexPath)
        cell.textLabel?.text = arr?[indexPath.row].text ?? "No categories"
        cell.accessoryType = arr![indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    
    
    //MARK: -TableView Delegate Methods
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
    
    //MARK: addButtonPressed()
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "ADD", style: .default){ (action) in
            let newItem = Item()
            newItem.text = textField.text!
            newItem.date = Date()
            self.save(item: newItem)
            self.tableView.reloadData()
        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: save()
    func save(item: Item){
        do{
            try realm.write{
                realm.add(item)
            }
        }catch{
            print("error in storing")
        }
        tableView.reloadData()
    }
}


extension ViewController: UISearchBarDelegate {
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
