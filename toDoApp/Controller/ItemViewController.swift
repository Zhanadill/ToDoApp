//
//  ViewController.swift
//  toDoApp
//
//  Created by Жанадил on 2/11/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import UIKit
import RealmSwift

class ItemViewController: RootViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var arr: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory:Category?{
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.rowHeight = 70.0
        tableView.backgroundColor = UIColor(hexString: selectedCategory?.color)
        tableView.alwaysBounceVertical = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let color = UIColor(hexString: selectedCategory?.color){
            navigationController?.navigationBar.backgroundColor = color
            navigationController?.navigationBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)!]
            searchBar.barTintColor = color.lighten(byPercentage: 0.05)
            searchBar.searchTextField.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
        }
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
    
    
    
    //MARK: deleteCell
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        do{
            try realm.write{
                if let k = arr?[indexPath.row]{
                    realm.delete(k)
                }
            }
        }catch{
            print("error in deleting item")
        }
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = arr?[indexPath.row].text ?? "No items"
        if let color = UIColor(hexString: selectedCategory?.color).darken(byPercentage: CGFloat(indexPath.row)/CGFloat(arr!.count)){
            cell.backgroundColor = color
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
        }
        
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
