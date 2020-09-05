//
//  FoodViewController.swift
//  Senior Capstone
//
//  Created by Madison Lucas on 9/2/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import UIKit
import CoreData

class FoodViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var foodItems: [NSManagedObject] = []

    @IBAction func addName(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Food Item",
                                      message: "Add a new food item",
                                      preferredStyle: .alert)

        alert.addTextField { (name) in
            name.text = ""
            name.placeholder = "Name"
        }

        alert.addTextField { (group) in
            group.text = ""
            group.placeholder = "Group"
        }

        alert.addTextField { (calories) in
            calories.text = ""
            calories.placeholder = "Calories"
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in

            guard let nameField = alert.textFields?[0],
                let nameToSave = nameField.text else {
                    return
            }

            guard let groupField = alert.textFields?[1],
                let groupToSave = groupField.text else {
                    return
            }

            guard let caloriesField = alert.textFields?[2],
                let caloriesToSave = caloriesField.text else {
                    return
            }

            self.save(name: nameToSave, group: groupToSave, calories: caloriesToSave)
            self.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }

    func save(name: String, group: String, calories: String) {
        do {

            if let intCalories = Int(calories) {
                let NSCalories = NSNumber(value:intCalories)

            /* CoreDataHelper.insertCoreData should throw an a CoreDataHelper.MyError.insertionError if there is a problem, so I am going to go ahead and force unwrap the NSManagedObject? to NSManagedObject (with the bang symbol: !). It shouldn't ever try to unwrap it if there is a problem beacuse the error should be thrown instead. Low-key haven't tested it fully so I hope it doesn't crash the app :/e
             */
                try foodItems.append(CoreDataHelper.insertCoreData(entityName: "FoodItem", attributeValues: [name, group, NSCalories, DailyState.todaysDate], attributeNames: ["name", "group", "calories", "date"])!)
            } else {
                print("Invalid Calories input. Data not saved.")
            }
        } catch CoreDataHelper.CoreDataError.insertionError {
            print("There was an error inserting into Core Data. Data not saved.")
        } catch {
            print("You tried to insert something, but something went really wrong :( Data not saved.")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.

        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        do {
            /* Also forcing unwrap here, cause the try should go to error */
            foodItems = try CoreDataHelper.fetchCoreData(entityName: "FoodItem", predicate: NSPredicate(format: "date == %@", DailyState.todaysDate))!
            tableView.reloadData()
        } catch CoreDataHelper.CoreDataError.fetchError {
            print("There was an error fetching Core Data. Data not reloaded")
        } catch {
            print("You tried to insert something, but something went really wrong :( Data not reloaded")
        }
    }
}

extension FoodViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {

            let foodItem = foodItems[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text =
                foodItem.value(forKeyPath: "name") as? String
            return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            foodItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            // delete from core data
        }
    }
}
