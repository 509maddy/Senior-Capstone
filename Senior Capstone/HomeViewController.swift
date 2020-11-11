import UIKit
import Charts

// a class to control the home screen functions
class HomeViewController: UIViewController, ChartViewDelegate, ModalTransitionListener {
    
    // unsure what these are ********
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataHeight: NSLayoutConstraint!

    // references to fruit pie chart and constraints
    @IBOutlet weak var fruitPieChartView: PieChartView!
    @IBOutlet weak var fruitPieChartHeight: NSLayoutConstraint!
    @IBOutlet weak var fruitLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var fruitPaddingHeight: NSLayoutConstraint!
    @IBOutlet weak var fruitDividerHeight: NSLayoutConstraint!
    @IBOutlet weak var fruitCompletedCheck: UIImageView!
    
    // references to vegetable pie chart and constraints
    @IBOutlet weak var vegetablePieChartView: PieChartView!
    @IBOutlet weak var vegetablePieChartHeight: NSLayoutConstraint!
    @IBOutlet weak var vegetableLabelHight: NSLayoutConstraint!
    @IBOutlet weak var vegetablePaddingHeight: NSLayoutConstraint!
    @IBOutlet weak var vegetableDividerHeight: NSLayoutConstraint!
    @IBOutlet weak var vegetableCompletedCheck: UIImageView!
    
    // references to protein pie chart and constraints
    @IBOutlet weak var meatPieChartView: PieChartView!
    @IBOutlet weak var meatPieChartHeight: NSLayoutConstraint!
    @IBOutlet weak var meatLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var meatPaddingHeight: NSLayoutConstraint!
    @IBOutlet weak var meatDividerHeight: NSLayoutConstraint!
    @IBOutlet weak var meatCompletedCheck: UIImageView!

    // references to dairy pie chart and constraints
    @IBOutlet weak var dairyPieChartView: PieChartView!
    @IBOutlet weak var diaryPieChartHeight: NSLayoutConstraint!
    @IBOutlet weak var dairyLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var dairyPaddingHeight: NSLayoutConstraint!
    @IBOutlet weak var dairyDividerHeight: NSLayoutConstraint!
    @IBOutlet weak var dairyCompletedCheck: UIImageView!

    // references to grain pie chart and constraints
    @IBOutlet weak var grainPieChartView: PieChartView!
    @IBOutlet weak var grainPieChartHeight: NSLayoutConstraint!
    @IBOutlet weak var grainLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var grainCompletedCheck: UIImageView!
    @IBOutlet weak var grainPaddingHeight: NSLayoutConstraint!
    @IBOutlet weak var grainDividerHeight: NSLayoutConstraint!

    // references to water pie chart and constraints
    @IBOutlet weak var waterPieChartView: PieChartView!
    @IBOutlet weak var waterPieChartHeight: NSLayoutConstraint!
    @IBOutlet weak var waterLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var waterVolTotal: UIButton!

    // represents the goals for each food group
    var goalFruit: Double = 0.0
    var goalDairy: Double = 0.0
    var goalGrain: Double = 0.0
    var goalProtein: Double = 0.0
    var goalVeg: Double = 0.0
    var isAnyWater: Bool = false
    
    // reference to the date
    @IBOutlet weak var navDate: UIBarButtonItem!
    
    // the function that's called when the page is selected
    override func viewDidLoad() {
        super.viewDidLoad()
        DailyState.refreshGoals()
        DailyState.updateNavDate(navDate: navDate)
    }

