//
//  RootViewController.swift
//  toDoApp
//
//  Created by Жанадил on 2/12/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import UIKit
import SwipeCellKit

class RootViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    
    
    //MARK: SwipeTableViewCellDelegate Methods
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
           guard orientation == .right else { return nil }

           let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
               self.updateModel(at: indexPath)
           }

           // customize the action appearance
           deleteAction.image = UIImage(systemName: "star")

           return [deleteAction]
       }
       
       func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
           var options = SwipeOptions()
           options.expansionStyle = .destructive
           options.transitionStyle = .border
           return options
       }
       
       func updateModel(at indexPath: IndexPath){
           print("Item deleted")
       }
}


