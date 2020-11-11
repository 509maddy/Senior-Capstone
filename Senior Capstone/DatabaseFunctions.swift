//
//  DatabaseFunctions.swift
//  Senior Capstone
//
//  Created by Madison Lucas on 9/22/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/**
* This serves as a global class to hold functions to insert, delete, and modify the database.
* The appDelefate keeps a copy of the database. All modification is done on this copy. When
* a change is detected, CoreData modifies the actual database to reflect the copy.
*/
class DatabaseFunctions {

    // asks the appDelagate to be shared by all screens, so any screen can modify the database
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate;

    // retrieves all food records stored in database and returns as array
    static func retrieveFoodRecord() -> [FoodRecord] {

        // prepares array for incoming data
        var foodRecords = [FoodRecord]()
        let request = FoodRecord.createFetchRequest()

        // order by date (newest date at top)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]

        // fills array
        do {
            foodRecords = try appDelegate.persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch failed")
        }

        return foodRecords
    }

    // retrieves all bottle records stored in database and returns as array
    static func retriveBottleRecord() -> [BottleRecord] {

        // prepares array for incoming data
        var bottleRecords = [BottleRecord]()
        let request = BottleRecord.createFetchRequest()

        // order by date (newest date at top)
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]

        // fills array
        do {
            bottleRecords = try appDelegate.persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch failed")
        }

