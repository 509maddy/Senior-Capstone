//
//  ViewController.swift
//  Senior Capstone
//
//  Created by Madison Lucas on 9/2/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
   
    @IBOutlet weak var gLabel: UILabel!
    @IBOutlet weak var fLabel: UILabel!
    @IBOutlet weak var vLabel: UILabel!
    @IBOutlet weak var pLabel: UILabel!
    @IBOutlet weak var dLabel: UILabel!

    var grainValue: Double = DailyState.grainGoal
    var fruitValue: Double = DailyState.fruitGoal
    var vegetableValue: Double = DailyState.vegetableGoal
    var proteinValue: Double = DailyState.proteinGoal
    var dairyValue: Double = DailyState.dairyGoal

    @IBAction func saveSliderValues(_ sender: Any) {
        var goalRecords = [GoalRecord]()
        let predicate = NSPredicate(format: "date == %@", DailyState.todaysDate)
        goalRecords = DatabaseFunctions.retriveGoalRecordOnCondition(predicate: predicate)

        if goalRecords.count != 0 {
            print("Goal already exists for this date, modification made.")
            DatabaseFunctions.modifyGoalRecord(date: DailyState.todaysDate, fruitGoal: fruitValue, vegetableGoal: vegetableValue, proteinGoal: proteinValue, grainGoal: grainValue, dairyGoal: dairyValue)

        } else {
            print("No existing entitiy for this date. New goal entity made.")
            DatabaseFunctions.insertGoalRecord(date: DailyState.todaysDate, fruitGoal: fruitValue, vegetableGoal: vegetableValue, proteinGoal: proteinValue, grainGoal: grainValue, dairyGoal: dairyValue)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        gLabel.text = String(Int(grainValue))
        fLabel.text = String(Int(fruitValue))
        vLabel.text = String(Int(vegetableValue))
        pLabel.text = String(Int(proteinValue))
        dLabel.text = String(Int(dairyValue))
    }

    @IBAction func gSliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        gLabel.text = "\(currentValue)"
        grainValue = Double(currentValue)
    }
    
    @IBAction func fSliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        fLabel.text = "\(currentValue)"
        fruitValue = Double(currentValue)
    }
    
    @IBAction func vSliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        vLabel.text = "\(currentValue)"
        vegetableValue = Double(currentValue)
    }
    
    @IBAction func pSliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        pLabel.text = "\(currentValue)"
        proteinValue = Double(currentValue)
    }
    
    @IBAction func dSliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        dLabel.text = "\(currentValue)"
        dairyValue = Double(currentValue)
    }
}

