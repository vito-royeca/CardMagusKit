//
//  CMForeignName+CoreDataProperties.swift
//  
//
//  Created by Jovito Royeca on 11/04/2017.
//
//

import Foundation
import CoreData


extension CMForeignName {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMForeignName> {
        return NSFetchRequest<CMForeignName>(entityName: "CMForeignName")
    }

    @NSManaged public var multiverseid: Int64
    @NSManaged public var name: String?
    @NSManaged public var card: CMCard?
    @NSManaged public var language: CMLanguage?

}
