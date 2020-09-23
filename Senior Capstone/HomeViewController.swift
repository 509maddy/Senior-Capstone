//
//  HomeViewController.swift
//  Senior Capstone
//
//  Created by Ally Dinhofer on 9/20/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import UIKit
import Charts

class HomeViewController: UIViewController, ChartViewDelegate {

    var pieChart1 = PieChartView()
    var pieChart2 = PieChartView()
    
    @IBOutlet weak var fruit: UIView!
    
    @IBOutlet weak var meat: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart1.delegate = self
        pieChart2.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pieChart1.frame = CGRect(x:0, y:0, width: fruit.frame.size.width, height: fruit.frame.size.width)
        pieChart2.frame = CGRect(x:0, y:0, width: meat.frame.size.width, height: meat.frame.size.width)
        pieChart1.center = fruit.center
        pieChart2.center = meat.center
        view.addSubview(pieChart1)
        view.addSubview(pieChart2)
        
        var entries = [ChartDataEntry]()
        
        for x in 0..<10 {
            entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
        }
        let set = PieChartDataSet(entries : entries)
        set.colors = ChartColorTemplates.colorful()
        let data = PieChartData(dataSet: set)
        pieChart1.data = data
        pieChart2.data = data
    }
    

   

}
