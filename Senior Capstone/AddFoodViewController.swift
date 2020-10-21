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
    
    func updateFoodGroup(_ sender: UIStepper, label: UILabel){
        label.text = String(sender.value)
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
        // add to database
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

    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let strDate = dateFormatter.string(from: datePicker.date)
        DailyState.updateTodaysDate(todaysDate: strDate)
        fruitServingStepper.stepValue = 0.5
        grainServingStepper.stepValue = 0.5
        vegServingStepper.stepValue = 0.5
        dairyServingStepper.stepValue = 0.5
        proteinServingStepper.stepValue = 0.5
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
