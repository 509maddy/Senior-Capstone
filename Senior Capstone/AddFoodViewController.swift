//
//  AddFoodViewController.swift
//  Senior Capstone
//
//  Created by Madison Lucas on 9/18/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AddFoodViewController: UIViewController, UIPickerViewDelegate {

    @IBOutlet weak var nameInputBox: UITextField!

    @IBOutlet weak var fruitServingStepper: UIStepper!
    @IBOutlet weak var fruitServingLabel: UILabel!
    
    @IBOutlet weak var vegServingStepper: UIStepper!
    @IBOutlet weak var vegServingLabel: UILabel!
    
    @IBOutlet weak var protienServingStepper: UIStepper!
    @IBOutlet weak var protienServingLabel: UILabel!
    
    @IBOutlet weak var dairyServingStepper: UIStepper!
    @IBOutlet weak var dairyServingLabel: UILabel!
    
    @IBOutlet weak var carbServingStepper: UIStepper!
    @IBOutlet weak var carbServingLabel: UILabel!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate;

    
    @IBAction func registerFruitServingChange(_ sender: Any) {
        fruitServingLabel.text = String(Int(fruitServingStepper.value))
    }
    
    @IBAction func registerVegServingChange(_ sender: Any) {
        vegServingLabel.text = String(Int(vegServingStepper.value))
    }
    
    @IBAction func registerProtienServingChange(_ sender: Any) {
        protienServingLabel.text = String(Int(protienServingStepper.value))
    }
    
    @IBAction func registerDairyServingChange(_ sender: Any) {
        dairyServingLabel.text = String(Int(dairyServingStepper.value))
    }
    
    @IBAction func registerCarbServingChange(_ sender: Any) {
        carbServingLabel.text = String(Int(carbServingStepper.value))
    }
    
    
    @IBAction func registerDateChange(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let strDate = dateFormatter.string(from: datePicker.date)
        DailyState.updateTodaysDate(todaysDate: strDate)
    }

    @IBAction func registerSubmit(_ sender: Any) {
        // add to database
        guard let nameToSave = nameInputBox.text else {
            return
        }

        DatabaseFunctions.insertFoodRecord(name: nameToSave, group: "Fruit", date: DailyState.todaysDate)
        tabBarController?.selectedIndex = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let strDate = dateFormatter.string(from: datePicker.date)
        DailyState.updateTodaysDate(todaysDate: strDate)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
