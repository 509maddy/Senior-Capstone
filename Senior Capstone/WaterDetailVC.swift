//
//  WaterDetailVC.swift
//  Senior Capstone
//
//  Created by Emily Howell on 11/6/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import UIKit

class WaterDetailVC: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // each cell will hold a different entry that conforms to the FoodItem entity
    var waterRecords = [WaterRecord]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
