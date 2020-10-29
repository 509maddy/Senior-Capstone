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

class AddWaterViewController: UIViewController, UIPickerViewDelegate{
    
    var customeInput: Bool = false
    var savedInput: Bool = false
    var numberOfSaved:Int = 0
    
    @IBOutlet weak var addCustomAmountButton: UIButton!
    @IBOutlet weak var addCustomAmountLabel: UILabel!
    @IBOutlet weak var addCustomAmountAlignment: NSLayoutConstraint!
    
    @IBOutlet weak var savedButton1: UIButton!
    @IBOutlet weak var savedLabel1: UILabel!

    @IBOutlet weak var savedButton2: UIButton!
    @IBOutlet weak var savedLabel2: UILabel!
    
    @IBOutlet weak var savedButton3: UIButton!
    @IBOutlet weak var savedLabel3: UILabel!
    
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
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    
    func reloadView() {
        self.view.layoutIfNeeded()
        collapseSavedValues()
        
        savedButton1.isHidden = true
        savedButton2.isHidden = true
        savedButton3.isHidden = true
        savedLabel1.isHidden = true
        savedLabel2.isHidden = true
        savedLabel3.isHidden = true
        addCustomAmountAlignment.constant = 0
    }
    
    func collapseCustomValues() {
        
    }
    
    @IBAction func newCustomAmount(_ sender: Any) {
        expandCustomeValues()
    }
    
    @IBAction func savedCustomAmount(_ sender: Any) {
        
    }
    
    @IBAction func addDrink(_ sender: Any) {
    }
    
    @IBAction func saveDrink(_ sender: Any) {
        let savedButtons:[UIButton] = [savedButton1, savedButton2, savedButton3]
        let savedLabels:[UILabel] = [savedLabel1, savedLabel2, savedLabel3]
        
        if numberOfSaved < 3 {
            numberOfSaved += 1
            addCustomAmountAlignment.constant = CGFloat(39*numberOfSaved)
            for newSave in 0...2 {
                if savedButtons[newSave].isHidden {
                    savedButtons[newSave].isHidden = false
                    savedLabels[newSave].isHidden = false
                    savedLabels[newSave].text = nameInput.text
                    break
                }
            }
        }
    }
    
    @IBAction func editDrink(_ sender: Any) {
    }
    
    @IBAction func deleteDrink(_ sender: Any) {
    }
    
    
    func collapseSavedValues() {
        headerLabel.alpha = 0
        nameLabel.alpha = 0
        nameInput.alpha = 0
        nameCustome.alpha = 0
        
        volumeLabel.alpha = 0
        volumeSlider.alpha = 0
        volumeReadOut.alpha = 0
        volumeCustome.alpha = 0
        
        addButton.alpha = 0
        saveButton.alpha = 0
        editButton.alpha = 0
        deleteButton.alpha = 0
    }
    
    func expandCustomeValues() {
        headerLabel.text = "Add Custom Amount"
        headerLabel.alpha = 1
        nameLabel.alpha = 1
        nameInput.alpha = 1
        nameCustome.alpha = 0
        
        volumeLabel.alpha = 1
        volumeSlider.alpha = 1
        volumeReadOut.alpha = 1
        volumeCustome.alpha = 0
        
        addButton.alpha = 1
        saveButton.alpha = 1
        editButton.alpha = 0
        deleteButton.alpha = 0
    }
    
    @IBAction func customeValueSliderChanged(_ sender: UISlider) {
        let currentValue = round(sender.value / 0.5) * 0.5
        volumeReadOut.text = "\(currentValue)"
    }
    
    func expandSavedValues() {
        headerLabel.text = "Add Saved Amount"
        headerLabel.alpha = 1
        nameLabel.alpha = 1
        nameInput.alpha = 0
        nameCustome.alpha = 1
        
        volumeLabel.alpha = 1
        volumeSlider.alpha = 0
        volumeReadOut.alpha = 0
        volumeCustome.alpha = 1
        
        addButton.alpha = 1
        saveButton.alpha = 0
        editButton.alpha = 1
        deleteButton.alpha = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadView()
    }
    
}
