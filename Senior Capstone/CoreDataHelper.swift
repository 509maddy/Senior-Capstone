//
//  GlobalFunctions.swift
//  Senior Capstone
//
//  Created by Madison Lucas on 9/3/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class CoreDataHelper {


    enum CoreDataError: Error {
        case insertionError
        case fetchError
    }

    public enum Result {
      case Success(AnyObject)
      case Failure(String)
    }


    /*static func updateFields() {
        var people: [NSManagedObject] = []

        guard let application = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        people = Helper.fetchCoreData(managedContext: application.persistentContainer.viewContext, fetchRequest: NSFetchRequest<NSManagedObject>(entityName: "dailyUserData"), predicate: nil)

        let person = people[0]
        if person.value(forKeyPath: "totalCalories") == nil {
            self.totalCalories = 0
        } else {
            self.totalCalories = person.value(forKeyPath: "totalCalories") as! Int
        }

        print("Total: ")
        print(self.totalCalories)

    }*/

    /**
     *  Use this method to retrieve entries from Core Data
     *  Example Paramaters:
     *      entityName: "FoodItem"
     *      predicate: NSPredicate(format: "date == %@", "8-2-2020")
     *  Output: Array of FoodItem entries => retrieve individal attribure by results[0].value(forKeyPath: "name") as? String
     **/
    static func fetchCoreData(entityName: String, predicate: NSPredicate?) throws -> [NSManagedObject]? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                throw CoreDataError.fetchError
        }
        var results: [NSManagedObject] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)

        if predicate != nil {
            fetchRequest.predicate = predicate
        }

        do {
            results = try managedContext.fetch(fetchRequest)
            return results
        } catch {
            throw CoreDataError.fetchError
        }
    }

    /**
    *  Use this method to insert NEW entries into Core Data
    *  Example Paramaters:
    *      entityName: "FoodItem"
    *      attributeNames: [name, group, calories, "8-2-2020"]
    *      attributeValues: ["name", "group", "calories", "date"]
    *  Output OPTIONAL: The entity you are adding in case you need to use it immeaditly to update some field or display it, insertion error otherwise
    **/
    static func insertCoreData(entityName: String, attributeValues: [Any?], attributeNames: [String]) throws ->  NSManagedObject?{
        do {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                throw CoreDataError.insertionError
            }
            

            // check each item in AttributeNames is a real attribute for the entity
            

            // check each value is appropriate for the name?

            let managedContext = appDelegate.persistentContainer.viewContext

            /*I am forcing an unwrap here too, if there is an error with the context, it should get picked up by the throws. */
            let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!

            let entity = NSManagedObject(entity: entityDescription,
                                         insertInto: managedContext)

            for (name, value) in zip(attributeNames, attributeValues) {
                entity.setValue(value, forKeyPath: name)
            }

            try managedContext.save()
            return entity
        } catch {
            throw CoreDataError.insertionError
        }
    }
}
