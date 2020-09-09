//
//  ViewController.swift
//  Senior Capstone
//
//  Created by Madison Lucas on 9/2/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    // these reference the labels and datepicker on the settings scene in storyboard
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var DailyStateDateLabel: UILabel!

    @IBAction func datePickerChanged(_ sender: Any) {

        // date formatter is a Swift library, short means month/day/year
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short

        // by saying datePicker.date, I am asking the date picker to not be specific
        // enough to specify the time as well
        let strDate = dateFormatter.string(from: datePicker.date)

        // here I am updating the static field todaysDate from DailyState
        DailyState.updateTodaysDate(todaysDate: strDate)

        // just updating the labels on the settings scene in Storyboard
        dateLabel.text = strDate
        DailyStateDateLabel.text = strDate
    }
}

