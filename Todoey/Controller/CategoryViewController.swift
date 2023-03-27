//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Деним Мержан on 15.03.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let defaults = UserDefaults.standard
    var rect = CGRectMake(0.0, 0.0, 250.0, 700.0)
    let color =  ColorWork()
    
    var colorIndex: Int = 0 {
        didSet {
            refreshColor()
        }
    }
    
    var viewColor = UIColor.flatSand()!
     let realm = try! Realm() /// Иницилизируем новую точку доступа к нашей базе данных Realm
    var categoryArr: Results<Category>? /// Results это тип данных как Масиисв или строка, только со своими особенностями
    ///Результаты всегда отражают текущее состояние Realm в текущем потоке, в том числе во время транзакций записи в текущем потоке.
    ///Этот контейнер автоматически обнавляется если что то изменяется
    
    override func viewWillAppear(_ animated: Bool) {
        

        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barStyle = UIBarStyle.default
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        view.backgroundColor = UIColor(gradientStyle:.topToBottom, withFrame:rect, andColors:[viewColor,UIColor.white])
        
        navigationBar?.shadowImage = UIImage()
        navigationBar?.isTranslucent = true
        
        navigationBar?.tintColor = UIColor.black
        
        
        if #available(iOS 11.0, *){
            navigationBar?.prefersLargeTitles = true /// Делаем большой заголовок Nav Bar
        }
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        colorIndex = defaults.integer(forKey: "ColorIndex")
        
        tableView.separatorStyle = .none
        loadData()
    }
    
    
    
//MARK: -  Удаление данных
    
    
    
    override func updateModel(at indexPath: IndexPath) { /// Переопределяем нашу функцию из SwipeVC для обновления данных
        
        if let deleteCategory = categoryArr?[indexPath.row] {
            do {try realm.write {
                realm.delete(deleteCategory.items)
                realm.delete(deleteCategory)
            }
            }catch{}
        }
        
    }
    
    
    
    override func changeText(indexPath: IndexPath,text: String) { /// Переопределяем нашу функцию из SwipeVC для обновления данных
        if let changeCategory = categoryArr?[indexPath.row] {
            do {try realm.write {
                changeCategory.name = text
            }
            }catch{}
            tableView.reloadData()
        }
    }
    
    override func nameTitle(at indexPath: IndexPath) -> String {
        return categoryArr?[indexPath.row].name ?? ""
    }
 
    
    
//MARK: - Обновление цвета
    
    
    @IBAction func refreshColor(_ sender: UIBarButtonItem) {
        colorIndex += 1
        defaults.set(colorIndex, forKey: "ColorIndex") /// Сохраняем значение
        
    }
    
    
    
// MARK: - Добавление нового предмета
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Добавить новую каттегорию", message: "", preferredStyle: .alert) /// Создаем оповещение
        
        alert.addTextField { UITextField in  /// Создаем текстовое поле
            textField = UITextField
        }
        
        let action = UIAlertAction(title: "Добавить", style: .default) { UIAlertAction in /// Создаем действие после нажатия на кнопку добавить
            
            if textField.text != "" {
                
                let newCategory = Category()
                newCategory.name = textField.text!
                self.saveData(category: newCategory)
            }
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
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) /// Говорим что новая ячейка будет равна ячейке из супер класса которая уже имеет методы swipwe
        
        cell.textLabel?.text = categoryArr?[indexPath.row].name ?? "Нет категорий"
        cell.detailTextLabel?.text = categoryArr?[indexPath.row].count ?? "0"
        tableView.rowHeight = 70 /// Устанавливаем единый размер для ячеек
        
        let newColor = viewColor.darken(byPercentage: 0.05 * CGFloat(indexPath.row)) /// Делаем цвет чуть темнее чем ViewColor
        cell.backgroundColor = newColor?.withAlphaComponent(CGFloat(indexPath.row + 1)/10) /// Делаем следущюю ячейку менее прозрачной

        if color.contrastColor(color: viewColor) == false { /// Если бэкраунд относится к цветам на которых хорошо срабатывает функция контраста
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:cell.backgroundColor!, isFlat:true)
        }else if viewColor == UIColor.flatSand() { /// Если пустынный то ставим черный цвет текста т.к на нем он хорошо выглядит
            cell.textLabel?.textColor = .black
        }
        

        
        return cell
    }

        
        
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if categoryArr?[indexPath.row].name != "Нет категорий" {
            performSegue(withIdentifier: "goToItems", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)

    }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            let destination = segue.destination as! TodoeyViewController
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

//MARK: - Обновление цвета

extension CategoryViewController {
    
    func refreshColor(){
     
        if let newColor = color.refreshColor(colorIndex: colorIndex) { /// Обращаемся к функции для получения следующего цвета
            viewColor = newColor
            navigationController?.navigationBar.backgroundColor = newColor.lighten(byPercentage: 0.1).withAlphaComponent(0.02) /// Меняем цвет бэека у NavBAr
            view.backgroundColor = UIColor(gradientStyle:.topToBottom, withFrame:rect, andColors:[viewColor,UIColor.white]) /// Меняем цвет бэека у VC
           
            
            tableView.reloadData()
            
        }else {
            colorIndex  = 0
        }
        
    }
}

