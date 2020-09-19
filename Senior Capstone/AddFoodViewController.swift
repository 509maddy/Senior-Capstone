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

class AddFoodViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nameInputBox: UITextField!
    @IBOutlet weak var servingsInputBox: UITextField!
    @IBOutlet weak var foodGroupPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!

    let pickerData = ["Fruit", "Vegtable & Beans", "Protein", "Grain", "Dairy"]
    var groupChoice = "Fruit"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate;

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
        let mealToSave = "Breakfast"
        let dateToSave = DailyState.todaysDate

        self.save(name: nameToSave, meal: mealToSave, date: dateToSave)
        tabBarController?.selectedIndex = 0
    }

    func save(name: String, meal: String, date: String) {
        let foodRecord = FoodRecord(context: appDelegate.persistentContainer.viewContext)
        foodRecord.date = DailyState.todaysDate
        foodRecord.meal = meal
        foodRecord.name = name
        appDelegate.saveContext()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       groupChoice = pickerData[row]
    }
}
