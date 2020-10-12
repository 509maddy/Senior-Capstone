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

    @IBAction func gSliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
            
        gLabel.text = "\(currentValue)"
    }
    
    @IBAction func fSliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
            
        fLabel.text = "\(currentValue)"
    }
    
    @IBAction func vSliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
            
        vLabel.text = "\(currentValue)"
    }
    
    @IBAction func pSliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
            
        pLabel.text = "\(currentValue)"
    }
    
    @IBAction func dSliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
            
        dLabel.text = "\(currentValue)"
    }
}