    // reloads the view when its selected
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadView()
        ModalTransitionMediator.instance.setListener(listener: self)
    }
    
    // function called when the date picker popover is dismissed
    func popoverDismissed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        reloadView()
    }
    
    // a method to reload the view
    func reloadView() {
        super.viewWillAppear(true)
        DailyState.updateNavDate(navDate: navDate)
        loadPieCharts()
        isAnyWater = false
        loadWater()
        loadViews()
        hideViews()
    }
    
    // a method to load the pie charts and update the goals
    func loadPieCharts() {
        updateGoals()

        // Set ChartDataEntry
        var foodRecords = [FoodRecord]()
        let predicate = NSPredicate(format: "date == %@", DailyState.todaysDateAsDate as NSDate)
        foodRecords = DatabaseFunctions.retriveFoodRecordOnCondition(predicate: predicate)

        var fruitChartEntries: [ChartDataEntry] = []
        var dairyChartEntries: [ChartDataEntry] = []
        var grainChartEntries: [ChartDataEntry] = []
        var proteinChartEntries: [ChartDataEntry] = []
        var vegChartEntries: [ChartDataEntry] = []

        var totalFruitServings: Double = 0.0
        var totalDairyServings: Double = 0.0
        var totalGrainServings: Double = 0.0
        var totalProteinServings: Double = 0.0
        var totalVegServings: Double = 0.0

        // adds the information for each food item
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
            
            // adds the food items to their proper pie charts
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
        
        // adds the data to the pie charts
        customPieChart(dataEntries: &fruitChartEntries, pieChartView: fruitPieChartView, goalServings: goalFruit, totalServings: totalFruitServings)
        customPieChart(dataEntries: &dairyChartEntries, pieChartView: dairyPieChartView, goalServings: goalDairy, totalServings: totalDairyServings)
        customPieChart(dataEntries: &grainChartEntries, pieChartView: grainPieChartView, goalServings: goalGrain, totalServings: totalGrainServings)
        customPieChart(dataEntries: &proteinChartEntries, pieChartView: meatPieChartView, goalServings: goalProtein, totalServings: totalProteinServings)
        customPieChart(dataEntries: &vegChartEntries, pieChartView: vegetablePieChartView, goalServings: goalVeg, totalServings: totalVegServings)
        
        // checks the progress towards the goal
        progressCheck(goalServings: goalFruit, actualServings: totalFruitServings, checkMark: fruitCompletedCheck)
        progressCheck(goalServings: goalVeg, actualServings: totalVegServings, checkMark: vegetableCompletedCheck)
        progressCheck(goalServings: goalProtein, actualServings: totalProteinServings, checkMark: meatCompletedCheck)
        progressCheck(goalServings: goalDairy, actualServings: totalDairyServings, checkMark: dairyCompletedCheck)
        progressCheck(goalServings: goalGrain, actualServings: totalGrainServings, checkMark: grainCompletedCheck)
    }

    // a function to load the water pie chart
    func loadWater() {
        var waterRecords = [WaterRecord]()
        let predicate = NSPredicate(format: "date == %@", DailyState.todaysDateAsDate as NSDate)
        waterRecords = DatabaseFunctions.retriveWaterRecordOnCondition(predicate: predicate)

        var waterChartEntries: [ChartDataEntry] = []
        var totalWaterServings: Double = 0.0
        for i in 0..<waterRecords.count {
            let label = waterRecords[i].value(forKeyPath: "name") as? String
            let volume = waterRecords[i].value(forKeyPath: "volume") as! Double

            totalWaterServings += volume

            if (volume > 0){
                let dataEntry = PieChartDataEntry(value: volume, label: label)
                waterChartEntries.append(dataEntry)
                isAnyWater = true
            }
        }
        waterVolTotal.setTitle(String(format: "%.1f oz", totalWaterServings), for: .normal)
            
        customPieChart(dataEntries: &waterChartEntries, pieChartView: waterPieChartView, goalServings: 0, totalServings: totalWaterServings)
    }

    // a method to update the goals with the backend data
    func updateGoals(){
        goalFruit = DailyState.fruitGoal
        goalDairy = DailyState.dairyGoal
        goalGrain = DailyState.grainGoal
        goalProtein = DailyState.proteinGoal
        goalVeg = DailyState.vegetableGoal
    }

    // a method to load the views of each pie chart
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
        grainPaddingHeight.constant = 15.0
        grainDividerHeight.constant = 3.0
        waterPieChartHeight.constant = 300.0
        waterLabelHeight.constant = 40.0
        noDataHeight.constant = 0.0
        noDataView.isHidden = true
    }

    // a function to hide a pie chart if its goal is 0
    func hideViews() {
        var visible:[Bool] = [true, true, true, true, true, true]

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
            grainPaddingHeight.constant = 0.0
            grainDividerHeight.constant = 0.0
            visible[4] = false
        }
        if isAnyWater == false {
            waterPieChartHeight.constant = 0.0
            waterLabelHeight.constant = 0.0
            visible[5] = false
        }
        var index = 5
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
        case 4:
            grainPaddingHeight.constant = 0.0
            grainDividerHeight.constant = 0.0
        default:
            break
        }
    }
    
    // a funciton to create the custom pie chart
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

    // a function to set the colors of the pie chart to use the user selected theme
    private func colorsOfCharts(numbersOfColor: Int, hasRemainder: Bool) -> [UIColor] {
      var colors: [UIColor] = []
        //assign colors to the slices
        if numbersOfColor > 1 {
            for sliceNumber in 0..<(numbersOfColor-1) {
                colors.append(ThemeManager.pieChartColor(sliceNumber: sliceNumber))
            }
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
    
    // a function to check the progress towards the daily goal
    func progressCheck(goalServings: Double, actualServings: Double, checkMark: UIImageView){
        
        if actualServings > goalServings+2 {
            checkMark.image = UIImage(named: "significantly_above_goal")
        } else if actualServings > goalServings {
            checkMark.image = UIImage(named: "slightly_above_goal")
        } else if actualServings == goalServings {
            checkMark.image = UIImage(named: "completed_goal")
        } else {
            checkMark.image = UIImage(named: "under_goal")
        }
    }
}
