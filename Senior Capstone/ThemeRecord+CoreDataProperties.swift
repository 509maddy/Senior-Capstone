//
//  BottleRecord+CoreDataProperties.swift
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
extension ThemeRecord {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<ThemeRecord> {
        return NSFetchRequest<ThemeRecord>(entityName: "ThemeRecord")
    }

    @NSManaged public var themeName: String
}
