//
//  AddWaterController.swift
//  Senior Capstone
//
//  Created by Emily Howell on 10/28/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AddWaterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var bottlePicker: UIPickerView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var nameCustome: UILabel!
    
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var volumeReadOut: UILabel!
    @IBOutlet weak var volumeCustome: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteButtonHeight: NSLayoutConstraint!
    
    var pickerBottles: [String] = [String]()
    var storedBottles: [BottleRecord] = [BottleRecord]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerBottles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerBottles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nameLabel.textColor = UIColor.black
        if row == 0 { // this is the row that says "Choose An Option:"
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
        } else if row == pickerBottles.count-1 { // this is the "New Custom Entry" row
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
        } else { // all the rows that are saved volumes
            nameLabel.alpha = 1
            nameInput.alpha = 0
            nameCustome.alpha = 1
            nameCustome.text = pickerBottles[row]
            
            volumeLabel.alpha = 1
            volumeSlider.alpha = 0
            volumeReadOut.alpha = 0
            volumeCustome.alpha = 1
            volumeCustome.text = String(format: "%.1f", storedBottles[row-1].value(forKey: "volume") as! Double)
            
            addButton.alpha = 1
            saveButton.alpha = 0
            deleteButton.alpha = 1
        }
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    
    func reloadView() {
        self.view.layoutIfNeeded()
        self.bottlePicker.delegate = self
        self.bottlePicker.dataSource = self
        bottlePicker.selectRow(0, inComponent: 0, animated: true)
        pickerView(bottlePicker, didSelectRow: 0, inComponent: 0)
        nameLabel.textColor = UIColor.black
        nameInput.text = ""
    }
    
    // Add an entry for a drink
    @IBAction func addDrink(_ sender: Any) {
        let pickerRow = bottlePicker.selectedRow(inComponent: 0)
        var nameToSave: String
        var volumeToSave: Double
        
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
        } else {
            nameToSave = pickerBottles[pickerRow]
            volumeToSave = storedBottles[pickerRow-1].value(forKey: "volume") as! Double
        }
        
        DatabaseFunctions.insertWaterRecord(name: nameToSave, volume: volumeToSave)
        nameLabel.textColor = UIColor.black
        nameInput.text = ""
    }
    
    // Save a volume for later use
    @IBAction func saveDrink(_ sender: Any) {
        if !nameValidation(){
            let alert = UIAlertController(title: "Name Field Empty", message: "Please provide a name for the water entry you are making.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        guard let nameToSave = nameInput.text else {
            return
        }
        
        let volumeToSave: Double = Double(round(volumeSlider.value / 0.5) * 0.5)
        
        DatabaseFunctions.insertBottleVolumeRecord(name: nameToSave, volume: volumeToSave)
        loadSavedBottles()
        reloadView()
        bottlePicker.selectRow(pickerBottles.firstIndex(of: nameToSave) ?? 0, inComponent: 0, animated: true)
        pickerView(bottlePicker, didSelectRow: pickerBottles.firstIndex(of: nameToSave) ?? 0, inComponent: 0)
    }
    
    func loadSavedBottles() {
        storedBottles = DatabaseFunctions.retriveBottleRecord()
        
        pickerBottles.removeAll()
        
        if storedBottles.count > 0 {
            for i in 0..<storedBottles.count {
                pickerBottles.append((storedBottles[i].value(forKeyPath: "name") as? String)!)
            }
        }
        
        pickerBottles.append("New Custom Volume")
        pickerBottles.insert("Choose An Option:", at: 0)
    }
    
    func nameValidation() -> Bool {
        var hasName: Bool = true
        
        // Verify that a name has been provided for the input
        guard let nameToSave = nameInput.text else {
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
    
    @IBAction func deleteDrink(_ sender: Any) {
        let pickerRow = bottlePicker.selectedRow(inComponent: 0)
        DatabaseFunctions.deleteBottleRecord(bottleItem: storedBottles[pickerRow-1])
        loadSavedBottles()
        reloadView()
    }
    
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
