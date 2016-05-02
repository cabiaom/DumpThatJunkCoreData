//
//  BoxUnit+CoreDataProperties.swift
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

extension BoxUnit {

    @NSManaged var dateModified: NSDate?
    @NSManaged var name: String?
    @NSManaged var unitDescription: String?
    @NSManaged var unitID: NSNumber?
    @NSManaged var items: NSSet?
    @NSManaged var location: Location?

}
