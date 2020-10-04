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

    @IBOutlet weak var fruitPieChartView: PieChartView!
    @IBOutlet weak var meatPieChartView: PieChartView!
    @IBOutlet weak var vegetablePieChartView: PieChartView!
    @IBOutlet weak var grainPieChartView: PieChartView!
    @IBOutlet weak var dairyPieChartView: PieChartView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        customizeChart(group: "fruit", pieChartView: fruitPieChartView)
        customizeChart(group: "protein", pieChartView: meatPieChartView)
        customizeChart(group: "vegetable", pieChartView: vegetablePieChartView)
        customizeChart(group: "grain", pieChartView: grainPieChartView)
        customizeChart(group: "dairy", pieChartView: dairyPieChartView)
    }

    func customizeChart(group: String, pieChartView: PieChartView) {

        // 1. Set ChartDataEntry
        var foodRecords = [FoodRecord]()
        let predicate = NSPredicate(format: "date == %@ AND group == %@", DailyState.todaysDate, group)
        foodRecords = DatabaseFunctions.retriveFoodRecordOnCondition(predicate: predicate)

        var dataEntries: [ChartDataEntry] = []
        var totalServings = 0.0
        for i in 0..<foodRecords.count {
            let dataEntry = PieChartDataEntry(value: foodRecords[i].value(forKeyPath: "servings") as! Double, label: foodRecords[i].value(forKeyPath: "name") as? String)
            dataEntries.append(dataEntry)
            totalServings += foodRecords[i].value(forKeyPath: "servings") as! Double
        }

        if (foodRecords.count != 0) {
            // value should be goalServings - total servings not 20 - totalServings
            let dataEntry2 = PieChartDataEntry(value: 20 - totalServings, label: "Remaining")
            dataEntries.append(dataEntry2)
        } else {
            // value should be goalServings not 20
            let dataEntry3 = PieChartDataEntry(value: 20, label: "Remaining")
            dataEntries.append(dataEntry3)
        }

        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataEntries.count)

        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
         format.numberStyle = .none
        let formatter = DefaultValueFormatter(decimals: 2)
         pieChartData.setValueFormatter(formatter)

        // 4. Assign it to the chart’s data
        pieChartView.data = pieChartData
        pieChartView.legend.enabled = false
        pieChartView.rotationEnabled = false
        pieChartView.holeRadiusPercent = 0.4
        pieChartView.transparentCircleRadiusPercent = 0.5
    }

    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      return colors
    }
}

