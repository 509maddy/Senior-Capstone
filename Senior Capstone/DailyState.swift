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
    

    static var calories:Int = 2000
    static var todaysDate: String = "9/28/20"

    static func updateTodaysDate(todaysDate: String) {
        self.todaysDate = todaysDate
    }

    enum GroupName: String {
        case Fruit = "fruit"
        case Vegetable = "vegetable"
        case Protien = "protein"
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
