//
//  ViewController.swift
//  Senior Capstone
//
//  Created by Madison Lucas on 9/2/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import DropDown
import UIKit

class SettingsViewController: UIViewController, ModalTransitionListener  {
       
    // outlets to labels
    @IBOutlet weak var gLabel: UILabel!
    @IBOutlet weak var fLabel: UILabel!
    @IBOutlet weak var vLabel: UILabel!
    @IBOutlet weak var pLabel: UILabel!
    @IBOutlet weak var dLabel: UILabel!
    
    // outlets to sliders
    @IBOutlet weak var gSlider: UISlider!
    @IBOutlet weak var dSlider: UISlider!
    @IBOutlet weak var pSlider: UISlider!
    @IBOutlet weak var fSlider: UISlider!
    @IBOutlet weak var vSlider: UISlider!
    
    // outlet to date
    @IBOutlet weak var navDate: UIBarButtonItem!
    
    // value of goals
    var grainValue: Double = DailyState.grainGoal
    var fruitValue: Double = DailyState.fruitGoal
    var vegetableValue: Double = DailyState.vegetableGoal
    var proteinValue: Double = DailyState.proteinGoal
    var dairyValue: Double = DailyState.dairyGoal
    
    // personal info outlets
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var goalWeight: UITextField!
    @IBOutlet weak var sex: UISegmentedControl!
    @IBOutlet weak var updateGoals: UIButton!
    
    @IBAction func customGoals(_sender: Any) {
        suggestGoals(height: height, weight: weight, goalWeight: goalWeight, sex: sex)
    }
    
    
    @IBAction func saveSliderValues(_ sender: Any) {

        var goalRecords = [GoalRecord]()
        let predicate = NSPredicate(format: "date == %@", DailyState.todaysDateAsDate as NSDate)
        goalRecords = DatabaseFunctions.retriveGoalRecordOnCondition(predicate: predicate)

        if goalRecords.count != 0 {            
            DatabaseFunctions.modifyGoalRecord(fruitGoal: fruitValue, vegetableGoal: vegetableValue, proteinGoal: proteinValue, grainGoal: grainValue, dairyGoal: dairyValue)
        } else {
            DatabaseFunctions.insertGoalRecord(fruitGoal: fruitValue, vegetableGoal: vegetableValue, proteinGoal: proteinValue, grainGoal: grainValue, dairyGoal: dairyValue)
        }
    }
    
    @IBAction func coolThemeSelect(_ sender: Any) {
        ThemeManager.applyTheme(theme: Theme.coolBlue)
    }
 
    @IBAction func warmThemeSelect(_ sender: Any) {
        ThemeManager.applyTheme(theme: Theme.warmOrange)
    }
    
    @IBAction func darkThemeSelect(_ sender: Any) {
        ThemeManager.applyTheme(theme: Theme.darkTones)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadView()
        ModalTransitionMediator.instance.setListener(listener: self)
    }
    
    func reloadView(){
        gLabel.text = String(DailyState.grainGoal)
        gSlider.setValue(Float(DailyState.grainGoal), animated: true)
        fLabel.text = String(DailyState.fruitGoal)
        fSlider.setValue(Float(DailyState.fruitGoal), animated: true)
        vLabel.text = String(DailyState.vegetableGoal)
        vSlider.setValue(Float(DailyState.vegetableGoal), animated: true)
        pLabel.text = String(DailyState.proteinGoal)
        pSlider.setValue(Float(DailyState.proteinGoal), animated: true)
        dLabel.text = String(DailyState.dairyGoal)
        dSlider.setValue(Float(DailyState.dairyGoal), animated: true)
        DailyState.updateNavDate(navDate: navDate)
        
    }
    
