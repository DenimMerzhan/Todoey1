//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoeyViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("Item.plist") /// Создаем файл в катологе документы на телефоне
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barStyle = UIBarStyle.black
        navigationBar?.backgroundColor = UIColor.systemMint
    
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItem() /// Загружаем данные который ввел пользователь из файла по URL dataFielPath
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
            
            if text.text != ""{
                self.itemArray.append(Item(title: text.text!, done: false)) /// Если пользователь что то ввел то добавляем новый элемент в массив
                self.saveData(itemArray: self.itemArray) /// Перезаписываем все данные на новый массив
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
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title /// Берем номер строки для новой ячейки и выбираем из массива такой же индекс для того что бы записать текст из массива в новую ячейку
        
        cell.accessoryType = item.done ? .checkmark: .none /// Если значение done = true т.е пользотватель уже поставил галочку то убираем, если false то добавляем

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        let item = itemArray[indexPath.row]
        
        if item.done  {  /// Если значение done = true т.е пользотватель уже поставил галочку то меняем на false
            item.done = false
            saveData(itemArray: itemArray)
        }else{
            item.done = true
            saveData(itemArray: itemArray)
        }
        

        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - Функция сохранение данных и их чтение

extension TodoeyViewController {
    
    func saveData(itemArray: [Item]) {
        
        let encoder = PropertyListEncoder()  /// Объект, который кодирует экземпляры типов данных в список свойств
        
        do{
            let data = try encoder.encode(itemArray)  /// Кодирование нашего массива эелементов Item в формат plist
            try data.write(to: dataFilePath!)   /// Попытка записать данные в наш файл
            tableView.reloadData()
        }catch{
            print("Ошибка раскодировки данных, \(error)")
        }
        
        
    }
    
    func loadItem(){ /// Функция для загрузки данных из файла

        if let data = try? Data(contentsOf: dataFilePath!){ /// Пытаемся открыть файл по указанному URL и записываем в data
            let decoder = PropertyListDecoder() /// Создаем декодер
            do{
                itemArray = try decoder.decode([Item].self, from: data) /// Пытаем декодировать документ в тип [Item]
            }catch {print("Ошибка при декодировании - \(error)")}
        }
    }
}



