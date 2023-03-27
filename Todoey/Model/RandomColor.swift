//
//  RandomColor.swift
//  Todoey
//
//  Created by Деним Мержан on 21.03.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import ChameleonFramework

struct ColorWork {
    
    func contrastColor(color: UIColor) -> Bool {  /// Те цвета на которых функция контрастного цвета работает плохо и мы их исключаем из контрастного цвета
        let colorArr = [UIColor.flatPink(),FlatGreen(),UIColor.flatSand()]
        if colorArr.contains(color) {
            print("Yeah")
            return true
        }else {
            return false
        }
    }
    
    func refreshColor(colorIndex: Int) -> UIColor?{
        let arr = [UIColor.flatRed(),UIColor.flatOrange(),UIColor.flatYellow(),UIColor.flatSand(),UIColor.flatSkyBlue(),UIColor.flatForestGreen(),UIColor.flatBlue(),UIColor.flatCoffee(),UIColor.flatPink(),FlatWatermelon(),FlatMagenta(),FlatGreen(),FlatPurple()]
        if colorIndex > arr.count - 1 {
            print(colorIndex)
            return nil
        }else{
            print(colorIndex)
            return arr[colorIndex]}
    }
}
