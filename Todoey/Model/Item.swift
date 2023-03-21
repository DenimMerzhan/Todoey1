//
//  Itme.swift
//  Todoey
//
//  Created by Деним Мержан on 17.03.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object { /// Создав класс класса Object  мы можем сохранять данные используя Realm
   @objc dynamic var title: String = "Нет категорий"
   @objc dynamic var done: Bool = false
   @objc dynamic var dateCreated: Date?
   @objc dynamic var color: String?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") /// Мы указываем обратную связь которая связывает каждый элемент обратно с родительской категорий  и мы говорим что категория будет Category и указываем имя свойства обратного отношения
}
