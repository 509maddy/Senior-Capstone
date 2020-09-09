//
//  PersistantContainer.swift
//  Senior Capstone
//
//  Created by Madison Lucas on 9/5/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
import CloudKit

class PersistentContainer: NSPersistentContainer {
    private static var _model: NSManagedObjectModel?
    private static func model(name: String) throws -> NSManagedObjectModel {
        if _model == nil {
            _model = try loadModel(name: name, bundle: Bundle.main)
        }
        return _model!
    }
    private static func loadModel(name: String, bundle: Bundle) throws -> NSManagedObjectModel {
        guard let modelURL = bundle.url(forResource: name, withExtension: "momd") else {
            throw CoreDataError.modelURLNotFound(forResourceName: name)
        }

        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            throw CoreDataError.modelLoadingFailed(forURL: modelURL)
       }
        return model
    }

    enum CoreDataError: Error {
        case modelURLNotFound(forResourceName: String)
        case modelLoadingFailed(forURL: URL)
    }

    public static func container() throws -> NSPersistentCloudKitContainer {
        let name = "Senior_Capstone"
        return NSPersistentCloudKitContainer(name: name, managedObjectModel: try model(name: name))
    }
}
