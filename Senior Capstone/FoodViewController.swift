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

/**
 * In this class, I update the database directly. That can probably be abstracted out into generic functions
 *  so we dont have to repeat code across strings
 */
class FoodViewController: UIViewController {

    // gives us a reference to the table
    @IBOutlet weak var tableView: UITableView!

    // the persistant container belongs to the appDelegate class
    // appDelegate acts as a singleton, which means there is only once instance
    // of the appDelegate all screens share (basically its a static class)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate;

    // each cell will hold a different entry that conforms to the FoodItem entity
    var foodRecords = [FoodRecord]()

    // I wanted the Alert Box to have 3 text fields instead of 1, so I just had to
    // write that out programatically
    @IBAction func addItem(_ sender: Any) {
        let alert = UIAlertController(title: "New Food Item",
                                      message: "Add a new food item",
                                      preferredStyle: .alert)

        alert.addTextField { (name) in
            name.text = ""
            name.placeholder = "Name"
        }

        alert.addTextField { (name) in
            name.text = ""
            name.placeholder = "Meal"
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in

            guard let nameField = alert.textFields?[0],
                let nameToSave = nameField.text else {
                    return
            }

            guard let groupField = alert.textFields?[1],
                let mealToSave = groupField.text else {
                    return
            }

            self.save(name: nameToSave, meal: mealToSave)

            //refreshes table after Alert is dismissed
            self.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        // links up the two actions specified above
        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }

    // helper method to add the foodItem to the database
    func save(name: String, meal: String) {

        // here I am asking the appDelegate for the persistant container
        // the persistant container basically holds a copy of the database
        // I am asking it to create a new foodItem entry
        let foodRecord = FoodRecord(context: appDelegate.persistentContainer.viewContext)

        foodRecord.date = DailyState.todaysDate
        foodRecord.name = name
        foodRecord.meal = meal
        foodRecord.fruitServing = 0
        foodRecord.grainServing = 0
        foodRecord.veggiesAndBeansServing = 0
        foodRecord.meatServing = 0
        foodRecord.meatServing = 0

        // now I need the appDeleage to check the persistant container and see if there
        // any discrepencies between the copy of the database and the true database
        // it will notice we added a foodItem entry, so it will add it to
        // the database as well
        appDelegate.saveContext()
        self.loadSavedData()

        // in more complex apps, you might want to have multiple persistant containers
        // if you want to have multiple threads running at the same time
        // if you do that, you have to essentially deal with merge conflicts and
        // hiding containers from other scences so that a scene only has one container
        // to work with
        // This is kinda hard, so I don't think we need to bother given the features
        // we want to implement

    }

    // every time we switch between screens and come back, we want to reload the data
    // because we might update the date or something
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        // if we ever need to use an API (i.e. fetch JSON), it would go at this point in the viewDidLoad (or viewWillAppear if necessary)
           // good step-by-step guide (although they implement persistant storage a little differently): https://www.hackingwithswift.com/read/38/4/creating-an-nsmanagedobject-subclass-with-xcode

        loadSavedData()

    }

    func loadSavedData() {

        // prepares a fetch request for all the FoodItem entites stored in the database, sorted by date
        // this is all the stuff we can abstract out
        let request = FoodRecord.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]

        // here I am saying only pull foodItems whose date matches todaysDate
        request.predicate = NSPredicate(format: "date == %@", DailyState.todaysDate)

        do {
            foodRecords = try appDelegate.persistentContainer.viewContext.fetch(request)
            print(foodRecords)
            print("Got \(foodRecords.count) foodRecords")
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }

}

// there are all just mandatory things I needed to override to get the table to work
extension FoodViewController: UITableViewDataSource {

    // saying the number of rows is equal to the number of foodItems returned
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return foodRecords.count
    }

    // sayin that you can modify the table
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // saying that I want to display the name
    // I should also be able to display the group, but I didn't get that working at the moment
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {

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

            // ask for the persistant container and delete it there
            appDelegate.persistentContainer.viewContext.delete(item)

            // remove it from the array that the table uses to display the rows also
            foodRecords.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            // we updateed the persistant container, so when we "save" the changes,
            // the appDelegate will update the database
            appDelegate.saveContext()
        }
    }
}
