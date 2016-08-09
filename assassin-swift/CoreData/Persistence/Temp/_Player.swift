// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Player.swift instead.

import Foundation
import CoreData

public enum PlayerAttributes: String {
    case is_eliminated = "is_eliminated"
    case kills_count = "kills_count"
    case player_code_name = "player_code_name"
    case player_id = "player_id"
}

public enum PlayerRelationships: String {
    case game = "game"
}

public class _Player: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "Player"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Player.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var is_eliminated: NSNumber?

    @NSManaged public
    var kills_count: NSNumber?

    @NSManaged public
    var player_code_name: String?

    @NSManaged public
    var player_id: NSNumber?

    // MARK: - Relationships

    @NSManaged public
    var game: Game?

}

