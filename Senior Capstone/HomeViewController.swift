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
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataHeight: NSLayoutConstraint!

    @IBOutlet weak var fruitPieChartView: PieChartView!
    @IBOutlet weak var fruitPieChartHeight: NSLayoutConstraint!
    @IBOutlet weak var fruitLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var fruitPaddingHeight: NSLayoutConstraint!
    @IBOutlet weak var fruitDividerHeight: NSLayoutConstraint!

    @IBOutlet weak var vegetablePieChartView: PieChartView!
    @IBOutlet weak var vegetablePieChartHeight: NSLayoutConstraint!
    @IBOutlet weak var vegetableLabelHight: NSLayoutConstraint!
    @IBOutlet weak var vegetablePaddingHeight: NSLayoutConstraint!
    @IBOutlet weak var vegetableDividerHeight: NSLayoutConstraint!

    @IBOutlet weak var meatPieChartView: PieChartView!
    @IBOutlet weak var meatPieChartHeight: NSLayoutConstraint!
    @IBOutlet weak var meatLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var meatPaddingHeight: NSLayoutConstraint!
    @IBOutlet weak var meatDividerHeight: NSLayoutConstraint!

    @IBOutlet weak var dairyPieChartView: PieChartView!
    @IBOutlet weak var diaryPieChartHeight: NSLayoutConstraint!
    @IBOutlet weak var dairyLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var dairyPaddingHeight: NSLayoutConstraint!
    @IBOutlet weak var dairyDividerHeight: NSLayoutConstraint!

    @IBOutlet weak var grainPieChartView: PieChartView!
    @IBOutlet weak var grainPieChartHeight: NSLayoutConstraint!
    @IBOutlet weak var grainLabelHeight: NSLayoutConstraint!

    var goalFruit: Double = 0.0
    var goalDairy: Double = 0.0
    var goalGrain: Double = 0.0
    var goalProtein: Double = 0.0
    var goalVeg: Double = 0.0
    @IBOutlet weak var navDate: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(DailyState.todaysDate)
        DailyState.refreshGoals()
        navDate.title = DailyState.todaysDate
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadPieCharts()
        loadViews()
        hideViews()
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
        customPieChart(dataEntries: &proteinChartEntries, pieChartView: meatPieChartView, goalServings: goalProtein, totalServings: totalProteinServings)
        customPieChart(dataEntries: &vegChartEntries, pieChartView: vegetablePieChartView, goalServings: goalVeg, totalServings: totalVegServings)
    }

    func updateGoals(){
        goalFruit = DailyState.fruitGoal
        goalDairy = DailyState.dairyGoal
        goalGrain = DailyState.grainGoal
        goalProtein = DailyState.proteinGoal
        goalVeg = DailyState.vegetableGoal
    }

    func loadViews() {
        fruitPieChartHeight.constant = 300.0
        fruitLabelHeight.constant = 40.0
        fruitPaddingHeight.constant = 15.0
        fruitDividerHeight.constant = 3.0
        vegetablePieChartHeight.constant = 300.0
        vegetableLabelHight.constant = 40.0
        vegetablePaddingHeight.constant = 15.0
        vegetableDividerHeight.constant = 3.0
        meatPieChartHeight.constant = 300.0
        meatLabelHeight.constant = 40.0
        meatPaddingHeight.constant = 15.0
        meatDividerHeight.constant = 3.0
        diaryPieChartHeight.constant = 300.0
        dairyLabelHeight.constant = 40.0
        dairyPaddingHeight.constant = 15.0
        dairyDividerHeight.constant = 3.0
        grainPieChartHeight.constant = 300.0
        grainLabelHeight.constant = 40.0
        noDataHeight.constant = 0.0
        noDataView.isHidden = true
    }

    func hideViews() {
        var visible:[Bool] = [true, true, true, true, true]

        if goalFruit == 0.0 {
            fruitPieChartHeight.constant = 0.0
            fruitLabelHeight.constant = 0.0
            fruitPaddingHeight.constant = 0.0
            fruitDividerHeight.constant = 0.0
            visible[0] = false
        }
        if goalVeg == 0.0 {
            vegetablePieChartHeight.constant = 0.0
            vegetableLabelHight.constant = 0.0
            vegetablePaddingHeight.constant = 0.0
            vegetableDividerHeight.constant = 0.0
            visible[1] = false
        }
        if goalProtein == 0.0 {
            meatPieChartHeight.constant = 0.0
            meatLabelHeight.constant = 0.0
            meatPaddingHeight.constant = 0.0
            meatDividerHeight.constant = 0.0
            visible[2] = false
        }
        if goalDairy == 0.0 {
            diaryPieChartHeight.constant = 0.0
            dairyLabelHeight.constant = 0.0
            dairyPaddingHeight.constant = 0.0
            dairyDividerHeight.constant = 0.0
            visible[3] = false
        }
        if goalGrain == 0.0 {
            grainPieChartHeight.constant = 0.0
            grainLabelHeight.constant = 0.0
            visible[4] = false
        }

        var index = 4
        var firstTrue = -1
        while index >= 0 && firstTrue == -1 {
            if visible[index] == true {
                firstTrue = index
            }
            index = index - 1
        }

        switch firstTrue {
        case -1:
            noDataView.isHidden = false
            noDataHeight.constant = 500.0
        case 0:
            fruitPaddingHeight.constant = 0.0
            fruitDividerHeight.constant = 0.0
        case 1:
            vegetablePaddingHeight.constant = 0.0
            vegetableDividerHeight.constant = 0.0
        case 2:
            meatPaddingHeight.constant = 0.0
            meatDividerHeight.constant = 0.0
        case 3:
            dairyPaddingHeight.constant = 0.0
            dairyDividerHeight.constant = 0.0
        default:
            break
        }
    }
    
    private func customPieChart(dataEntries: inout [ChartDataEntry], pieChartView: PieChartView, goalServings: Double, totalServings: Double) {
        // 1. Figure out remaining
        let remaining = goalServings - totalServings
        var hasRemainder: Bool = false
        
        if remaining > 0{
            let remainingEntries = PieChartDataEntry(value: remaining, label: "Remaining")
            dataEntries.append(remainingEntries)
            hasRemainder = true
        }
        
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
