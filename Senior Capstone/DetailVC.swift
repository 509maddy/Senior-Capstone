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
        
        if (foodItem?.fruitServings != 0) {
            fruitLabel.text = "\((foodItem?.fruitServings)!)"
        } else if (foodItem?.fruitServings == 0) {
            fruitLabel.text = " "
        } else if (foodItem?.proteinServings != 0) {
            proteinLabel.text = "\((foodItem?.proteinServings)!)"
        } else if (foodItem?.proteinServings == 0) {
            proteinLabel.text = " "
        } else if (foodItem?.vegServings != 0) {
            vegLabel.text = "\((foodItem?.vegServings)!)"
        } else if (foodItem?.vegServings == 0) {
            vegLabel.text = " "
        } else if (foodItem?.grainServings != 0) {
            grainsLabel.text = "\((foodItem?.grainServings)!)"
        } else if (foodItem?.grainServings == 0) {
            grainsLabel.text = " "
        } else if (foodItem?.dairyServings != 0) {
            dairyLabel.text = "\((foodItem?.dairyServings)!)"
        } else if (foodItem?.dairyServings == 0) {
            dairyLabel.text = " "
        }
    }
}
