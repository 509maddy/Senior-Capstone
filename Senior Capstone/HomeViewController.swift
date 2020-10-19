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
        customizeChart(group: DailyState.GroupName.Fruit.rawValue, pieChartView: fruitPieChartView)
        customizeChart(group: DailyState.GroupName.Protein.rawValue, pieChartView: meatPieChartView)
        customizeChart(group: DailyState.GroupName.Vegetable.rawValue, pieChartView: vegetablePieChartView)
        customizeChart(group: DailyState.GroupName.Grain.rawValue, pieChartView: grainPieChartView)
        customizeChart(group: DailyState.GroupName.Dairy.rawValue, pieChartView: dairyPieChartView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DailyState.refreshGoals()
    }

    func customizeChart(group: String, pieChartView: PieChartView) {

        // 1. Set ChartDataEntry
        var foodRecords = [FoodRecord]()
        var hasRemainder: Bool
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

        hasRemainder = true //need to fix this line but I need the new reminder calculation code
        
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataEntries.count, hasRemainder: hasRemainder)

        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
         format.numberStyle = .none
        let formatter = DefaultValueFormatter(decimals: 2)
         pieChartData.setValueFormatter(formatter)
        pieChartData.setValueTextColor(ThemeManager.currentTheme().secondaryTextColor)

        // 4. Assign it to the chart’s data
        pieChartView.data = pieChartData
        pieChartView.legend.enabled = false
        pieChartView.entryLabelColor = ThemeManager.currentTheme().secondaryTextColor
        pieChartView.legend.textColor = ThemeManager.currentTheme().secondaryTextColor
        pieChartView.rotationEnabled = false
        pieChartView.holeRadiusPercent = 0.4
        pieChartView.transparentCircleRadiusPercent = 0.5
    }

    private func colorsOfCharts(numbersOfColor: Int, hasRemainder: Bool) -> [UIColor] {
      var colors: [UIColor] = []
        //assign colors to the slices
        for sliceNumber in 0..<(numbersOfColor-1) {
            colors.append(ThemeManager.pieChartColor(sliceNumber: sliceNumber))
        }
        
        //if there is a Remainder slice it should be in the base color
        if hasRemainder {
            colors.append(ThemeManager.currentTheme().baseColor)
        }
        else {
            colors.append(ThemeManager.pieChartColor(sliceNumber: numbersOfColor-1))
        }
      return colors
    }
}

