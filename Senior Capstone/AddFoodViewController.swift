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
    
    @IBOutlet weak var proteinServingStepper: UIStepper!
    @IBOutlet weak var proteinServingLabel: UILabel!
    
    @IBOutlet weak var dairyServingStepper: UIStepper!
    @IBOutlet weak var dairyServingLabel: UILabel!
    
    @IBOutlet weak var grainServingStepper: UIStepper!
    @IBOutlet weak var grainServingLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate;

    
    @IBAction func registerFruitServingChange(_ sender: Any) {
        fruitServingLabel.text = String(Int(fruitServingStepper.value))
    }
    
    @IBAction func registerVegServingChange(_ sender: Any) {
        vegServingLabel.text = String(Int(vegServingStepper.value))
    }
    
    @IBAction func registerProteinServingChange(_ sender: Any) {
        proteinServingLabel.text = String(Int(proteinServingStepper.value))
    }
    
    @IBAction func registerDairyServingChange(_ sender: Any) {
        dairyServingLabel.text = String(Int(dairyServingStepper.value))
    }
    
    
    @IBAction func registerGrainServingChange(_ sender: Any) {
        grainServingLabel.text = String(Int(grainServingStepper.value))
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
        
        //Remove once we are saving multiple food groups
        var groupType = "none"
        var numToSave = 0
        
        if (Int(fruitServingStepper.value) > numToSave){
            groupType = "fruit"
            numToSave = Int(fruitServingStepper.value)
        }
        if (Int(vegServingStepper.value) > numToSave){
            groupType = "vegetable"
            numToSave = Int(vegServingStepper.value)
        }
        if (Int(dairyServingStepper.value) > numToSave){
            groupType = "dairy"
            numToSave = Int(dairyServingStepper.value)
        }
        if (Int(proteinServingStepper.value) > numToSave){
            groupType = "protein"
            numToSave = Int(proteinServingStepper.value)
        }
        if (Int(grainServingStepper.value) > numToSave){
            groupType = "grain"
            numToSave = Int(grainServingStepper.value)
        }
        

        DatabaseFunctions.insertFoodRecord(name: nameToSave, group: groupType, date: DailyState.todaysDate, servings: Double(numToSave))
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
