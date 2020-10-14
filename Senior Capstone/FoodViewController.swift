//
//  Food2ViewController.swift
//  Senior Capstone
//
//  Created by Madison Lucas on 9/5/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FoodViewController: UIViewController, UITableViewDelegate {
    
    // gives us a reference to the table
    @IBOutlet weak var tableView: UITableView!
    
    // the persistant container belongs to the appDelegate class
    // appDelegate acts as a singleton, which means there is only once instance
    // of the appDelegate all screens share (basically its a static class)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate;

    // each cell will hold a different entry that conforms to the FoodItem entity
    var foodRecords = [FoodRecord]()

    // every time we switch between screens and come back, we want to reload the data
    // because we might update the date or something
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        title = "Today's Food"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        loadSavedData()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }

    func loadSavedData() {
        
        let predicate = NSPredicate(format: "date == %@", DailyState.todaysDate)
       
        foodRecords = DatabaseFunctions.retriveFoodRecordOnCondition(predicate: predicate)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath : IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
}

// there are all just mandatory things I needed to override to get the table to work
extension FoodViewController: UITableViewDataSource {

    // saying the number of rows is equal to the number of foodItems returned
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return foodRecords.count
    }

    // saying that you can modify the table
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // saying that I want to display the name in each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let foodRecord = foodRecords[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = foodRecord.value(forKeyPath: "name") as? String
            
            return cell
    }

    // saying that if the user deletes (i.e. swipeing a row to the left), heres how you do it
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // pull out the item the user swiped left on
            let item = foodRecords[indexPath.row]
            DatabaseFunctions.deleteFoodRecord(foodItem: item)
            foodRecords.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
