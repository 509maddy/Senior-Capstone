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
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var fruitServingStepper: UIStepper!
    @IBOutlet weak var fruitServingLabel: UILabel!
    @IBOutlet weak var fruitLabel: UILabel!
    
    @IBOutlet weak var vegServingStepper: UIStepper!
    @IBOutlet weak var vegServingLabel: UILabel!
    @IBOutlet weak var vegLabel: UILabel!
    
    @IBOutlet weak var proteinServingStepper: UIStepper!
    @IBOutlet weak var proteinServingLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    
    @IBOutlet weak var dairyServingStepper: UIStepper!
    @IBOutlet weak var dairyServingLabel: UILabel!
    @IBOutlet weak var dairyLabel: UILabel!
    
    @IBOutlet weak var grainServingStepper: UIStepper!
    @IBOutlet weak var grainServingLabel: UILabel!
    @IBOutlet weak var grainLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    
    func updateFoodGroup(_ sender: UIStepper, label: UILabel){
        if String(sender.value) == "0.0" {
            label.text = "0"
        } else {
            label.text = String(sender.value)
        }
    }
    
    @IBAction func registerFruitServingChange(_ sender: UIStepper) {
        updateFoodGroup(sender, label: fruitServingLabel)
    }
    
    @IBAction func registerVegServingChange(_ sender: UIStepper) {
        updateFoodGroup(sender, label: vegServingLabel)
    }
    
    @IBAction func registerProteinServingChange(_ sender: UIStepper) {
        updateFoodGroup(sender, label: proteinServingLabel)
    }
    
    @IBAction func registerDairyServingChange(_ sender: UIStepper) {
        updateFoodGroup(sender, label: dairyServingLabel)
    }
    
    
    @IBAction func registerGrainServingChange(_ sender: UIStepper) {
        updateFoodGroup(sender, label: grainServingLabel)
    }
    
    @IBAction func registerDateChange(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let strDate = dateFormatter.string(from: datePicker.date)
        DailyState.updateTodaysDate(todaysDate: strDate)
    }
    
    @IBAction func registerSubmit(_ sender: Any) {
        // Verify that the input data is valid, if not push an error message popup and exit
        if !nameValidation() && !dataValidation() {
            let alert = UIAlertController(title: "No Data Found", message: "Please provide a name and at least one food group.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        } else if !nameValidation(){
            let alert = UIAlertController(title: "Name Field Empty", message: "Please provide a name for the food entry you are making.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        } else if !dataValidation(){
            let alert = UIAlertController(title: "No Servings Entered", message: "Please input at least one of the food groups.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        // else add the entry to the database
        guard let nameToSave = nameInputBox.text else {
            return
        }
        
        DatabaseFunctions.insertFoodRecord(name: nameToSave,
                                           date: DailyState.todaysDate,
                                           dairyServings: dairyServingStepper.value,
                                           fruitServings: fruitServingStepper.value,
                                           grainServings: grainServingStepper.value,
                                           proteinServings: proteinServingStepper.value,
                                           vegServings: vegServingStepper.value)

        tabBarController?.selectedIndex = 0
    }
    
    func dataValidation() -> Bool {
        var dataIsValid: Bool = false
        
        // Verify that at least one serving feild has an input
        let stepperValues = [fruitServingStepper.value, vegServingStepper.value, proteinServingStepper.value, dairyServingStepper.value, grainServingStepper.value]
        
        let servingsLabels = [fruitLabel, vegLabel, proteinLabel, dairyLabel, grainLabel]
        
        for i in 0...(stepperValues.count-1){
            if stepperValues[i] != 0 {
                dataIsValid = true
                break
            }
        }
        
        for i in 0...(stepperValues.count-1){
            if stepperValues[i] == 0 && !dataIsValid{
                servingsLabels[i]?.textColor = UIColor.red
            } else {
                servingsLabels[i]?.textColor = UIColor.black
            }
        }
        
        return dataIsValid
    }
    
    func nameValidation() -> Bool {
        var hasName: Bool = true
        
        // Verify that a name has been provided for the input
        guard let nameToSave = nameInputBox.text else {
            return false
        }
        
        if nameToSave.isEmpty{
            nameLabel.textColor = UIColor.red
            hasName = false
        } else {
            nameLabel.textColor = UIColor.black
        }
        
        return hasName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Reset the name field
        nameLabel.textColor = UIColor.black
        nameInputBox.text = ""
        
        let steppers = [fruitServingStepper, vegServingStepper, proteinServingStepper, dairyServingStepper, grainServingStepper]
        let servingsLabels = [fruitServingLabel, vegServingLabel, proteinServingLabel, dairyServingLabel, grainServingLabel]
        let foodLabels = [fruitLabel, vegLabel, proteinLabel, dairyLabel, grainLabel]
        
        for i in 0...(steppers.count-1) {
            steppers[i]?.value = 0
            steppers[i]?.stepValue = 0.5
            servingsLabels[i]?.text = "0"
            foodLabels[i]?.textColor = UIColor.black
        }
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
