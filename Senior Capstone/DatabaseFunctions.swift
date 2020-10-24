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

class DatabaseFunctions {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate;

    static func retrieveFoodRecord() -> [FoodRecord] {
        var foodRecords = [FoodRecord]()
        let request = FoodRecord.createFetchRequest()

        // order by date (newest date at top)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]

        do {
            foodRecords = try appDelegate.persistentContainer.viewContext.fetch(request)
        } catch {
        }

        return foodRecords
    }

    static func retrieveGoalRecord() -> [GoalRecord] {
        var goalRecords = [GoalRecord]()
        let request = GoalRecord.createFetchRequest()

        // order by date (newest date at top)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]

        do {
            goalRecords = try appDelegate.persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch failed")
        }

        return goalRecords
    }

    static func retriveFoodRecordOnCondition(predicate: NSPredicate) -> [FoodRecord] {
        var foodRecords = [FoodRecord]()
        let request = FoodRecord.createFetchRequest()

        // order by date (newest date at top)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = predicate

        do {
               foodRecords = try appDelegate.persistentContainer.viewContext.fetch(request)
           } catch {
               print("Fetch failed")
           }

           return foodRecords

    }

    static func retriveGoalRecordOnCondition(predicate: NSPredicate) -> [GoalRecord] {
        var goalRecords = [GoalRecord]()
        let request = GoalRecord.createFetchRequest()

        // order by date (newest date at top)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = predicate

        do {
               goalRecords = try appDelegate.persistentContainer.viewContext.fetch(request)
           } catch {
               print("Fetch failed")
           }

           return goalRecords

    }

    static func insertFoodRecord(name: String, date: String, dairyServings: Double, fruitServings: Double, grainServings: Double, proteinServings: Double, vegServings: Double) {
        let foodRecord = FoodRecord(context: appDelegate.persistentContainer.viewContext)
        foodRecord.date = DailyState.todaysDate
        foodRecord.name = name
        foodRecord.dairyServings = dairyServings
        foodRecord.fruitServings = fruitServings
        foodRecord.grainServings = grainServings
        foodRecord.proteinServings = proteinServings
        foodRecord.vegServings = vegServings
        appDelegate.saveContext()
    }

    static func insertGoalRecord(date: Date, fruitGoal: Double, vegetableGoal: Double, proteinGoal: Double, grainGoal: Double, dairyGoal: Double) {
        // check to see if one already exists
        var goalRecords = [GoalRecord]()
        let predicate = NSPredicate(format: "date == %@", date as NSDate)
        goalRecords = DatabaseFunctions.retriveGoalRecordOnCondition(predicate: predicate)

        if goalRecords.count != 0 {
        } else {
            let goalRecord = GoalRecord(context: appDelegate.persistentContainer.viewContext)
            goalRecord.date = date
            goalRecord.fruitGoal = fruitGoal
            goalRecord.vegetableGoal = vegetableGoal
            goalRecord.proteinGoal = proteinGoal
            goalRecord.grainGoal = grainGoal
            goalRecord.dairyGoal = dairyGoal
            appDelegate.saveContext()
        }
        
        DailyState.refreshGoals()
    }

    static func deleteFoodRecord(foodItem: FoodRecord) {
        appDelegate.persistentContainer.viewContext.delete(foodItem)
        appDelegate.saveContext()
    }

    static func deleteGoalRecord(goalItem: GoalRecord) {
        appDelegate.persistentContainer.viewContext.delete(goalItem)
        appDelegate.saveContext()
    }

    static func modifyGoalRecord(date: Date, fruitGoal: Double, vegetableGoal: Double, proteinGoal: Double, grainGoal: Double, dairyGoal: Double) {
        var goalRecords = [GoalRecord]()
        let predicate = NSPredicate(format: "date == %@", date as NSDate)
        goalRecords = DatabaseFunctions.retriveGoalRecordOnCondition(predicate: predicate)

        if goalRecords.count == 0 {
        } else {
            goalRecords[0].setValue(fruitGoal, forKey: "fruitGoal")
            goalRecords[0].setValue(vegetableGoal, forKey: "vegetableGoal")
            goalRecords[0].setValue(proteinGoal, forKey: "proteinGoal")
            goalRecords[0].setValue(grainGoal, forKey: "grainGoal")
            goalRecords[0].setValue(dairyGoal, forKey: "dairyGoal")
            appDelegate.saveContext()
        }

        DailyState.refreshGoals()
    }
}
