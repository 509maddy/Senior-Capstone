//
//  Person.swift
//  Senior Capstone
//
//  Created by Madison Lucas on 9/4/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/**
 * This serves as a global class to hold information shared across all view controllers.
 * This information is initlized with the values in persistant storge and updated as
 * the database is modified.
 */
class DailyState {


    // these define our hardcoded goals
    static let fruitGoalDefault: Double = 4.0
    static let vegetableGoalDefault: Double = 5.0
    static let proteinGoalDefault: Double = 5.0
    static let grainGoalDefault: Double = 6.0
    static let dairyGoalDefault: Double = 3.0


    // this initilizes the current day as both a String and a Date object
    static var todaysDate: String = initDate()
    static var todaysDateAsDate: Date = initDateAsDate()

    // this initlizes the fruit goals with the default goals
    static var fruitGoal: Double = initGoal(group: GroupName.Fruit)
    static var vegetableGoal: Double = initGoal(group: GroupName.Vegetable)
    static var proteinGoal: Double = initGoal(group: GroupName.Protein)
    static var grainGoal: Double = initGoal(group: GroupName.Grain)
    static var dairyGoal: Double = initGoal(group: GroupName.Dairy)


    // helper functions to read the current date and format it as a string
    static func initDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        let result = formatter.string(from: date)
        return result
    }

    // heleper function to read the current date and format it as a Date object
    static func initDateAsDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter.date(from: DailyState.todaysDate)!
        return date
    }

    // helper function to initlize food group goal depending on its group name
    static func initGoal(group: GroupName) -> Double {
        let value: Double

        switch group {
        case GroupName.Fruit:
            value = fruitGoalDefault
        case GroupName.Protein:
            value = proteinGoalDefault
        case GroupName.Grain:
            value =  grainGoalDefault
        case GroupName.Vegetable:
            value = vegetableGoalDefault
        case GroupName.Dairy:
            value = dairyGoalDefault
        }

        return value
    }

    // global function to update both date fields, called when date picker is triggered
    static func updateTodaysDate(todaysDate: String) {
        self.todaysDate = todaysDate
        self.todaysDateAsDate = initDateAsDate()
        refreshGoals()
    }

    // global function to update the date display on the navigation bar
    static func updateNavDate(navDate: UIBarButtonItem){
        navDate.title = self.todaysDate
    }

    /**
    * This serves as a globa function to update the goals. Requests are made to update the goals for a particular date.
    * If a goal is found for that date, it is used. Otherwise, it looks for the next closest goal record that falls before this
    * particular date and uses those values. If there is no records on or before this date, the default goal values are used.
    */
    static func refreshGoals() {

        // prepares array to hold incoming goal records for a particular date
        var goalRecords = [GoalRecord]()
        let predicate = NSPredicate(format: "date == %@", todaysDateAsDate as NSDate)
        goalRecords = DatabaseFunctions.retriveGoalRecordOnCondition(predicate: predicate)

        // fills array
        if goalRecords.count != 0 { // there exists a record for this date
            vegetableGoal = goalRecords[0].value(forKey: "vegetableGoal") as! Double
            proteinGoal = goalRecords[0].value(forKey: "proteinGoal") as! Double
            grainGoal = goalRecords[0].value(forKey: "grainGoal") as! Double
            dairyGoal = goalRecords[0].value(forKey: "dairyGoal") as! Double
            fruitGoal = goalRecords[0].value(forKey: "fruitGoal") as! Double
        } else {    // there does not exist a record for this date

            // looks for the first record before the requested date
            let predicate = NSPredicate(format: "date < %@", todaysDateAsDate as NSDate)
            goalRecords = DatabaseFunctions.retriveGoalRecordOnCondition(predicate: predicate)

            // increments through returned array to find closest goal that falls before requested date
            var foundGoal = false
            var counter = 0;
            while (foundGoal == false && counter < goalRecords.count) {
                let recordDate = goalRecords[counter].value(forKey: "date") as! Date
                    if recordDate < todaysDateAsDate {  // goal is found, so the goals are set to this date
                        vegetableGoal = goalRecords[counter].value(forKey: "vegetableGoal") as! Double
                        proteinGoal = goalRecords[counter].value(forKey: "proteinGoal") as! Double
                        grainGoal = goalRecords[counter].value(forKey: "grainGoal") as! Double
                        dairyGoal = goalRecords[counter].value(forKey: "dairyGoal") as! Double
                        fruitGoal = goalRecords[counter].value(forKey: "fruitGoal") as! Double
                        foundGoal = true;
                    }
                counter = counter + 1;
            }

            // there are no records before this date, so the defualt goals are used
            if foundGoal == false {
                vegetableGoal = fruitGoalDefault
                proteinGoal = proteinGoalDefault
                grainGoal = grainGoalDefault
                dairyGoal = vegetableGoalDefault
                fruitGoal = dairyGoalDefault
            }
        }
    }

    // stores string representation of food group names
    enum GroupName: String {
        case Fruit = "fruit"
        case Vegetable = "vegetable"
        case Protein = "protein"
        case Grain = "grain"
        case Dairy = "dairy"
    }
}
