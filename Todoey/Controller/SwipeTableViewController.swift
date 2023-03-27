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
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? { /// В тот момент когда пользователь свайпнул по ячейке
        
        guard orientation == .right else { return nil } /// Если мы прокручиваем справа от ячейки

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { SwipeAction, IndexPath in
            
            self.updateModel(at: indexPath) /// Вызываем функцию для обновления данных

        }
        deleteAction.image = UIImage(named: "delete")
        
        let changeAction = SwipeAction(style: .default, title: "Change") { SwipeAction, IndexPath in
            self.creatAlert(indexPath: indexPath) /// Вызываем функцию для изменения текста в ячейке
        }
        changeAction.image = UIImage(systemName: "pencil")
        
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
    
    func changeText(indexPath: IndexPath, text: String){
        
    }
    
    func nameTitle(at indexPath: IndexPath) -> String { /// Возвращаем то что было написано в ячейке в предупрждение для редактирования
        
        return ""
    }
    
    func creatAlert(indexPath: IndexPath) { /// Создаем предупреждение для редактирования ячейки
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Изменить текующую категорию", message: "", preferredStyle: .alert) /// Создаем оповещение
        
        alert.addTextField { UITextField in  /// Создаем текстовое поле
            UITextField.text = self.nameTitle(at: indexPath)
            textField = UITextField
        }
        
        let action = UIAlertAction(title: "Изменить", style: .default) { UIAlertAction in /// Создаем действие после нажатия на кнопку добавить
            
            if textField.text != "" {
                self.changeText(indexPath: indexPath, text: textField.text!)
            }
        }
        
        alert.addAction(action) /// Добавляем в наше оповещение действие
        
        present(alert, animated: true) /// Презентуем наше оповещение с текстовым полем и действием, наше текствое поле это UIAlertController поэтому нужна презентация как нового view controllerв
        
    }


}

 
