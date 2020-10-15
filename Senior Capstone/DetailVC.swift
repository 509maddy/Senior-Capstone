//
//  DetailVC.swift
//  Senior Capstone
//
//  Created by Ally Dinhofer on 10/14/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var groupLabel : UILabel!
    @IBOutlet weak var servingsLabel : UILabel!
    
    var foodItem : FoodRecord?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "\((foodItem?.name)!)"
        groupLabel.text = "\((foodItem?.group)!)"
        servingsLabel.text = "\((foodItem?.servings)!)"
    }
}
