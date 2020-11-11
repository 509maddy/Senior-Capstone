//
//  GoalRecord+CoreDataProperties.swift
//  Senior Capstone
//
//  Created by Madison Lucas on 10/13/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//
//

import Foundation
import CoreData

/**
* XCode generates the GoalRecord class based on the Senior_Capstone.xcdatamodeld file.
* This extension speciices the schema for goal records inputed by the user. We opted to explicty
* define the schema, because XCode would otherwise make all fields optional.
*/
extension GoalRecord {

    // allows for data to be read from storage
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<GoalRecord> {
        return NSFetchRequest<GoalRecord>(entityName: "GoalRecord")
    }

    @NSManaged public var date: Date
    @NSManaged public var fruitGoal: Double
    @NSManaged public var vegetableGoal: Double
    @NSManaged public var proteinGoal: Double
    @NSManaged public var grainGoal: Double
    @NSManaged public var dairyGoal: Double
}
