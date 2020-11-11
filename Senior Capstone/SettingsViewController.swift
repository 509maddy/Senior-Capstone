import UIKit

// class to control functions for the settings page
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
    
    // runs when the customize goals button is selected
    @IBAction func customGoals(_sender: Any) {
        suggestGoals(height: height, weight: weight, goalWeight: goalWeight, sex: sex)
    }
    
    // a method to save the slider values to the backend
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
    
    // changes the app theme to cool when selected
    @IBAction func coolThemeSelect(_ sender: Any) {
        ThemeManager.applyTheme(theme: Theme.coolBlue)
    }
 
    // changes the app theme to warm when selected
    @IBAction func warmThemeSelect(_ sender: Any) {
        ThemeManager.applyTheme(theme: Theme.warmOrange)
    }
    
    // changes the app theme to dark when selected
    @IBAction func darkThemeSelect(_ sender: Any) {
        ThemeManager.applyTheme(theme: Theme.darkTones)
    }

    // a method to show the view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadView()
        ModalTransitionMediator.instance.setListener(listener: self)
    }
    
    // a method to reload the view with the goals from the backend
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
    
    // called when the date picker popover is dismissed
    func popoverDismissed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        reloadView()
    }
    
    // increments the slider values
    func increment(value: Float) -> Float {
        let increment: Float = 0.5
        return round(value / increment) * increment
    }
    
    // updates grain goal based on slider change
    @IBAction func gSliderValueChanged(_ sender: UISlider) {
        let currentValue = increment(value: sender.value)
        gLabel.text = "\(currentValue)"
        grainValue = Double(currentValue)
    }
    
    // updates fruit goal based on slider change
    @IBAction func fSliderValueChanged(_ sender: UISlider) {
        let currentValue = increment(value: sender.value)
        fLabel.text = "\(currentValue)"
        fruitValue = Double(currentValue)
    }
    
    // updates vegetable goal based on slider change
    @IBAction func vSliderValueChanged(_ sender: UISlider) {
        let currentValue = increment(value: sender.value)
        vLabel.text = "\(currentValue)"
        vegetableValue = Double(currentValue)
    }
    
    // updates protein goal based on slider change
    @IBAction func pSliderValueChanged(_ sender: UISlider) {
        let currentValue = increment(value: sender.value)
        pLabel.text = "\(currentValue)"
        proteinValue = Double(currentValue)
    }
    
    // updates dairy goal based on slider change
    @IBAction func dSliderValueChanged(_ sender: UISlider) {
        let currentValue = increment(value: sender.value)
        dLabel.text = "\(currentValue)"
        dairyValue = Double(currentValue)
    }
    
    // logic for personal goals 
    func suggestGoals(height: UITextField, weight: UITextField, goalWeight: UITextField, sex: UISegmentedControl) {
        if (sex.isEnabledForSegment(at: 1)) { // female
            if (Int(height.text!) ?? 0 > 62) { // tall
                if ((Int(weight.text!)! - Int(goalWeight.text!)!) == 0) { // maintain
                    fruitValue = 2.5
                    vegetableValue = 3.0
                    grainValue = 8.0
                    proteinValue = 6.5
                    dairyValue = 3.0
                } else if ((Int(weight.text!)! - Int(goalWeight.text!)!) > 0) { // lose weight
                    fruitValue = 2.5
                    vegetableValue = 2.5
                    grainValue = 7.0
                    proteinValue = 6.0
                    dairyValue = 3.0
                } else if ((Int(weight.text!)! - Int(goalWeight.text!)!) < 0) { // gain weight
                    fruitValue = 2.5
                    vegetableValue = 3.0
                    grainValue = 9.0
                    proteinValue = 7.0
                    dairyValue = 3.0
                }
            } else { // short
                if ((Int(weight.text!)! - Int(goalWeight.text!)!) == 0) { // maintain
                    fruitValue = 2.0
                    vegetableValue = 3.0
                    grainValue = 7.0
                    proteinValue = 6.0
                    dairyValue = 3.0
                } else if ((Int(weight.text!)! - Int(goalWeight.text!)!) > 0) { // lose weight
                    fruitValue = 2.0
                    vegetableValue = 2.5
                    grainValue = 6.0
                    proteinValue = 5.5
                    dairyValue = 3.0
                } else if ((Int(weight.text!)! - Int(goalWeight.text!)!) < 0) { // gain weight
                    fruitValue = 2.0
                    vegetableValue = 3.0
                    grainValue = 8.0
                    proteinValue = 6.5
                    dairyValue = 3.0
                }
            }
        } else if (sex.isEnabledForSegment(at: 0)) { // male
            if (Int(height.text!) ?? 0 > 66) { // tall
                if ((Int(weight.text!)! - Int(goalWeight.text!)!) == 0) { // maintain
                    fruitValue = 2.5
                    vegetableValue = 3.5
                    grainValue = 10.0
                    proteinValue = 7.0
                    dairyValue = 3.0
                } else if ((Int(weight.text!)! - Int(goalWeight.text!)!) > 0) { // lose weight
                    fruitValue = 2.5
                    vegetableValue = 3.0
                    grainValue = 9.0
                    proteinValue = 6.5
                    dairyValue = 3.0
                } else if ((Int(weight.text!)! - Int(goalWeight.text!)!) < 0) { // gain weight
                    fruitValue = 2.5
                    vegetableValue = 3.5
                    grainValue = 11.0
                    proteinValue = 7.5
                    dairyValue = 3.0
                }
               } else { // short
                    if ((Int(weight.text!)! - Int(goalWeight.text!)!) == 0) { // maintain
                        fruitValue = 2.0
                        vegetableValue = 3.5
                        grainValue = 9.5
                        proteinValue = 7.0
                        dairyValue = 3.0
                       } else if ((Int(weight.text!)! - Int(goalWeight.text!)!) > 0) { // lose weight
                        fruitValue = 2.0
                        vegetableValue = 3.0
                        grainValue = 8.0
                        proteinValue = 6.0
                        dairyValue = 3.0
                       } else if ((Int(weight.text!)! - Int(goalWeight.text!)!) < 0) { // gain weight
                        fruitValue = 2.0
                        vegetableValue = 3.5
                        grainValue = 10.0
                        proteinValue = 7.0
                        dairyValue = 3.0
                    }
            }
        } else if (sex.isEnabledForSegment(at: 2)) { // other
            if (Int(height.text!) ?? 0 > 64) { // tall
                if ((Int(weight.text!)! - Int(goalWeight.text!)!) == 0) { // maintain
                    fruitValue = 2.5
                    vegetableValue = 3.0
                    grainValue = 8.0
                    proteinValue = 6.5
                    dairyValue = 3.0
                } else if ((Int(weight.text!)! - Int(goalWeight.text!)!) > 0) { // lose weight
                    fruitValue = 2.5
                    vegetableValue = 3.0
                    grainValue = 8.0
                    proteinValue = 6.0
                    dairyValue = 3.0
                } else if ((Int(weight.text!)! - Int(goalWeight.text!)!) < 0) { // gain weight
                    fruitValue = 2.5
                    vegetableValue = 3.5
                    grainValue = 10.0
                    proteinValue = 7.5
                    dairyValue = 3.0
                }
            } else { // short
                if ((Int(weight.text!)! - Int(goalWeight.text!)!) == 0) { // maintain
                    fruitValue = 2.0
                    vegetableValue = 3.5
                    grainValue = 8.0
                    proteinValue = 6.5
                    dairyValue = 3.0
                } else if ((Int(weight.text!)! - Int(goalWeight.text!)!) > 0) { // lose weight
                    fruitValue = 2.0
                    vegetableValue = 3.0
                    grainValue = 7.0
                    proteinValue = 6.0
                    dairyValue = 3.0
                } else if ((Int(weight.text!)! - Int(goalWeight.text!)!) < 0) { // gain weight
                    fruitValue = 2.0
                    vegetableValue = 3.5
                    grainValue = 9.0
                    proteinValue = 7.0
                    dairyValue = 3.0
                }
            }
        }
        fLabel.text = "\(fruitValue)"
        vLabel.text = "\(vegetableValue)"
        gLabel.text = "\(grainValue)"
        pLabel.text = "\(proteinValue)"
        dLabel.text = "\(dairyValue)"
    }
}
