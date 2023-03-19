//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Деним Мержан on 15.03.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categoryArr: Results<Category>? /// Results это тип данных как Масиисв или строка, только со своими особенностями
    ///Результаты всегда отражают текущее состояние Realm в текущем потоке, в том числе во время транзакций записи в текущем потоке.
    ///Этот контейнер автоматически обнавляется если что то изменяется
    
    override func viewWillAppear(_ animated: Bool) {
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barStyle = UIBarStyle.black
        navigationBar?.backgroundColor = UIColor.systemMint
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadData()
        
    }
    
// MARK: - Добавление нового предмета
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Добавить новую каттегорию", message: "", preferredStyle: .alert) /// Создаем оповещение
        
        alert.addTextField { UITextField in  /// Создаем текстовое поле
            textField = UITextField
            print("Yeah")
        }
        
        let action = UIAlertAction(title: "Добавить", style: .default) { UIAlertAction in /// Создаем действие после нажатия на кнопку добавить
            
            let newCategory = Category()

            newCategory.name = textField.text!
            self.saveData(category: newCategory)
        }
        
        alert.addAction(action) /// Добавляем в наше оповещение действие
        
        present(alert, animated: true) /// Презентуем наше оповещение с текстовым полем и действием, наше текствое поле это UIAlertController поэтому нужна презентация как нового view controllerв
    }
    
}


    // MARK: - Создание ячеек и их выбор
    
    extension CategoryViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr?.count ?? 1 /// Если не nill то воозвращаем count если nill то возвращаем 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArr?[indexPath.row].name ?? "Нет категорий"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categoryArr?[indexPath.row].name != "Нет категорий" && categoryArr?[indexPath.row].name != nil {
            performSegue(withIdentifier: "goToItems", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)

    }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            let destination = segue.destination as! TodoeyViewController /// Если новый View Controller можно понизить до TodoViewController то записываем TodoViewController в destination если нет выходим из функции
            if let index = tableView.indexPathForSelectedRow {
                destination.selectedCategory = categoryArr?[index.row]
            }
          
        }
        

}

//MARK: -  Работа с данными

extension CategoryViewController {
    
    func saveData(category: Category){
        do {
            try realm.write({
                realm.add(category)
            })
        }catch{
            print("Ошибка сохранения категорий - \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(){
        
        categoryArr = realm.objects(Category.self) /// Вернуть все типы данного типа, хранящиеся в области
        
        tableView.reloadData()
    }
    
}
