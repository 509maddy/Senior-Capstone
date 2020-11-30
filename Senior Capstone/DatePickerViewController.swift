//
//  DatePickerViewController.swift
//  Senior Capstone
//
//  Created by Tommy Moawad on 10/22/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import UIKit

/**
 The View Controller for the screen that enables a user to change the global date
 */
class DatePickerViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func registerDateChange(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let strDate = dateFormatter.string(from: datePicker.date)
        DailyState.updateTodaysDate(todaysDate: strDate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let strDate = dateFormatter.date(from: DailyState.todaysDate)
        datePicker.date = strDate!
    }
    
    // Triggers the parent controller to update the date label
    override func viewDidDisappear(_ animated: Bool) {
        ModalTransitionMediator.instance.sendPopoverDismissed(modelChanged: true)
    }

}
