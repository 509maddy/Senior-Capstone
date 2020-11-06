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
    var waterRecords:[WaterRecord] = [WaterRecord]()
    var totalWaterIntake:Double = 0
    
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
        calculateTotalWaterIntake()
        tableView.reloadData()
    }
    
    func calculateTotalWaterIntake() {
        totalWaterIntake = 0
        for record in waterRecords {
            totalWaterIntake += record.value(forKey: "volume") as! Double
        }
    }
}

// there are all just mandatory things I needed to override to get the table to work
extension WaterDetailVC: UITableViewDataSource {

    // saying the number of rows is equal to the number of foodItems returned
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return waterRecords.count + 1
    }

    // saying that you can modify the table
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // saying that I want to display the name in each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        
        if(indexPath.row != waterRecords.count) {
            let recordName = waterRecords[indexPath.row].value(forKeyPath: "name") as? String
            let recordVolume = String(format: "%.1f", waterRecords[indexPath.row].value(forKey: "volume") as! Double)
            cell.textLabel?.text = String(recordName!.prefix(1)).capitalized + String(recordName!.dropFirst())
            cell.detailTextLabel?.text = "+" + recordVolume + " oz"
        } else {
            cell.detailTextLabel?.text = "Total = " + String(format: "%.1f", totalWaterIntake) + " oz"
        }
        return cell
    }

    // saying that if the user deletes (i.e. swipeing a row to the left), heres how you do it
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (indexPath.row == waterRecords.count) {
            return;
        }
        if (editingStyle == .delete) {
            // pull out the item the user swiped left on
            let item = waterRecords[indexPath.row]
            DatabaseFunctions.deleteWaterRecord(waterItem: item)
            waterRecords.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            calculateTotalWaterIntake()
            tableView.reloadData()
        }
    }
}
