//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Деним Мержан on 15.03.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {

    var categoryArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryArr.append("Помыть голову")

    }
    
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return categoryArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }



}
