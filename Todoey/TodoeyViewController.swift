//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoeyViewController: UITableViewController {
    
    let itemArray = ["Почистить кеды", "Купить молоко", "Пропылесосить"]
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barStyle = UIBarStyle.black
        navigationBar?.backgroundColor = .blue
    
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view. 
    }


}


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
    }
}
