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

class AddWaterViewController: UIViewController, UIPickerViewDelegate, ModalTransitionListener {
    
    @IBOutlet weak var customeNameLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var customeNameInputHeight: NSLayoutConstraint!
    @IBOutlet weak var customeOuncesLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var customeOuncesSliderHeight: NSLayoutConstraint!
    @IBOutlet weak var customeOuncesValueHeight: NSLayoutConstraint!
    
    @IBOutlet weak var savedNameLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var savedNameHeight: NSLayoutConstraint!
    @IBOutlet weak var savedOuncesLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var savedOuncesValueHeight: NSLayoutConstraint!
    @IBOutlet weak var savedValueUpper1: NSLayoutConstraint!
    @IBOutlet weak var savedValueUpper2: NSLayoutConstraint!
    

    @IBOutlet weak var addButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var add_save_buttonBetween: NSLayoutConstraint!
    @IBOutlet weak var saveButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var save_edit_buttonBetween: NSLayoutConstraint!
    @IBOutlet weak var editButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var edit_delete_buttonBetween: NSLayoutConstraint!
    @IBOutlet weak var deleteButtonHeight: NSLayoutConstraint!
    
    func popoverDismissed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        reloadView()
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    
    func reloadView() {
        collapseSavedValues()
    }
    
    func collapseCustomValues() {
        
    }
    
    @IBAction func newCustomAmount(_ sender: Any) {
        expandSavedValues()
    }
    
    func collapseSavedValues() {
        savedNameLabelHeight.constant = 0
        savedNameHeight.constant = 0
        savedOuncesLabelHeight.constant = 0
        savedOuncesValueHeight.constant = 0
        savedValueUpper1.constant = 0
        savedValueUpper2.constant = 0
    }
    
    func expandSavedValues() {
        savedNameLabelHeight.constant = 21
        savedNameHeight.constant = 21
        savedOuncesLabelHeight.constant = 21
        savedOuncesValueHeight.constant = 21
        savedValueUpper1.constant = 25
        savedValueUpper2.constant = 25
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadView()
        ModalTransitionMediator.instance.setListener(listener: self)
    }
    
}
