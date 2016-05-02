//
//  Item+CoreDataProperties.swift
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

extension Item {

    @NSManaged var itemID: NSNumber?
    @NSManaged var name: String?
    @NSManaged var picture: NSData?
    @NSManaged var qty: NSNumber?
    @NSManaged var thumbnail: Thumbnail?
    @NSManaged var unit: BoxUnit?

}
