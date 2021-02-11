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
   
    var arr = [Item]()
    //var arr: Results<Item>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadItems()
        // Do any additional setup after loading the view.
    }
    /*func loadItems(){
        arr = realm.objects(Item.self)
        tableView.reloadData()
    }*/
    
    
    //MARK: -TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aaa", for: indexPath)
        cell.textLabel?.text = arr[indexPath.row].text
        cell.accessoryType = arr[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    
    
    //MARK: -TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        arr[indexPath.row].done = !arr[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "ADD", style: .default){ (action) in
            //let newItem = Item(text: textField.text!, date: Date())
            //let newItem = Item(text: textField.text!, date: Date())
            let newItem = Item()
            newItem.text = textField.text!
            self.arr.append(newItem)
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

