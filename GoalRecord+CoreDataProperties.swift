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


extension GoalRecord {

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
