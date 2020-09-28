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
    var group = "Fruit" // needed a default value
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
        guard let servingsToSave = servingsInputBox.text else {
            return
        }

        if let servingsToSaveDecimal = Double(servingsToSave) {
            print(servingsToSaveDecimal)
            DatabaseFunctions.insertFoodRecord(name: nameToSave, group: group, date: DailyState.todaysDate, servings: servingsToSaveDecimal)
        } else {
            print("didn't take servings correctly so didnt add to table")
        }

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

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       group = pickerData[row]
    }
}
