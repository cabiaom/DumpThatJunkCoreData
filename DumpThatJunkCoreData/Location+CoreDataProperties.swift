//
//  Location+CoreDataProperties.swift
//  DumpThatJunkCoreData
//
//  Created by Mark CABIAO on 4/18/16.
//  Copyright © 2016 Mark CABIAO. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var locationID: NSNumber?
    @NSManaged var name: String?
    @NSManaged var units: NSSet?

}
