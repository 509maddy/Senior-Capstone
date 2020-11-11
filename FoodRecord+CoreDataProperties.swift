//
//  FoodItem+CoreDataProperties.swift
//  Senior Capstone
//
//  Created by Madison Lucas on 9/5/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//
//

import Foundation
import CoreData

/**
* XCode generates the FoodRecord class based on the Senior_Capstone.xcdatamodeld file.
* This extension speciices the schema for food records inputed by the user. We opted to explicty
* define the schema, because XCode would otherwise make all fields optional.
*/
extension FoodRecord {

    // allows for data to be read from storage
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<FoodRecord> {
        return NSFetchRequest<FoodRecord>(entityName: "FoodRecord")
    }

    @NSManaged public var date: Date
    @NSManaged public var name: String
    @NSManaged public var dairyServings: Double
    @NSManaged public var fruitServings: Double
    @NSManaged public var grainServings: Double
    @NSManaged public var proteinServings: Double
    @NSManaged public var vegServings: Double

}
