//
//  FoodRecord+CoreDataProperties.swift
//  Senior Capstone
//
//  Created by Madison Lucas on 9/18/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//
//

import Foundation
import CoreData


extension FoodRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodRecord> {
        return NSFetchRequest<FoodRecord>(entityName: "FoodRecord")
    }

    @NSManaged public var name: String
    // change this to type Date at some point
    @NSManaged public var date: String
    @NSManaged public var meal: String
    @NSManaged public var fruitServing: Double
    @NSManaged public var grainServing: Double
    @NSManaged public var veggiesAndBeansServing: Double
    @NSManaged public var meatServing: Double
    @NSManaged public var dairyServing: Double

}
