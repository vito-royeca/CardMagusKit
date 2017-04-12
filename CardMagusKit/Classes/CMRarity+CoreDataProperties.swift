//
//  CMRarity+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 12/04/2017.
//
//

import Foundation
import CoreData


extension CMRarity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMRarity> {
        return NSFetchRequest<CMRarity>(entityName: "CMRarity")
    }

    @NSManaged public var name: String?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension CMRarity {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
