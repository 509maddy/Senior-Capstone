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


extension FoodItem {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<FoodItem> {
        return NSFetchRequest<FoodItem>(entityName: "FoodItem")
    }

    @NSManaged public var calories: Int32
    @NSManaged public var date: String
    @NSManaged public var group: String
    @NSManaged public var name: String

}
