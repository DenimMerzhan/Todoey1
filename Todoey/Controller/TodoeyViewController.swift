//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoeyViewController: UITableViewController {
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext /// в 1-х скобках () мы подключаемся к AppleDelegate как к объекту вместо того что бы его инициализировать например let appDelegate = AppDelegate (init ...) Далее мы взяли свойство context и приравняли к переменной
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barStyle = UIBarStyle.black
        navigationBar?.backgroundColor = UIColor.systemMint
    
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()/// Загружаем данные который ввел пользователь из базы данных
        searchBar.delegate = self
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
                
                let newItem = Item(context: self.context) /// объявляем новый контекст (промежуточная точка перед записью в базу данных Item)
                newItem.title = text.text! /// Записываем в заголовок данные от пользователя
                newItem.done = false
                self.itemArray.append(newItem) /// Добавляем новый элемент в  массив
                self.saveData() /// Добавляем наш контектст в базу данных Item
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
        
        let item = itemArray[indexPath.row]
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//        saveData()
        
        if item.done  {  /// Если значение done = true т.е пользотватель уже поставил галочку то меняем на false
            item.done = false
        }else{
            item.done = true
        }
        saveData()
        

        tableView.deselectRow(at: indexPath, animated: true) /// Убирает серое поле с выбраного элемента пользователем
    }
}


//MARK: - Функция сохранение данных и их чтение

extension TodoeyViewController {
    
    func saveData() {
        
        do{
            try context.save() /// Сохраняем данные в основном контейнере Item
        }catch{
            print("Ошибка сохранения данных - \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest()){ /// Функция для загрузки данных из файла, если при вызове функии не указать значение request то значение будет по умолчанию = Item.fetchRequest()
    /// with это внешний параметр, нужен для простоты читаабельности кода и что бы код имел больший смысл на английском языке
    /// NSFetchRequest<Item> - это строка нужна для указания тип данных которые мы извлекаем тоже самое как let text: String = " Hello World" . Fetch request - запрос на получение
        
        do {
            itemArray = try context.fetch(request) /// Возвращает массив элементов указанного типа, соответствующих критериям запроса на выборку
        } catch{
            print("Ошибка получения данных - \(error )")
        }
        tableView.reloadData()
    }
    
    
}
    
    
    
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
                let request: NSFetchRequest<Item> = Item.fetchRequest()
                request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) /// Для всех элементов Item надо найти тот элемент чей заголовок начинаеся с searchBat.text  [cd] -  отключает чувствительность к регистру (т.е hello  = Hello) и диакритическим знакам
                
                let sortDescriptor = NSSortDescriptor(key: "title", ascending: true) /// Создаем сортировку по заголовку, assning -  "восходящий" ставим true
                var arrDescriptor = [NSSortDescriptor]()
                arrDescriptor.append(sortDescriptor)
                request.sortDescriptors = arrDescriptor  /// Добавляем в запрос нашу сортировку, т.к он ожидает архив мы передаем архив
                
                loadItem(with: request)
            }
        }
        
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }

