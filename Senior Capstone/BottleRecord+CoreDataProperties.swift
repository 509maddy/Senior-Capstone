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
* XCode generates the BottleRecord class based on the Senior_Capstone.xcdatamodeld file.
* This extension speciices the schema for bottle records inputed by the user. We opted to explicty
* define the schema, because XCode would otherwise make all fields optional.
*/
extension BottleRecord {

    // allows for data to be read from storage
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<BottleRecord> {
        return NSFetchRequest<BottleRecord>(entityName: "BottleRecord")
    }

    @NSManaged public var name: String
    @NSManaged public var volume: Double
}
