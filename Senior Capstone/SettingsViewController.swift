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
    
    @IBOutlet weak var sex: UITextField!
    
    
    let sexMenu: DropDown = {
        let sexMenu = DropDown()
        sexMenu.dataSource = ["Male","Female"]
        return sexMenu
    }()
    
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
        
        let dropDownView = UIView(frame: sex.frame)
        sex.inputView = dropDownView
        guard let topView = sex.inputView else {
            return
        }
        let gesture = UITapGestureRecognizer(target: self,action: #selector(didTapTopItem))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        topView.addGestureRecognizer(gesture)
        
    }
    
    @objc func didTapTopItem() {
        sexMenu.show()
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
    
    // personal settings logic
    /**
     check if they were changed
     
     if they were, calculate category
     
     male lose weight: 2.5 fruit, 3 veg, 9 grains, 6.5 protein, 3 dairy
     
     male gain weight: 2.5 fruit, 3.5 veg, 11 grains, 7.5 protein, 3 dairy
     
     male maintain weight: 2.5 fruit, 3.5 veg, 10 grains, 7 protein, 3 dairy
     
     female lose weight: 2  fruit, 2.5 veg, 6 grains, 5.5 protein, 3 dairy
     
     femal gain weight: 2 fruit, 3 veg, 8 grains, 6.5 protein, 3 dairy
     
     female maintain weight: 2 fruit, 3 veg, 7 grains, 6 protein, 3 dairy
     
     
     */
}

