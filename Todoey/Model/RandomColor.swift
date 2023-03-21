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
    
    func randomColor() -> String {
        let random = Int.random(in: 1..<4)
        
        print(random)
        switch random {
        case 1: return UIColor.flatPowderBlue().hexValue()
        case 2: return UIColor.flatWhite().hexValue()
        default: return UIColor.flatBlue().hexValue()
            
        }
    
    }
    
    func refreshColor(colorIndex: Int) -> UIColor?{
        let arr = [UIColor.flatRed(),UIColor.flatOrange(),UIColor.flatYellow(),UIColor.flatSand(),UIColor.flatSkyBlue(),UIColor.flatForestGreen(),UIColor.flatBlue(),UIColor.flatCoffee(),UIColor.flatPink(),FlatWatermelon(),FlatMagenta(),FlatGreen(),FlatPurple()]
        if colorIndex > arr.count - 1 {
            return nil
        }else{return arr[colorIndex]}
    }
}
