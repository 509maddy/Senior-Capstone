import Foundation
import UIKit
import CoreData

// a class to contain the functions used on the food view controller
class FoodViewController: UIViewController, UITableViewDelegate, ModalTransitionListener {
    
    // reference to the table
    @IBOutlet weak var tableView: UITableView!
    
    // reference to the date
    @IBOutlet weak var navDate: UIBarButtonItem!
    
    // reference to the app delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate;

    // each cell will hold a different entry that conforms to the FoodItem entity
    var foodRecords = [FoodRecord]()

    // reloads the data when we go to the screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadView()
        ModalTransitionMediator.instance.setListener(listener: self)
    }
    
    // reloads the view of the page
    func reloadView(){
        title = "Today's Food"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        loadSavedData()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        DailyState.updateNavDate(navDate: navDate)
    }
    
    // reloads the view of the page when the date picker popover is dismissed
    func popoverDismissed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        reloadView()
    }

    // loads the saved data for the current date
    func loadSavedData() {
        let predicate = NSPredicate(format: "date == %@", DailyState.todaysDateAsDate as NSDate)
        foodRecords = DatabaseFunctions.retriveFoodRecordOnCondition(predicate: predicate)
        tableView.reloadData()
    }
    
    // allows a selected cell to take you to the detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath : IndexPath) {
        if(indexPath.row == 0) {
            performSegue(withIdentifier: "showWaterDetail", sender: self)
        }
        else {
            performSegue(withIdentifier: "showDetail", sender: self)
        }
    }
    
}

extension FoodViewController: UITableViewDataSource {

    // states that the number of rows is equal to the number of foodItems returned
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return foodRecords.count + 1
    }

    // states that you can modify the table
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // the name will be displayed in each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if(indexPath.row == 0) {
            cell.textLabel?.text = "View Today's Water Intake >"
            cell.textLabel?.textColor = ThemeManager.currentTheme().mainTextColor
            cell.backgroundColor = ThemeManager.currentTheme().accentColor
        } else {
            cell.textLabel?.text = foodRecords[indexPath.row - 1].value(forKeyPath: "name") as? String
        }
        return cell
    }

    // allows the user to delete a food item
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if ( indexPath.row == 0) {
            return;
        }
        if (editingStyle == .delete) {
            // pull out the item the user swiped left on
            let item = foodRecords[indexPath.row-1]
            DatabaseFunctions.deleteFoodRecord(foodItem: item)
            foodRecords.remove(at: indexPath.row-1)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // allows the user to view details about a food item
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailVC {
            destination.foodItem = foodRecords[(tableView.indexPathForSelectedRow?.row)!-1]
        }
    }
}
