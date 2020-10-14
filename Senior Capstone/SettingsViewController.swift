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
    @IBOutlet weak var gSlider: UISlider!
    @IBOutlet weak var dSlider: UISlider!
    @IBOutlet weak var pSlider: UISlider!
    @IBOutlet weak var fSlider: UISlider!
    @IBOutlet weak var vSlider: UISlider!

    var grainValue: Double = DailyState.grainGoal
    var fruitValue: Double = DailyState.fruitGoal
    var vegetableValue: Double = DailyState.vegetableGoal
    var proteinValue: Double = DailyState.proteinGoal
    var dairyValue: Double = DailyState.dairyGoal

    @IBAction func saveSliderValues(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter.date(from: DailyState.todaysDate)!

        var goalRecords = [GoalRecord]()
        let predicate = NSPredicate(format: "date == %@", date as NSDate)
        goalRecords = DatabaseFunctions.retriveGoalRecordOnCondition(predicate: predicate)

        if goalRecords.count != 0 {
            print("Goal already exists for this date, modification made.")
            
            DatabaseFunctions.modifyGoalRecord(date: date, fruitGoal: fruitValue, vegetableGoal: vegetableValue, proteinGoal: proteinValue, grainGoal: grainValue, dairyGoal: dairyValue)

        } else {
            print("No existing entitiy for this date. New goal entity made.")
            DatabaseFunctions.insertGoalRecord(date: date, fruitGoal: fruitValue, vegetableGoal: vegetableValue, proteinGoal: proteinValue, grainGoal: grainValue, dairyGoal: dairyValue)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DailyState.refreshGoals()
        gLabel.text = String(Int(DailyState.grainGoal))
        gSlider.setValue(Float(Int(DailyState.grainGoal)), animated: true)
        fLabel.text = String(Int(DailyState.fruitGoal))
        fSlider.setValue(Float(Int(DailyState.fruitGoal)), animated: true)
        vLabel.text = String(Int(DailyState.vegetableGoal))
        vSlider.setValue(Float(Int(DailyState.vegetableGoal)), animated: true)
        pLabel.text = String(Int(DailyState.proteinGoal))
        pSlider.setValue(Float(Int(DailyState.proteinGoal)), animated: true)
        dLabel.text = String(Int(DailyState.dairyGoal))
        dSlider.setValue(Float(Int(DailyState.dairyGoal)), animated: true)
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

