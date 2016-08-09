// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PlayerWeapons.swift instead.

import Foundation
import CoreData

public enum PlayerWeaponsAttributes: String {
    case in_use = "in_use"
    case shots_left = "shots_left"
}

public enum PlayerWeaponsRelationships: String {
    case player = "player"
    case weapon = "weapon"
}

public class _PlayerWeapons: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "PlayerWeapons"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _PlayerWeapons.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var in_use: NSNumber?

    @NSManaged public
    var shots_left: NSNumber?

    // MARK: - Relationships

    @NSManaged public
    var player: Assassin?

    @NSManaged public
    var weapon: Weapon?

}