        return bottleRecords
    }

    // retrieves all goal records stored in database and returns as array
    static func retrieveGoalRecord() -> [GoalRecord] {

        // prepares array for incoming data
        var goalRecords = [GoalRecord]()
        let request = GoalRecord.createFetchRequest()

        // order by date (newest date at top)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]

        // fills array
        do {
            goalRecords = try appDelegate.persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch failed")
        }

        return goalRecords
    }

    // retrieves all goal records with a certain condition (i.e. date = "...") and returns as array
    static func retriveFoodRecordOnCondition(predicate: NSPredicate) -> [FoodRecord] {

        // prepares array for incoming data
        var foodRecords = [FoodRecord]()
        let request = FoodRecord.createFetchRequest()

        // order by date (newest date at top)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = predicate

        // fills array
        do {
            foodRecords = try appDelegate.persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch failed")
        }

        return foodRecords
    }

    // retrieves all water records with a certain condition (i.e. date = "...") and returns as array
    static func retriveWaterRecordOnCondition(predicate: NSPredicate) -> [WaterRecord] {

        // prepares array for incoming data
        var waterRecords = [WaterRecord]()
        let request = WaterRecord.createFetchRequest()

        // order by date (newest date at top)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = predicate

        // fills array
        do {
            waterRecords = try appDelegate.persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch failed")
        }

        return waterRecords
    }

    // retrieves all goal records with a certain condition (i.e. date = "...") and returns as array
    static func retriveGoalRecordOnCondition(predicate: NSPredicate) -> [GoalRecord] {

        // prepares array for incoming data
        var goalRecords = [GoalRecord]()
        let request = GoalRecord.createFetchRequest()

        // order by date (newest date at top)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = predicate

        // fills array
        do {
            goalRecords = try appDelegate.persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch failed")
        }

        return goalRecords
    }

    // inserts new food record into database
    static func insertFoodRecord(name: String, dairyServings: Double, fruitServings: Double, grainServings: Double, proteinServings: Double, vegServings: Double) {

        // asks to modify database copy
        let foodRecord = FoodRecord(context: appDelegate.persistentContainer.viewContext)

        // performs and saves modification
        foodRecord.date = DailyState.todaysDateAsDate
        foodRecord.name = name
        foodRecord.dairyServings = dairyServings
        foodRecord.fruitServings = fruitServings
        foodRecord.grainServings = grainServings
        foodRecord.proteinServings = proteinServings
        foodRecord.vegServings = vegServings
        appDelegate.saveContext()
    }

    // inserts new bottle record into database
    static func insertBottleVolumeRecord(name: String, volume: Double){

        // asks to modify database copy
        let bottleRecord = BottleRecord(context: appDelegate.persistentContainer.viewContext)

        // performs and saves modification
        bottleRecord.name = name
        bottleRecord.volume = volume
        appDelegate.saveContext()
    }

    // inserts new water record into database
    static func insertWaterRecord(name: String, volume: Double){
        // asks to modify database copy
        let waterRecord = WaterRecord(context: appDelegate.persistentContainer.viewContext)

        // performs and saves modification
        waterRecord.date = DailyState.todaysDateAsDate
        waterRecord.name = name
        waterRecord.volume = volume
        appDelegate.saveContext()
    }

    // inserts new water record into database, otherwise modifies existing goal record for that date
    static func insertGoalRecord(fruitGoal: Double, vegetableGoal: Double, proteinGoal: Double, grainGoal: Double, dairyGoal: Double) {

        // check to see if one already exists
        var goalRecords = [GoalRecord]()
        let predicate = NSPredicate(format: "date == %@", DailyState.todaysDateAsDate as NSDate)
        goalRecords = DatabaseFunctions.retriveGoalRecordOnCondition(predicate: predicate)

        if goalRecords.count != 0 { // goal exists so modify should have been called instead
            print("insertion failed, modify should have been called")
        } else {    // goal does not exist, so add it

            // asks to modify database copy
            let goalRecord = GoalRecord(context: appDelegate.persistentContainer.viewContext)

            // performs and saves modification
            goalRecord.date = DailyState.todaysDateAsDate
            goalRecord.fruitGoal = fruitGoal
            goalRecord.vegetableGoal = vegetableGoal
            goalRecord.proteinGoal = proteinGoal
            goalRecord.grainGoal = grainGoal
            goalRecord.dairyGoal = dairyGoal
            appDelegate.saveContext()
        }

        // updates DailyState to reflect new changes to database
        DailyState.refreshGoals()
    }

    // deletes food record
    static func deleteFoodRecord(foodItem: FoodRecord) {
        appDelegate.persistentContainer.viewContext.delete(foodItem)
        appDelegate.saveContext()
    }

    // deletes bottle record
    static func deleteBottleRecord(bottleItem: BottleRecord) {
        appDelegate.persistentContainer.viewContext.delete(bottleItem)
        appDelegate.saveContext()
    }

    // deletes water record
    static func deleteWaterRecord(waterItem: WaterRecord) {
        appDelegate.persistentContainer.viewContext.delete(waterItem)
        appDelegate.saveContext()
    }

    // delets goal record
    static func deleteGoalRecord(goalItem: GoalRecord) {
        appDelegate.persistentContainer.viewContext.delete(goalItem)
        appDelegate.saveContext()
    }

    // updates the goal associated with a particular date
    static func modifyGoalRecord(fruitGoal: Double, vegetableGoal: Double, proteinGoal: Double, grainGoal: Double, dairyGoal: Double) {

        // asks to modify database copy and prepares array for incoming data associated with the given date
        var goalRecords = [GoalRecord]()
        let predicate = NSPredicate(format: "date == %@", DailyState.todaysDateAsDate as NSDate)
        goalRecords = DatabaseFunctions.retriveGoalRecordOnCondition(predicate: predicate)

        if goalRecords.count == 0 { // goal does not exist so insertion should have been called instead
            print("modification failed, insertion should have been called")
        } else {    // goal exists, so modify it

            // performs and saves modification
            goalRecords[0].setValue(fruitGoal, forKey: "fruitGoal")
            goalRecords[0].setValue(vegetableGoal, forKey: "vegetableGoal")
            goalRecords[0].setValue(proteinGoal, forKey: "proteinGoal")
            goalRecords[0].setValue(grainGoal, forKey: "grainGoal")
            goalRecords[0].setValue(dairyGoal, forKey: "dairyGoal")
            appDelegate.saveContext()
        }

        // updates DailyState to reflect new changes to database
        DailyState.refreshGoals()
    }
}
