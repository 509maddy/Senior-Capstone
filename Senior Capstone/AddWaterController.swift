import Foundation
import CoreData
import UIKit

class AddWaterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    // Picker that allows you to select between different saved/custom options for logging water
    @IBOutlet weak var bottlePicker: UIPickerView!
    
    // Different objects  involved in showing/ setting the title of a water entry
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var nameCustome: UILabel!
    
    // Different objects involved in showing/ setting the volume of a water entry
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var volumeReadOut: UILabel!
    @IBOutlet weak var volumeCustome: UILabel!
    
    // Buttons for adding, saving, or deleting water entries
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // Fields for storing the saved bottle's and names of saved bottle entries
    var storedBottles: [BottleRecord] = [BottleRecord]()
    var pickerBottles: [String] = [String]()
    
    /*
     UIPickerView reqired method. Sets the number of components to 1
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /*
     UIPickerView reqired method. Informs the picker that it will need a new row for each element in the pickerBottles array
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerBottles.count
    }
    
    /*
     UIPickerView reqired method. Informs the picker of the string label for each row.
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerBottles[row]
    }
    
    /*
     UIPickerView reqired method. Is run each time a new row in the picker is selected.
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nameLabel.textColor = UIColor.black
        
        // if the "Choose An Option:" row is chosen, only the picker should be displayed
        if row == 0 {
            nameLabel.alpha = 0
            nameInput.alpha = 0
            nameCustome.alpha = 0
            
            volumeLabel.alpha = 0
            volumeSlider.alpha = 0
            volumeReadOut.alpha = 0
            volumeCustome.alpha = 0
            
            addButton.alpha = 0
            saveButton.alpha = 0
            deleteButton.alpha = 0
        }
        
        // if the "New Custom Entry" row is chosen, show the custom fields and add/ save button
        else if row == pickerBottles.count-1 {
            nameLabel.alpha = 1
            nameInput.alpha = 1
            nameCustome.alpha = 0
            
            volumeLabel.alpha = 1
            volumeSlider.alpha = 1
            volumeReadOut.alpha = 1
            volumeCustome.alpha = 0
            
            addButton.alpha = 1
            saveButton.alpha = 1
            deleteButton.alpha = 0
        }
        
        // if any of the other rows are selected they are saved volumes and their saved names and values should be displayed
        else {
            nameLabel.alpha = 1
            nameInput.alpha = 0
            nameCustome.alpha = 1
            nameCustome.text = pickerBottles[row] // display the name of the bottle
            
            volumeLabel.alpha = 1
            volumeSlider.alpha = 0
            volumeReadOut.alpha = 0
            volumeCustome.alpha = 1
            volumeCustome.text = String(format: "%.1f", storedBottles[row-1].value(forKey: "volume") as! Double) // display the volume associated with this bottle name
            
            addButton.alpha = 1
            saveButton.alpha = 0
            deleteButton.alpha = 1
        }
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    
    /*
     Functions that must be called in order to reload the displayed view
     Resets the picker to the first row, sets all text to black, etc.
     */
    func reloadView() {
        self.view.layoutIfNeeded()
        self.bottlePicker.delegate = self
        self.bottlePicker.dataSource = self
        bottlePicker.selectRow(0, inComponent: 0, animated: true)
        pickerView(bottlePicker, didSelectRow: 0, inComponent: 0)
        nameLabel.textColor = UIColor.black
        nameInput.text = ""
    }
    
    /*
     Log a new drink entry for the given date.
     */
    @IBAction func addDrink(_ sender: Any) {
        // Get the row which we are currently on in the picker. This informs what info to log
        let pickerRow = bottlePicker.selectedRow(inComponent: 0)
        
        // Fields for the name and volumen to be saved
        var nameToSave: String
        var volumeToSave: Double
        
        // If a custome entry, verify that the name is valid and then log the custom amount from the slider/ text box
        if pickerRow == pickerBottles.count-1{
            if !nameValidation(){
                let alert = UIAlertController(title: "Name Field Empty", message: "Please provide a name for the water entry you are making.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                return
            }
            
            guard let name = nameInput.text else {
                return
            }
            
            nameToSave = name
            volumeToSave = Double(round(volumeSlider.value / 0.5) * 0.5)
        }
        
        // If a presaved entry, just log the presaved values
        else {
            nameToSave = pickerBottles[pickerRow]
            volumeToSave = storedBottles[pickerRow-1].value(forKey: "volume") as! Double
        }
        
        // Insert the new entry and reset so a new entry can be made
        DatabaseFunctions.insertWaterRecord(name: nameToSave, volume: volumeToSave)
        nameLabel.textColor = UIColor.black
        nameInput.text = ""
    }
    
    /*
     Saved a volume to be used later
     */
    @IBAction func saveDrink(_ sender: Any) {
        // verify that the given name is valid. If not, throw error
        if !nameValidation(){
            let alert = UIAlertController(title: "Name Field Empty", message: "Please provide a name for the water entry you are making.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        // Grab the text from the UITextField to be saved as the volume name
        guard let nameToSave = nameInput.text else {
            return
        }
        
        // Grab the value of the slider to be saved as the volume
        let volumeToSave: Double = Double(round(volumeSlider.value / 0.5) * 0.5)
        
        // Save the new volume, reset, and navigate the picker to the new row where the volume is saved
        DatabaseFunctions.insertBottleVolumeRecord(name: nameToSave, volume: volumeToSave)
        loadSavedBottles()
        reloadView()
        bottlePicker.selectRow(pickerBottles.firstIndex(of: nameToSave) ?? 0, inComponent: 0, animated: true)
        pickerView(bottlePicker, didSelectRow: pickerBottles.firstIndex(of: nameToSave) ?? 0, inComponent: 0)
    }
    
    /*
     Pull the saved bottles from the database
     */
    func loadSavedBottles() {
        // get the saved bottles
        storedBottles = DatabaseFunctions.retriveBottleRecord()
        
        // reset the array used for the picker strings
        pickerBottles.removeAll()
        
        // grab the names for each saved bottle and add them to the picker array
        if storedBottles.count > 0 {
            for i in 0..<storedBottles.count {
                pickerBottles.append((storedBottles[i].value(forKeyPath: "name") as? String)!)
            }
        }
        
        // add the rows for the picker title and custom entries into the picker array
        pickerBottles.insert("Choose An Option:", at: 0)
        pickerBottles.append("New Custom Volume")
    }
    
    /*
     Verify that the UITextField used for name entry is not empty
     If empty, turn the name lable red otherwise set to black
     Return if a valid name or not
     */
    func nameValidation() -> Bool {
        var hasName: Bool = true
        
        // Verify that a name has been provided for the input
        guard let nameToSave = nameInput.text else {
            return false
        }
        
        if nameToSave.isEmpty {
            nameLabel.textColor = UIColor.red
            hasName = false
        } else {
            nameLabel.textColor = UIColor.black
        }
        
        return hasName
    }
    
    /*
     Delete the saved volume and reload the picker
     */
    @IBAction func deleteDrink(_ sender: Any) {
        let pickerRow = bottlePicker.selectedRow(inComponent: 0)
        DatabaseFunctions.deleteBottleRecord(bottleItem: storedBottles[pickerRow-1])
        loadSavedBottles()
        reloadView()
    }
    
    /*
     Update the redout lable for the slider every time the slider is changed
     */
    @IBAction func customeValueSliderChanged(_ sender: UISlider) {
        let currentValue = round(sender.value / 0.5) * 0.5
        volumeReadOut.text = "\(currentValue)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadView()
        loadSavedBottles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
