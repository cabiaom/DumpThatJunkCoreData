//
//  Thumbnail+CoreDataProperties.swift
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

extension Thumbnail {

    @NSManaged var id: NSNumber?
    @NSManaged var imageData: NSData?
    @NSManaged var fullRes: Item?

}
