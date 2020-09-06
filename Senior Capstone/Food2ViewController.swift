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

class Food2ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    var foodItems = [FoodItem]()

    @IBAction func addItem(_ sender: Any) {
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
        let foodItem = FoodItem(context: appDelegate.persistentContainer.viewContext)

        if let intCalories = Int32(calories) {
            foodItem.calories = intCalories
            foodItem.date = DailyState.todaysDate
            foodItem.group = group
            foodItem.name = name

            appDelegate.saveContext()
            self.loadSavedData()
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard appDelegate.persistentContainer != nil else {
            fatalError("This view needs a persistent container.")
        }

        // if we ever need to use an API (i.e. fetch JSON), it would go at this point in the viewDidLoad (or viewWillAppear if necessary)
           // good step-by-step guide: https://www.hackingwithswift.com/read/38/4/creating-an-nsmanagedobject-subclass-with-xcode

        loadSavedData()

    }

    func loadSavedData() {

        // prepares a fetch request for all the FoodItem entites stored in the database, sorted by date
        let request = FoodItem.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]

        do {
            foodItems = try appDelegate.persistentContainer.viewContext.fetch(request)
            print(foodItems)
            print("Got \(foodItems.count) foodItems")
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }

}

extension Food2ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {

            print("Am I going here?")

            let foodItem = foodItems[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text =
                foodItem.value(forKeyPath: "name") as? String
            cell.detailTextLabel!.text = foodItem.group
            print("hello?")

            return cell
    }
}
