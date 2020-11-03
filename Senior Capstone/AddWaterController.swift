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
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var nameCustome: UILabel!
    
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var volumeReadOut: UILabel!
    @IBOutlet weak var volumeCustome: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var addButtonLowerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var saveButtonLowerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var editButtonLowerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteButtonHeight: NSLayoutConstraint!
    
    var pickerBottles: [String] = ["Choose An Option:", "New Custom Entry"]
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
        } else if row == pickerBottles.count-1 {
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
        } else {
            nameLabel.alpha = 1
            nameInput.alpha = 0
            nameCustome.alpha = 1
            nameCustome.text = pickerBottles[row]
            
            volumeLabel.alpha = 1
            volumeSlider.alpha = 0
            volumeReadOut.alpha = 0
            volumeCustome.alpha = 1
            volumeCustome.text = pickerBottles[row]
            
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
        nameInput.text = ""
    }
    
    @IBAction func addDrink(_ sender: Any) {
        // log that the drink was added
    }
    
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
        
        guard let volumeToSave = volumeReadOut.text else {
            return
        }
        
        pickerBottles.insert(nameToSave + " -> " + volumeToSave + " oz", at: pickerBottles.count-1)
        reloadView()
        bottlePicker.selectRow(pickerBottles.count-2, inComponent: 0, animated: true)
        pickerView(bottlePicker, didSelectRow: pickerBottles.count-2, inComponent: 0)
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
    
    @IBAction func editDrink(_ sender: Any) {
    }
    
    @IBAction func deleteDrink(_ sender: Any) {
    }
    
    @IBAction func customeValueSliderChanged(_ sender: UISlider) {
        let currentValue = round(sender.value / 0.5) * 0.5
        volumeReadOut.text = "\(currentValue)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadView()
    }
    
}
