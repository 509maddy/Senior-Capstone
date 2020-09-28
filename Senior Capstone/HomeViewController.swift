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

    let players = ["Ozil", "Ramsey", "Laca", "Auba", "Xhaka", "Torreira"]
    let goals = [6, 8, 26, 30, 8, 10]

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeChart(dataPoints: players, values: goals.map{ Double($0) })
    }

    func customizeChart(dataPoints: [String], values: [Double]) {
      // TO-DO: customize the chart here

        // 1. Set ChartDataEntry
        var foodRecords = [FoodRecord]()
        let predicate = NSPredicate(format: "date == %@ AND group == %@", DailyState.todaysDate, "Fruit")
        foodRecords = DatabaseFunctions.retriveFoodRecordOnCondition(predicate: predicate)

        var dataEntries: [ChartDataEntry] = []

        for i in 0..<dataPoints.count {
          let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
          dataEntries.append(dataEntry)
        }

        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)

        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
         format.numberStyle = .none
         let formatter = DefaultValueFormatter(formatter: format)
         pieChartData.setValueFormatter(formatter)

        // 4. Assign it to the chart’s data
        fruitPieChartView.data = pieChartData
        fruitPieChartView.legend.enabled = false
        fruitPieChartView.rotationEnabled = false
        fruitPieChartView.holeRadiusPercent = 0.4
        fruitPieChartView.transparentCircleRadiusPercent = 0.5
        meatPieChartView.data = pieChartData
        meatPieChartView.legend.enabled = false
        meatPieChartView.rotationEnabled = false
        meatPieChartView.holeRadiusPercent = 0.4
        meatPieChartView.transparentCircleRadiusPercent = 0.5
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
