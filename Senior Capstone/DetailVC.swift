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
    @IBOutlet weak var fruitLabel : UILabel!
    @IBOutlet weak var proteinLabel : UILabel!
    @IBOutlet weak var vegLabel : UILabel!
    @IBOutlet weak var grainsLabel : UILabel!
    @IBOutlet weak var dairyLabel : UILabel!
    
    var foodItem : FoodRecord?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "\((foodItem?.name)!)"
        fruitLabel.text = "\((foodItem?.fruitServings)!)"
        proteinLabel.text = "\((foodItem?.proteinServings)!)"
        vegLabel.text = "\((foodItem?.vegServings)!)"
        grainsLabel.text = "\((foodItem?.grainServings)!)"
        dairyLabel.text = "\((foodItem?.dairyServings)!)"
    }
}
