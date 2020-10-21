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
* Here is where I made the attributes for the enity FoodItem not optional. XCode would default to
* @NSManaged public var calories: Int32?, but I ommited the question mark.
*/
extension FoodRecord {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<FoodRecord> {
        return NSFetchRequest<FoodRecord>(entityName: "FoodRecord")
    }

    @NSManaged public var date: String
    @NSManaged public var name: String
    @NSManaged public var dairyServings: Double
    @NSManaged public var fruitServings: Double
    @NSManaged public var grainServings: Double
    @NSManaged public var proteinServings: Double
    @NSManaged public var vegServings: Double

}
