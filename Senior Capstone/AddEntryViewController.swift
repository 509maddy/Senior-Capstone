//
//  AddEntryViewController.swift
//  Senior Capstone
//
//  Created by Emily Howell on 10/28/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AddEntryViewController: UIViewController, UIPickerViewDelegate, ModalTransitionListener {
    
    @IBOutlet weak var navDate: UIBarButtonItem!
    @IBOutlet weak var addFoodView: UIView!
    @IBOutlet weak var addWaterView: UIView!
    
    var waterController: AddWaterViewController? = nil
    var foodController: AddFoodViewController? = nil
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let waterController = segue.destination as? AddWaterViewController {
            self.waterController = waterController
        }
        if let foodController = segue.destination as? AddFoodViewController {
            self.foodController = foodController
        }
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    
    func popoverDismissed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        reloadView()
        ModalTransitionMediator.instance.setListener(listener: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadView()
        ModalTransitionMediator.instance.setListener(listener: self)
    }

    func reloadView() {
        DailyState.updateNavDate(navDate: navDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        DailyState.updateNavDate(navDate: navDate)
        
        addFoodView.alpha = 1
        addWaterView.alpha = 0
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            addFoodView.alpha = 1
            addWaterView.alpha = 0
            self.view.endEditing(true)
            foodController?.reloadView()
        } else {
            addFoodView.alpha = 0
            addWaterView.alpha = 1
            self.view.endEditing(true)
            addWaterView.setNeedsDisplay()
            waterController?.reloadView()
        }
    }
        
}
