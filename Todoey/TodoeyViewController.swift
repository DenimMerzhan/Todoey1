//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoeyViewController: UITableViewController {
    
    var itemArray = [String]()
    let defaults = UserDefaults.standard /// Создаем хранилище для данных пользователя, обрашаться к хранилищу будем через defaults
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barStyle = UIBarStyle.black
        navigationBar?.backgroundColor = UIColor(named: "UserColor")
    
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "TodoApp") as? [String] {  /// Если в хранилище есть элемент с ключом TodoApp то обновляем наш массив
            itemArray = items
        }
    }
    
    
    
//MARK: - кнопка + Нажата
    
    @IBAction func plusButtonPressed(_ sender: UIBarButtonItem) {
        
        var text = UITextField()
        let alert = UIAlertController(title: "Добавить новую задачу", message: "", preferredStyle: .alert) /// Создаем новый VIew controller с надписью
        
        alert.addTextField { UITextField in  /// Добавляем к предупреждению текстовое поле и передаем UITextFielld в качестве значения в замыкание
            UITextField.placeholder = "Создать новый объект"
            text = UITextField
        }
        
        let action = UIAlertAction(title: "Добавить", style: .default) { (action) in /// Создаем действие которыое случится после того как пользователь нажмет кнопку добавить
            print(text.text!)
            if text.text != ""{
                self.itemArray.append(text.text!)
                self.tableView.reloadData() 
                self.defaults.set(self.itemArray, forKey: "TodoApp") /// Добавляем в наше хранилище элемент item array т.к хранилище это слоаврь нужен еще и ключе TodoApp
                
            }
        }
        
        alert.addAction(action) /// Вызываем действие
        present(alert, animated: true, completion: nil) /// Презентуем новый View Controller
        

    }
    


}
// MARK: - Создание ячеек

extension TodoeyViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) /// Указываем индефиактор и индекс по умолчанию
        cell.textLabel?.text = itemArray[indexPath.row] /// Берем номер строки для новой ячейки и выбираем из массива такой же индекс для того что бы записать текст из массива в новую ячейку
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark   {
            cell?.accessoryType = .none
        }else{
            cell?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



