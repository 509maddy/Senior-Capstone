//
//  WaterDetailVC.swift
//  Senior Capstone
//
//  Created by Emily Howell on 11/6/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import UIKit

class WaterDetailVC: UIViewController, UITableViewDelegate, ModalTransitionListener {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navDate: UIBarButtonItem!
    // each cell will hold a different entry that conforms to the FoodItem entity
    var waterRecords = [WaterRecord]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    
    func popoverDismissed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        reloadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadView()
        ModalTransitionMediator.instance.setListener(listener: self)
    }
    
    func reloadView(){
        title = "Today's Water"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        loadSavedData()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        DailyState.updateNavDate(navDate: navDate)
    }

    func loadSavedData() {
        let predicate = NSPredicate(format: "date == %@", DailyState.todaysDateAsDate as NSDate)
        waterRecords = DatabaseFunctions.retriveWaterRecordOnCondition(predicate: predicate)
        print(waterRecords[0].value(forKeyPath: "name") as? String ?? "no value")
        tableView.reloadData()
    }
}

// there are all just mandatory things I needed to override to get the table to work
extension WaterDetailVC: UITableViewDataSource {

    // saying the number of rows is equal to the number of foodItems returned
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        print("here1")
        return waterRecords.count
    }

    // saying that you can modify the table
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        print("here2")
        return true
    }

    // saying that I want to display the name in each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("here3")
        print("entering a value into the table")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = waterRecords[indexPath.row].value(forKeyPath: "name") as? String
        print(cell.textLabel?.text ?? "error")
        return cell
    }

    // saying that if the user deletes (i.e. swipeing a row to the left), heres how you do it
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("here4")
        if (editingStyle == .delete) {
            // pull out the item the user swiped left on
            let item = waterRecords[indexPath.row]
            DatabaseFunctions.deleteWaterRecord(waterItem: item)
            waterRecords.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
