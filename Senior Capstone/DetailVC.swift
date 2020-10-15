//
//  DetailVC.swift
//  Senior Capstone
//
//  Created by Ally Dinhofer on 10/14/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    var foodItem : FoodRecord?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = foodItem?.value(forKeyPath: "name") as? String
    }
}
