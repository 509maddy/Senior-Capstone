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
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate;

    
    @IBAction func registerFruitServingChange(_ sender: Any) {
        fruitServingLabel.text = String(Int(fruitServingStepper.value))
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
