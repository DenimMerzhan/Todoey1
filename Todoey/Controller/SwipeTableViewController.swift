//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Деним Мержан on 20.03.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        
        guard orientation == .right else { return nil } /// Если мы прокручиваем справа от ячейки

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { SwipeAction, IndexPath in
            
            self.updateModel(at: indexPath) /// Вызываем функцию для обновления данных
            

        }
        deleteAction.image = UIImage(named: "delete")
        
        let changeAction = SwipeAction(style: .default, title: "Change") { SwipeAction, IndexPath in
            self.changeText(indexPath: indexPath)
        }
        changeAction.image = UIImage(named: "arrow.clockwise")
        
        return [deleteAction,changeAction]
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
     func updateModel(at indexPath: IndexPath){
        
    }
    
    func changeText(indexPath: IndexPath) {
        
    }


}

 
