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
* XCode generates the WaterRecord class based on the Senior_Capstone.xcdatamodeld file.
* This extension speciices the schema for water records inputed by the user. We opted to explicty
* define the schema, because XCode would otherwise make all fields optional.
*/
extension WaterRecord {

    // allows for data to be read from storage
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<WaterRecord> {
        return NSFetchRequest<WaterRecord>(entityName: "WaterRecord")
    }

    @NSManaged public var date: Date
    @NSManaged public var name: String
    @NSManaged public var volume: Double
}
