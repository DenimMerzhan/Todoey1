//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
 
class TodoeyViewController: UITableViewController {
    
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{  ///  Как только для переменной Category будет установленно значение все что внутри этих скобок выполнится
//            loadItem()
        }
    }
    
    var itemContainer: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barStyle = UIBarStyle.black
        navigationBar?.backgroundColor = UIColor.systemMint
    
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        searchBar.delegate = self
        loadItem()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if let  currentCategorry = selectedCategory {
            print(itemContainer?.count ?? 0)
            do {
                try realm.write {
                    currentCategorry.count = String(itemContainer?.count ?? 0)
                }
            }catch { print("Ошибка добавления count - \(error)")}
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
            


            if text.text != ""{
                
                if let currentCategory = self.selectedCategory {
                    do { try self.realm.write {
                        
                        let newItem = Item() /// объявляем новый контекст (промежуточная точка перед записью в базу данных Item)
                        newItem.title = text.text! /// Записываем в заголовок данные от пользователя
                        currentCategory.items.append(newItem) /// Добавляет указанный объект в конец списка. Добавляем наш item в List
                        newItem.dateCreated = Date()
                    }
                    }catch{
                        print("Ошибка сохранения данных - \(error)")
                    }
                    self.tableView.reloadData()
                }
            }
            
        }
        
        alert.addAction(action) /// Вызываем действие
        present(alert, animated: true, completion: nil) /// Презентуем новый View Controller
        

    }
    


}
// MARK: - Создание ячеек

extension TodoeyViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemContainer?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) /// Указываем индефиактор и индекс по умолчанию

        let item = itemContainer?[indexPath.row] ?? Item() /// Если в массиве itemArray данный элемент = nill то значение по умолчанию будет Item где title = Нет категорий а done = false по умолчанию
        cell.textLabel?.text = item.title

        
        cell.accessoryType = item.done ? .checkmark : .none /// Если done true то ставим checmark если false то none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = itemContainer?[indexPath.row] {
            
            do {
                try realm.write ({
                    
                    if item.done  {  /// Если значение done = true т.е пользотватель уже поставил галочку то меняем на false
                        item.done = false
                    }else{
                        item.done = true
                    }
                    
                })
            }catch{}

        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true) /// Убирает серое поле с выбраного элемента пользователем
    }
}


//MARK: - Функция сохранение данных и их чтение

extension TodoeyViewController {

    func saveData(newItem: Item) {

        do{
            try realm.write({
                realm.add(newItem)
            }) /// Сохраняем данные в основном контейнере Item
        }catch{
            print("Ошибка сохранения данных - \(error)")
        }

        tableView.reloadData()

    }

    
    
    func loadItem(){


        itemContainer = selectedCategory?.items.sorted(byKeyPath: "dateCreated",ascending: false )/// Все элементы принадлежащие к выбранной категории
        ///Возвращает результаты, содержащие объекты в коллекции, но отсортированные.
        
        tableView.reloadData()
    }


}


//MARK: - Search Bar  и фильтрация данных


    extension TodoeyViewController: UISearchBarDelegate {

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { /// Когда нажата кнопка return в панеле поиска

        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

            if searchBar.text == "" { /// Если поле пустое, то вызываем загрузку элементов с запросом по умолчанию который вытаскивает все элементы = Item из базы данных
                loadItem()

                DispatchQueue.main.async { /// На загрузку LoadItem нужно время, и пока он загружается клавиатура не исчезнет и Search Bar не откажается от своего статуса первоответчика, поэтому мы заставляем его работать парал ельно с загрузкой элементов т.е он сразу сработает
                    searchBar.resignFirstResponder() /// Уведомляет этот объект о том, что его попросили отказаться от статуса первого ответившего в его окне.
                }
            }else{
                
                itemContainer = itemContainer?.filter("title CONTAINS[cd] %@", searchBar.text!)
                .sorted(byKeyPath: "dateCreated", ascending:true) /// cd - значит не чувствительны к регистру и диакретическому знаку. Фильтр означает что в заголовке содержится то что в searchBar.text и мы получаем все заголовки где это содержится
                
                tableView.reloadData()

            }
        }

    }

