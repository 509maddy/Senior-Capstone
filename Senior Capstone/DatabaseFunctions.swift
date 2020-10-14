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
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]

        do {
            foodRecords = try appDelegate.persistentContainer.viewContext.fetch(request)
            print(foodRecords)
            print("Got \(foodRecords.count) foodItems")
        } catch {
            print("Fetch failed")
        }

        return foodRecords
    }

    static func retriveFoodRecordOnCondition(predicate: NSPredicate) -> [FoodRecord] {
        var foodRecords = [FoodRecord]()
        let request = FoodRecord.createFetchRequest()

        // order by date (newest date at top)
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = predicate

        do {
               foodRecords = try appDelegate.persistentContainer.viewContext.fetch(request)
               print(foodRecords)
               print("Got \(foodRecords.count) foodItems")
           } catch {
               print("Fetch failed")
           }

           return foodRecords

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

    static func deleteFoodRecord(foodItem: FoodRecord) {
        appDelegate.persistentContainer.viewContext.delete(foodItem)
        appDelegate.saveContext()
    }
    
    
}
