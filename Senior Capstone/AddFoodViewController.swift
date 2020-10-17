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

    var fruitValue: Double = 0.0
    @IBOutlet weak var fruitServingStepper: UIStepper!
    @IBOutlet weak var fruitServingLabel: UILabel!
    
    var vegValue: Double = 0.0
    @IBOutlet weak var vegServingStepper: UIStepper!
    @IBOutlet weak var vegServingLabel: UILabel!
    
    var proteinValue: Double = 0.0
    @IBOutlet weak var proteinServingStepper: UIStepper!
    @IBOutlet weak var proteinServingLabel: UILabel!
    
    var dairyValue: Double = 0.0
    @IBOutlet weak var dairyServingStepper: UIStepper!
    @IBOutlet weak var dairyServingLabel: UILabel!
    
    var grainValue: Double = 0.0
    @IBOutlet weak var grainServingStepper: UIStepper!
    @IBOutlet weak var grainServingLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate;

    /* Basically, for the UIStepper you can't tell if it's being incremented
        or decremented unless you use this weird round about way.
    */
    func increment(_ sender: UIStepper, valueToUpdate: inout Double){
        let increment: Double = 0.5
        
        if sender.value == 1.0 {
            print("pos")
            valueToUpdate += increment
        }
        else {
            print("here")
            valueToUpdate -= increment
        }
        sender.value = 0  //resetting the stepper value so negative is -1 and pos
    }
    
    func updateFoodGroup(_ sender: UIStepper, valueToUpdate: inout Double, label: UILabel){
        increment(sender, valueToUpdate: &valueToUpdate)
        label.text = String(valueToUpdate)
    }
    
    @IBAction func registerFruitServingChange(_ sender: UIStepper) {
        updateFoodGroup(sender, valueToUpdate: &fruitValue, label: fruitServingLabel)
    }
    
    @IBAction func registerVegServingChange(_ sender: UIStepper) {
        updateFoodGroup(sender, valueToUpdate: &vegValue, label: vegServingLabel)
    }
    
    @IBAction func registerProteinServingChange(_ sender: UIStepper) {
        updateFoodGroup(sender, valueToUpdate: &proteinValue, label: proteinServingLabel)
    }
    
    @IBAction func registerDairyServingChange(_ sender: UIStepper) {
        updateFoodGroup(sender, valueToUpdate: &dairyValue, label: dairyServingLabel)
    }
    
    
    @IBAction func registerGrainServingChange(_ sender: UIStepper) {
        updateFoodGroup(sender, valueToUpdate: &grainValue, label: grainServingLabel)
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
        
        DatabaseFunctions.insertFoodRecord(name: nameToSave,
                                           date: DailyState.todaysDate,
                                           dairyServings: Double(dairyServingStepper.value),
                                           fruitServings: Double(fruitServingStepper.value),
                                           grainServings: Double(grainServingStepper.value),
                                           proteinServings: Double(proteinServingStepper.value),
                                           vegServings: Double(vegServingStepper.value))

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
