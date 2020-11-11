import Foundation
import CoreData
import UIKit

class AddEntryViewController: UIViewController, UIPickerViewDelegate, ModalTransitionListener {
    
    // Nav bar button for changing the date
    @IBOutlet weak var navDate: UIBarButtonItem!
    
    // Segment controller for switching between the addFood and addWater views as well as said views
    @IBOutlet weak var addFood_addWater: UISegmentedControl!
    @IBOutlet weak var addFoodView: UIView!
    @IBOutlet weak var addWaterView: UIView!
    
    /*
     References for the AddWaterViewController and AddFoodViewController to call functions from within these classes
     */
    var waterController: AddWaterViewController? = nil
    var foodController: AddFoodViewController? = nil
    
    /*
     Connect to the AddWaterViewController and AddFoodViewController classes as needed
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let waterController = segue.destination as? AddWaterViewController {
            self.waterController = waterController
        }
        if let foodController = segue.destination as? AddFoodViewController {
            self.foodController = foodController
        }
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    
    /*
     When the popover for setting the date is dismissed, reload eveything
     */
    func popoverDismissed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        reloadView()
    }
    
    /*
     When this view is shown, reload eveything and start a listener for the navDate button being pressed
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadView()
        ModalTransitionMediator.instance.setListener(listener: self)
        addFood_addWater.selectedSegmentIndex = 0
        switchViews(addFood_addWater)
    }

    /*
     Each time the view needs to be reloaded, verify that the navDate is up to date
     */
    func reloadView() {
        DailyState.updateNavDate(navDate: navDate)
    }
    
    /*
     When this view is loaded, reload eveything
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadView()
    }
    
    /*
     If the segment controller is hit, then the view should switch between the options for adding food entries and adding water entries
     */
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            addFoodView.alpha = 1 // make the AddFoodViewController appear
            addWaterView.alpha = 0 // make the AddWaterViewController hide
            self.view.endEditing(true)
            foodController?.reloadView()
        } else {
            addFoodView.alpha = 0 // make the AddFoodViewController hide
            addWaterView.alpha = 1 // make the AddWaterViewController appear
            self.view.endEditing(true)
            addWaterView.setNeedsDisplay()
            waterController?.reloadView()
        }
    }
        
}
