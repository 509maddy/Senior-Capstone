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

    // creating each pie chart
    var fruitChart = PieChartView()
    var meatChart = PieChartView()
    var grainsChart = PieChartView()
    var dairyChart = PieChartView()
    var vegChart = PieChartView()
    
    // connecting to each view
    @IBOutlet weak var fruit: UIView!
    @IBOutlet weak var meat: UIView!
    @IBOutlet weak var dairy: UIView!
    @IBOutlet weak var grains: UIView!
    @IBOutlet weak var veg: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fruitChart.delegate = self
        meatChart.delegate = self
        grainsChart.delegate = self
        dairyChart.delegate = self
        vegChart.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // adding the location
        fruitChart.frame = CGRect(x:0, y:0, width: fruit.frame.size.width, height: fruit.frame.size.width)
        meatChart.frame = CGRect(x:0, y:0, width: meat.frame.size.width, height: meat.frame.size.width)
        dairyChart.frame = CGRect(x:0, y:0, width: dairy.frame.size.width, height: dairy.frame.size.width)
        grainsChart.frame = CGRect(x:0, y:0, width: grains.frame.size.width, height: grains.frame.size.width)
        vegChart.frame = CGRect(x:0, y:0, width: veg.frame.size.width, height: veg.frame.size.width)
        
        // placing in center of view
        fruitChart.center = fruit.center
        meatChart.center = meat.center
        grainsChart.center = grains.center
        dairyChart.center = dairy.center
        vegChart.center = veg.center
        
        // adding to view
        view.addSubview(fruitChart)
        view.addSubview(meatChart)
        view.addSubview(grainsChart)
        view.addSubview(dairyChart)
        view.addSubview(vegChart)
        
        // creating dummy data
        var entries = [ChartDataEntry]()
        
        for x in 0..<10 {
            entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
        }
        let set = PieChartDataSet(entries : entries)
        set.colors = ChartColorTemplates.colorful()
        let data = PieChartData(dataSet: set)
        
        // adding dummy data to each pie chart
        fruitChart.data = data
        meatChart.data = data
        grainsChart.data = data
        dairyChart.data = data
        vegChart.data = data
    }
}
