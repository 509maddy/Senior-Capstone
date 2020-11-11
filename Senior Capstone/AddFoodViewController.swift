import Foundation
import CoreData
import UIKit

class AddFoodViewController: UIViewController, UIPickerViewDelegate {
    
    // Different objects involved in setting the name of a food entry
    @IBOutlet weak var nameInputBox: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    // Different objects involved in setting the number of fruit servings
    @IBOutlet weak var fruitServingStepper: UIStepper!
    @IBOutlet weak var fruitServingLabel: UILabel!
    @IBOutlet weak var fruitLabel: UILabel!
    
    // Different objects involved in setting the number of vegitable servings
    @IBOutlet weak var vegServingStepper: UIStepper!
    @IBOutlet weak var vegServingLabel: UILabel!
    @IBOutlet weak var vegLabel: UILabel!
    
    // Different objects involved in setting the number of protein servings
    @IBOutlet weak var proteinServingStepper: UIStepper!
    @IBOutlet weak var proteinServingLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    
    // Different objects involved in setting the number of dairy servings
    @IBOutlet weak var dairyServingStepper: UIStepper!
    @IBOutlet weak var dairyServingLabel: UILabel!
    @IBOutlet weak var dairyLabel: UILabel!
    
    // Different objects involved in setting the number of grain servings
    @IBOutlet weak var grainServingStepper: UIStepper!
    @IBOutlet weak var grainServingLabel: UILabel!
    @IBOutlet weak var grainLabel: UILabel!
    
    // Button to submit an entry to be logged
    @IBOutlet weak var submitButton: UIButton!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    
    /*
     Update the UILabel associated with a given UIStepper. Called when UIStepper changed
     */
    func updateFoodGroup(_ sender: UIStepper, label: UILabel) {
        if String(sender.value) == "0.0" {
            label.text = "0" // If the value is zero remove the unneeded decimal
        } else {
            label.text = String(sender.value)
        }
    }
    
    /*
     If the fruitServingStepper is changed, update its cooresponding label
     */
    @IBAction func registerFruitServingChange(_ sender: UIStepper) {
        updateFoodGroup(sender, label: fruitServingLabel)
    }
    
    /*
     If the vegServingStepper is changed, update its cooresponding label
     */
    @IBAction func registerVegServingChange(_ sender: UIStepper) {
        updateFoodGroup(sender, label: vegServingLabel)
    }
    
    /*
     If the proteinServingStepper is changed, update its cooresponding label
     */
    @IBAction func registerProteinServingChange(_ sender: UIStepper) {
        updateFoodGroup(sender, label: proteinServingLabel)
    }
    
    /*
     If the dairyServingStepper is changed, update its cooresponding label
     */
    @IBAction func registerDairyServingChange(_ sender: UIStepper) {
        updateFoodGroup(sender, label: dairyServingLabel)
    }
    
    /*
     If the grainServingStepper is changed, update its cooresponding label
     */
    @IBAction func registerGrainServingChange(_ sender: UIStepper) {
        updateFoodGroup(sender, label: grainServingLabel)
    }
    
    /*
     If the submit button is hit, validate the input name and that at least one serving was provided
     If the input data is valid, save it and navigate the user to the home page so they can see their new entry
     */
    @IBAction func registerSubmit(_ sender: Any) {
        // Verify that the input data is valid, if not push an error message popup and exit
        if !nameValidation() && !dataValidation() {
            let alert = UIAlertController(title: "No Data Found", message: "Please provide a name and at least one food group.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        } else if !nameValidation() {
            let alert = UIAlertController(title: "Name Field Empty", message: "Please provide a name for the food entry you are making.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        } else if !dataValidation() {
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
                                           dairyServings: dairyServingStepper.value,
                                           fruitServings: fruitServingStepper.value,
                                           grainServings: grainServingStepper.value,
                                           proteinServings: proteinServingStepper.value,
                                           vegServings: vegServingStepper.value)

        tabBarController?.selectedIndex = 0
    }
    
    /*
     Validate that at least one of the steppers is non zero
     If all of the steppers are zero, turn their labels red so the user can see their mistake
     Otherwise all labels should be black and the function will return true
     */
    func dataValidation() -> Bool {
        var dataIsValid: Bool = false
        
        // All the steppers to verify that at least one is greater than zero
        let stepperValues = [fruitServingStepper.value, vegServingStepper.value, proteinServingStepper.value, dairyServingStepper.value, grainServingStepper.value]
        
        // All the cooresponding lables, these will be turned red if data invalid
        let servingsLabels = [fruitLabel, vegLabel, proteinLabel, dairyLabel, grainLabel]
        
        // Verify that at least one serving has an input
        for i in 0...(stepperValues.count-1) {
            if stepperValues[i] != 0 {
                dataIsValid = true
                break
            }
        }
        
        // Ajust teh color of the serving lables as needed
        for i in 0...(stepperValues.count-1) {
            if stepperValues[i] == 0 && !dataIsValid {
                servingsLabels[i]?.textColor = UIColor.red
            } else {
                servingsLabels[i]?.textColor = UIColor.black
            }
        }
        
        return dataIsValid
    }
    
    /*
     Validate that a name was provided
     If not, turn the name label red so the user can see their mistake
     Otherwise the lable should be black and the function will return true
     */
    func nameValidation() -> Bool {
        var hasName: Bool = true
        
        // Verify that a name has been provided for the input
        guard let nameToSave = nameInputBox.text else {
            return false
        }
        
        // Ajust the color of the name label as needed
        if nameToSave.isEmpty {
            nameLabel.textColor = UIColor.red
            hasName = false
        } else {
            nameLabel.textColor = UIColor.black
        }
        
        return hasName
    }
    
    /*
     Every time the view appares it should be reloaded so that all the steppers are zeroed out and all text is set to black
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadView()
    }
    
    /*
     Resets everything so that steppers are zeroed out and all text is set to black
     */
    func reloadView() {
        nameLabel.textColor = UIColor.black
        nameInputBox.text = ""
        
        let steppers = [fruitServingStepper, vegServingStepper, proteinServingStepper, dairyServingStepper, grainServingStepper]
        let servingsLabels = [fruitServingLabel, vegServingLabel, proteinServingLabel, dairyServingLabel, grainServingLabel]
        let foodLabels = [fruitLabel, vegLabel, proteinLabel, dairyLabel, grainLabel]
        
        // make sure steppers are zeroed out and all text is set to black
        for i in 0...(steppers.count-1) {
            steppers[i]?.value = 0
            steppers[i]?.stepValue = 0.5
            servingsLabels[i]?.text = "0"
            foodLabels[i]?.textColor = UIColor.black
        }
    }
    
    /*
     When the view first load's, initialize the DataFormatter to facilitate saving data
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
    }
}
