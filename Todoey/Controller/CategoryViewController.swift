//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Деним Мержан on 15.03.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArr = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext /// В Aple Delegate есть так называем контекст - временная зона в которой мы можем редактировать данные и после этого добавить контекст в контейнер базы данных через эту строчку мы хотим получить ссылку на контекст для взаимодействия с постоянным контейнером
    
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
            
            let newCategory = Category(context: self.context)  /// Инициализирует подкласс управляемого объекта и вставляет его в указанный контекст управляемого объекта.

            newCategory.name = textField.text!
            self.categoryArr.append(newCategory) /// Добавляем в наш массив новый элемент
            self.saveData()
        }
        
        alert.addAction(action) /// Добавляем в наше оповещение действие
        
        present(alert, animated: true) /// Презентуем наше оповещение с текстовым полем и действием, наше текствое поле это UIAlertController поэтому нужна презентация как нового view controllerв
    }
    
}


    // MARK: - Создание ячеек
    
    extension CategoryViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArr[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

//MARK: -  Работа с данными

extension CategoryViewController {
    
    func saveData(){
        do {
            try context.save()
        }catch{
            print("Ошибка сохранения категорий - \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(){
        
        let request : NSFetchRequest<Category> = Category.fetchRequest() /// Создаем новый запрос на получение всех элементов из контейнера Category
        
        do{
            categoryArr =  try context.fetch(request)
        }catch{
            print("Ошибка получения данных категорий - \(error)")
        }
        tableView.reloadData()
    }
    
}
