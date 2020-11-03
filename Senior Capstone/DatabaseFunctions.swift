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
    
    static func retriveBottleRecord() -> [BottleRecord] {
        var bottleRecords = [BottleRecord]()
        let request = BottleRecord.createFetchRequest()

        // order by date (newest date at top)
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]

        do {
            bottleRecords = try appDelegate.persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch failed")
        }

        return bottleRecords
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
    
    static func retriveWaterRecordOnCondition(predicate: NSPredicate) -> [WaterRecord] {
        var waterRecords = [WaterRecord]()
        let request = WaterRecord.createFetchRequest()

        // order by date (newest date at top)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = predicate

        do {
               waterRecords = try appDelegate.persistentContainer.viewContext.fetch(request)
           } catch {
               print("Fetch failed")
           }

           return waterRecords
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

    static func insertFoodRecord(name: String, dairyServings: Double, fruitServings: Double, grainServings: Double, proteinServings: Double, vegServings: Double) {
        let foodRecord = FoodRecord(context: appDelegate.persistentContainer.viewContext)
        print(DailyState.todaysDateAsDate)
        foodRecord.date = DailyState.todaysDateAsDate
        foodRecord.name = name
        foodRecord.dairyServings = dairyServings
        foodRecord.fruitServings = fruitServings
        foodRecord.grainServings = grainServings
        foodRecord.proteinServings = proteinServings
        foodRecord.vegServings = vegServings
        appDelegate.saveContext()
    }
    
    static func insertBottleVolumeRecord(name: String, volume: Double){
        let bottleRecord = BottleRecord(context: appDelegate.persistentContainer.viewContext)
        bottleRecord.name = name
        bottleRecord.volume = volume
        appDelegate.saveContext()
    }
    
    static func insertWaterRecord(name: String, volume: Double){
        let waterRecord = WaterRecord(context: appDelegate.persistentContainer.viewContext)
        waterRecord.name = name
        waterRecord.volume = volume
        appDelegate.saveContext()
    }

    static func insertGoalRecord(fruitGoal: Double, vegetableGoal: Double, proteinGoal: Double, grainGoal: Double, dairyGoal: Double) {
        // check to see if one already exists
        var goalRecords = [GoalRecord]()
        let predicate = NSPredicate(format: "date == %@", DailyState.todaysDateAsDate as NSDate)
        goalRecords = DatabaseFunctions.retriveGoalRecordOnCondition(predicate: predicate)

        if goalRecords.count != 0 {
        } else {
            let goalRecord = GoalRecord(context: appDelegate.persistentContainer.viewContext)
            goalRecord.date = DailyState.todaysDateAsDate
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
    
    static func deleteBottleRecord(bottleItem: BottleRecord) {
        appDelegate.persistentContainer.viewContext.delete(bottleItem)
        appDelegate.saveContext()
    }
    
    static func deleteWaterRecord(waterItem: WaterRecord) {
        appDelegate.persistentContainer.viewContext.delete(waterItem)
        appDelegate.saveContext()
    }

    static func deleteGoalRecord(goalItem: GoalRecord) {
        appDelegate.persistentContainer.viewContext.delete(goalItem)
        appDelegate.saveContext()
    }

    static func modifyGoalRecord(fruitGoal: Double, vegetableGoal: Double, proteinGoal: Double, grainGoal: Double, dairyGoal: Double) {
        var goalRecords = [GoalRecord]()
        let predicate = NSPredicate(format: "date == %@", DailyState.todaysDateAsDate as NSDate)
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
    
    static func setColorScheme(theme: String){
        let currentTheme = ThemeRecord(context: appDelegate.persistentContainer.viewContext)
        currentTheme.themeName = theme
        appDelegate.saveContext()
    }
    
    static func getColorScheme() -> String{
        var themeRecords = ""
        let request = ThemeRecord.createFetchRequest()
        
        do {
            themeRecord = try appDelegate.persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch failed")
        }
        
        appDelegate.saveContext()
    }
}