    func popoverDismissed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        reloadView()
    }
    
    func increment(value: Float) -> Float {
        let increment: Float = 0.5
        return round(value / increment) * increment
    }

    @IBAction func gSliderValueChanged(_ sender: UISlider) {
        let currentValue = increment(value: sender.value)
        gLabel.text = "\(currentValue)"
        grainValue = Double(currentValue)
    }
    
    @IBAction func fSliderValueChanged(_ sender: UISlider) {
        let currentValue = increment(value: sender.value)
        fLabel.text = "\(currentValue)"
        fruitValue = Double(currentValue)
    }
    
    @IBAction func vSliderValueChanged(_ sender: UISlider) {
        let currentValue = increment(value: sender.value)
        vLabel.text = "\(currentValue)"
        vegetableValue = Double(currentValue)
    }
    
    @IBAction func pSliderValueChanged(_ sender: UISlider) {
        let currentValue = increment(value: sender.value)
        pLabel.text = "\(currentValue)"
        proteinValue = Double(currentValue)
    }
    
    @IBAction func dSliderValueChanged(_ sender: UISlider) {
        let currentValue = increment(value: sender.value)
        dLabel.text = "\(currentValue)"
        dairyValue = Double(currentValue)
    }
    
    
    // logic for personal goals 
    func suggestGoals(height: UITextField, weight: UITextField, goalWeight: UITextField, sex: UISegmentedControl) {
        if (sex.isEnabledForSegment(at: 1)) { // female
            if (Int(height.text!) ?? 0 > 62) { // tall
                if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) == 0) { // maintain
                    fruitValue = 2.5
                    vegetableValue = 3
                    grainValue = 8
                    proteinValue = 6.5
                    dairyValue = 3
                    fLabel.text = "2.5"
                    vLabel.text = "3"
                    gLabel.text = "8"
                    pLabel.text = "6.5"
                    dLabel.text = "3"
                } else if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) > 0) { // lose weight
                    fruitValue = 2.5
                    vegetableValue = 2.5
                    grainValue = 7
                    proteinValue = 6
                    dairyValue = 3
                    fLabel.text = "2.5"
                    vLabel.text = "2.5"
                    gLabel.text = "7"
                    pLabel.text = "6"
                    dLabel.text = "3"
                } else if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) < 0) { // gain weight
                    fruitValue = 2.5
                    vegetableValue = 3
                    grainValue = 9
                    proteinValue = 7
                    dairyValue = 3
                    fLabel.text = "2.5"
                    vLabel.text = "3"
                    gLabel.text = "9"
                    pLabel.text = "7"
                    dLabel.text = "3"
                }
            } else { // short
                if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) == 0) { // maintain
                    fruitValue = 2
                    vegetableValue = 3
                    grainValue = 7
                    proteinValue = 6
                    dairyValue = 3
                    fLabel.text = "2"
                    vLabel.text = "3"
                    gLabel.text = "7"
                    pLabel.text = "6"
                    dLabel.text = "3"
                } else if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) > 0) { // lose weight
                    fruitValue = 2
                    vegetableValue = 2.5
                    grainValue = 6
                    proteinValue = 5.5
                    dairyValue = 3
                    fLabel.text = "2"
                    vLabel.text = "2.5"
                    gLabel.text = "6"
                    pLabel.text = "5.5"
                    dLabel.text = "3"
                } else if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) < 0) { // gain weight
                    fruitValue = 2
                    vegetableValue = 3
                    grainValue = 8
                    proteinValue = 6.5
                    dairyValue = 3
                    fLabel.text = "2"
                    vLabel.text = "3"
                    gLabel.text = "8"
                    pLabel.text = "6.5"
                    dLabel.text = "3"
                }
            }
        } else if (sex.isEnabledForSegment(at: 0)) { // male
            if (Int(height.text!) ?? 0 > 66) { // tall
                if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) == 0) { // maintain
                    fruitValue = 2.5
                    vegetableValue = 3.5
                    grainValue = 10
                    proteinValue = 7
                    dairyValue = 3
                    fLabel.text = "2.5"
                    vLabel.text = "3.5"
                    gLabel.text = "10"
                    pLabel.text = "7"
                    dLabel.text = "3"
                    
                } else if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) > 0) { // lose weight
                    fruitValue = 2.5
                    vegetableValue = 3
                    grainValue = 9
                    proteinValue = 6.5
                    dairyValue = 3
                    fLabel.text = "2.5"
                    vLabel.text = "3"
                    gLabel.text = "9"
                    pLabel.text = "6.5"
                    dLabel.text = "3"
                } else if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) < 0) { // gain weight
                    fruitValue = 2.5
                    vegetableValue = 3.5
                    grainValue = 11
                    proteinValue = 7.5
                    dairyValue = 3
                    fLabel.text = "2.5"
                    vLabel.text = "3.5"
                    gLabel.text = "11"
                    pLabel.text = "7.5"
                    dLabel.text = "3"
                }
               } else { // short
                    if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) == 0) { // maintain
                        fruitValue = 2
                        vegetableValue = 3.5
                        grainValue = 9.5
                        proteinValue = 7
                        dairyValue = 3
                        fLabel.text = "2"
                        vLabel.text = "3.5"
                        gLabel.text = "9.5"
                        pLabel.text = "7"
                        dLabel.text = "3"
                       } else if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) > 0) { // lose weight
                        fruitValue = 2
                        vegetableValue = 3
                        grainValue = 8
                        proteinValue = 6
                        dairyValue = 3
                        fLabel.text = "2"
                        vLabel.text = "3"
                        gLabel.text = "8"
                        pLabel.text = "6"
                        dLabel.text = "3"
                       } else if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) < 0) { // gain weight
                        fruitValue = 2
                        vegetableValue = 3.5
                        grainValue = 10
                        proteinValue = 7
                        dairyValue = 3
                        fLabel.text = "2"
                        vLabel.text = "3.5"
                        gLabel.text = "10"
                        pLabel.text = "7"
                        dLabel.text = "3"
                    }
            }
        } else if (sex.isEnabledForSegment(at: 2)) { // other
            if (Int(height.text!) ?? 0 > 64) { // tall
                if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) == 0) { // maintain
                    fruitValue = 2.5
                    vegetableValue = 3
                    grainValue = 8
                    proteinValue = 6.5
                    dairyValue = 3
                    fLabel.text = "2.5"
                    vLabel.text = "3"
                    gLabel.text = "8"
                    pLabel.text = "6.5"
                    dLabel.text = "3"
                } else if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) > 0) { // lose weight
                    fruitValue = 2.5
                    vegetableValue = 3
                    grainValue = 8
                    proteinValue = 6
                    dairyValue = 3
                    fLabel.text = "2.5"
                    vLabel.text = "3"
                    gLabel.text = "8"
                    pLabel.text = "6"
                    dLabel.text = "3"
                } else if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) < 0) { // gain weight
                    fruitValue = 2.5
                    vegetableValue = 3.5
                    grainValue = 10
                    proteinValue = 7.5
                    dairyValue = 3
                    fLabel.text = "2.5"
                    vLabel.text = "3.5"
                    gLabel.text = "10"
                    pLabel.text = "7.5"
                    dLabel.text = "3"
                }
            } else { // short
                if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) == 0) { // maintain
                    fruitValue = 2
                    vegetableValue = 3.5
                    grainValue = 8
                    proteinValue = 6.5
                    dairyValue = 3
                    fLabel.text = "2"
                    vLabel.text = "3.5"
                    gLabel.text = "8"
                    pLabel.text = "6.5"
                    dLabel.text = "3"
                } else if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) > 0) { // lose weight
                    fruitValue = 2
                    vegetableValue = 3
                    grainValue = 7
                    proteinValue = 6
                    dairyValue = 3
                    fLabel.text = "2"
                    vLabel.text = "3"
                    gLabel.text = "7"
                    pLabel.text = "6"
                    dLabel.text = "3"
                } else if ((Int(weight.text!) ?? 0 - Int(goalWeight.text!)!) < 0) { // gain weight
                    fruitValue = 2
                    vegetableValue = 3.5
                    grainValue = 9
                    proteinValue = 7
                    dairyValue = 3
                    fLabel.text = "2"
                    vLabel.text = "3.5"
                    gLabel.text = "9"
                    pLabel.text = "7"
                    dLabel.text = "3"
                }
            }
        }
    }
}

