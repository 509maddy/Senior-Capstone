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
    
    var goalFruit: Double = 0.0
    var goalDairy: Double = 0.0
    var goalGrain: Double = 0.0
    var goalProtein: Double = 0.0
    var goalVeg: Double = 0.0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadPieCharts()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateGoals(){
        DailyState.refreshGoals()
        goalFruit = DailyState.fruitGoal
        goalDairy = DailyState.dairyGoal
        goalGrain = DailyState.grainGoal
        goalProtein = DailyState.proteinGoal
        goalVeg = DailyState.vegetableGoal
    }

    func loadPieCharts() {
        updateGoals()

        // 1. Set ChartDataEntry
        var foodRecords = [FoodRecord]()
        let predicate = NSPredicate(format: "date == %@", DailyState.todaysDate)
        foodRecords = DatabaseFunctions.retriveFoodRecordOnCondition(predicate: predicate)

        var fruitChartEntries: [ChartDataEntry] = []
        var dairyChartEntries: [ChartDataEntry] = []
        var grainChartEntries: [ChartDataEntry] = []
        var proteinChartEntries: [ChartDataEntry] = []
        var vegChartEntries: [ChartDataEntry] = []

        
        var totalFruitServings = 0.0
        var totalDairyServings = 0.0
        var totalGrainServings = 0.0
        var totalProteinServings = 0.0
        var totalVegServings = 0.0

        for i in 0..<foodRecords.count {
            let label = foodRecords[i].value(forKeyPath: "name") as? String
            let fruit = foodRecords[i].value(forKeyPath: "fruitServings") as! Double
            let dairy = foodRecords[i].value(forKeyPath: "dairyServings") as! Double
            let grain = foodRecords[i].value(forKeyPath: "grainServings") as! Double
            let protein = foodRecords[i].value(forKeyPath: "proteinServings") as! Double
            let veg = foodRecords[i].value(forKeyPath: "vegServings") as! Double
            
            totalFruitServings += fruit
            totalDairyServings += dairy
            totalGrainServings += grain
            totalProteinServings += protein
            totalVegServings += veg
            
            if (fruit > 0){
                let dataEntry = PieChartDataEntry(value: fruit, label: label)
                fruitChartEntries.append(dataEntry)
            }
            if (dairy > 0){
                let dataEntry = PieChartDataEntry(value: dairy, label: label)
                dairyChartEntries.append(dataEntry)
            }
            if (grain > 0){
                let dataEntry = PieChartDataEntry(value: grain, label: label)
                grainChartEntries.append(dataEntry)
            }
            if (protein > 0){
                let dataEntry = PieChartDataEntry(value: protein, label: label)
                proteinChartEntries.append(dataEntry)
            }
            if (veg > 0){
                let dataEntry = PieChartDataEntry(value: veg, label: label)
                vegChartEntries.append(dataEntry)
            }
        }
        
        customPieChart(dataEntries: &fruitChartEntries, pieChartView: fruitPieChartView, goalServings: goalFruit, totalServings: totalFruitServings)
        customPieChart(dataEntries: &dairyChartEntries, pieChartView: dairyPieChartView, goalServings: goalDairy, totalServings: totalDairyServings)
        customPieChart(dataEntries: &grainChartEntries, pieChartView: grainPieChartView, goalServings: goalGrain, totalServings: totalGrainServings)
        customPieChart(dataEntries: &proteinChartEntries, pieChartView: vegetablePieChartView, goalServings: goalProtein, totalServings: totalProteinServings)
        customPieChart(dataEntries: &vegChartEntries, pieChartView: meatPieChartView, goalServings: goalVeg, totalServings: totalVegServings)
    }
    
    private func customPieChart( dataEntries: inout [ChartDataEntry], pieChartView: PieChartView, goalServings: Double, totalServings: Double) {
        // 1. Figure out remaining
        let remaining = goalServings - totalServings
        
        if remaining > 0{
            let remainingEntries = PieChartDataEntry(value: remaining, label: "Remaining")
            dataEntries.append(remainingEntries)
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

