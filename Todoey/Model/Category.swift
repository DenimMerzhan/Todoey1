//
//  Category.swift
//  Todoey
//
//  Created by Деним Мержан on 17.03.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""  /// Dynamic значит что мы можем отслеживать изменения этой переменной во время работы приложения
    @objc dynamic var count: String = "0"
    @objc dynamic var color: Int = 0
    
    let items = List<Item>() /// Мы объявлем LIst   с предметами Item это равносильно let array: arr<Int> () равносильно array: [Int]() т.е item это тип данных а Лист это их структура. Каждый элемент Category может иметь свой Items который равен List(Списку) Item   
}
