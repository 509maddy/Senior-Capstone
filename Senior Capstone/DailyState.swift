//
//  Person.swift
//  Senior Capstone
//
//  Created by Madison Lucas on 9/4/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import Foundation
import CoreData

/**
 * I am thinking this will hold a copy of the daily user information for ease of use
 */
class DailyState {

    static var todaysDate: String = initDate()
    static var fruitGoal: Double = initGoal(group: GroupName.Fruit)
    static var vegetableGoal: Double = initGoal(group: GroupName.Vegetable)
    static var proteinGoal: Double = initGoal(group: GroupName.Protein)
    static var grainGoal: Double = initGoal(group: GroupName.Grain)
    static var dairyGoal: Double = initGoal(group: GroupName.Dairy)
    static let fruitGoalDefault: Double = 4.0
    static let vegetableGoalDefault: Double = 5.0
    static let proteinGoalDefault: Double = 5.0
    static let grainGoalDefault: Double = 6.0
    static let dairyGoalDefault: Double = 3.0

    static func initDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        let result = formatter.string(from: date)
        return result
    }

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

    static func updateTodaysDate(todaysDate: String) {
        self.todaysDate = todaysDate
        refreshGoals()
    }

    static func refreshGoals() {
        // check if goal exists for this date
        // if so, update goals
        // if not, pull most recent goal before this date
        // if no goal at all, use defaults
    }

    static func updateGoals(fruitGoal: Double, vegetableGoal: Double, proteinGoal: Double, grainGoal: Double, dairyGoal: Double) {

    }

    enum GroupName: String {
        case Fruit = "fruit"
        case Vegetable = "vegetable"
        case Protein = "protein"
        case Grain = "grain"
        case Dairy = "dairy"
    }

    // initilize state with plist when app first launched after download
        // I think this will be done in the AppDelegate file? => NOT DONE HERE
        // https://www.youtube.com/watch?v=hrwx_teqwdQ
        // could we have something in the AppDelegate file where when the app is first launched, it checks to see if Date enity holds the current date, and if not it updates the current date?

    // initilize state with Core Data based on current date when app is launched
        // Date enity will need to be created and pre-initialized

    // reinitialize state with Core Data if a different date is chosen
        // might just be done in settings, not sure what is best yet

    // update the state any time the Core Database is written too
        // when we add food items, we might want to update servings for a partcular food group
        // also not sure yet how this will look, or if it goes here

    
}
