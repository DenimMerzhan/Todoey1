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
    @objc dynamic var name: String = ""
    
    
    let items = List<Item>() /// Мы объявлем LIst   с предметами Item это равносильно let array: arr<Int> () равносильно array: [Int]() т.е item это тип данных а Лист это их структура
}
