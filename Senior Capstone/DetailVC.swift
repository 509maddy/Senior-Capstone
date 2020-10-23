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
    
    @IBOutlet weak var fruit : UILabel!
    @IBOutlet weak var protein : UILabel!
    @IBOutlet weak var veg : UILabel!
    @IBOutlet weak var grain : UILabel!
    @IBOutlet weak var dairy : UILabel!
    
    @IBOutlet weak var FruitHeight: NSLayoutConstraint!
    var foodItem : FoodRecord?
    
    
    @IBOutlet weak var fruitTop: NSLayoutConstraint!
    
    @IBOutlet weak var fruitServingsConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "\((foodItem?.name)!)"
        
        // fruit checks
        if (foodItem?.fruitServings != 0) {
            fruitLabel.text = "\((foodItem?.fruitServings)!)"
        } else if (foodItem?.fruitServings == 0) {
            FruitHeight.constant = 0
            fruitServingsConstraint.constant = 0
            fruitTop.constant = 0
            
        }
        
        // protein checks
        if (foodItem?.proteinServings != 0) {
            proteinLabel.text = "\((foodItem?.proteinServings)!)"
        } else if (foodItem?.proteinServings == 0) {
            proteinLabel.text = " "
            protein.text = " "
        }
        
        // veg checks
        if (foodItem?.vegServings != 0) {
            vegLabel.text = "\((foodItem?.vegServings)!)"
        } else if (foodItem?.vegServings == 0) {
            vegLabel.text = " "
            veg.text = " "
        }
        
        // grain checks
        if (foodItem?.grainServings != 0) {
            grainsLabel.text = "\((foodItem?.grainServings)!)"
        } else if (foodItem?.grainServings == 0) {
            grainsLabel.text = " "
            grain.text = " "
        }
        
        // dairy check
        if (foodItem?.dairyServings != 0) {
            dairyLabel.text = "\((foodItem?.dairyServings)!)"
        } else if (foodItem?.dairyServings == 0) {
            dairyLabel.text = " "
            dairy.text = " "
        }
    }
}
