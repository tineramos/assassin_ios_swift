// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PlayerDefences.swift instead.

import Foundation
import CoreData

public enum PlayerDefencesAttributes: String {
    case authorize_usage = "authorize_usage"
    case in_use = "in_use"
    case quantity = "quantity"
}

public enum PlayerDefencesRelationships: String {
    case defence = "defence"
    case player = "player"
}

public class _PlayerDefences: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "PlayerDefences"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _PlayerDefences.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var authorize_usage: NSNumber?

    @NSManaged public
    var in_use: NSNumber?

    @NSManaged public
    var quantity: NSNumber?

    // MARK: - Relationships

    @NSManaged public
    var defence: Defence?

    @NSManaged public
    var player: NSManagedObject?

}

