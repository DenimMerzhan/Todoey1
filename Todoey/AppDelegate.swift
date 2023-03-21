//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "nil")
        
//        let config = Realm.Configuration(schemaVersion: 3)
//        Realm.Configuration.defaultConfiguration = config
        
        let realm = try! Realm()
        

        
        return true
    }



    func applicationWillTerminate(_ application: UIApplication) { /// Приложение закрыто
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        saveContext()
    }
    
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {  /// В NSpersistentContanier мы собираемся хранить все данные
        
        let container = NSPersistentContainer(name: "DataModel") /// Создали контенер коорый равняется нашей базе Data Model
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in /// Загружаем контейнер
            if let error = error as NSError? { /// Если была ошибка то выдать ошибку

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container  /// Возвращаем контейнер
    }()

    // MARK: - Core Data Saving support

    func saveContext () {  /// Сохраняет данные перед выходим пз приложения
        let context = persistentContainer.viewContext /// Переменная которая является промежуточным этапам между введенными данными и сохранением их в базу данных
        if context.hasChanges {
            do {
                try context.save()  /// Пытаемся сохранить данные в нашей базе DataModel
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

