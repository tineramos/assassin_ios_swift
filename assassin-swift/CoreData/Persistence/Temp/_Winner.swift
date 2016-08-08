// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Winner.swift instead.

import Foundation
import CoreData

public enum WinnerAttributes: String {
    case code_name = "code_name"
    case player_id = "player_id"
}

public enum WinnerRelationships: String {
    case game = "game"
}

public class _Winner: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "Winner"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Winner.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var code_name: String?

    @NSManaged public
    var player_id: NSNumber?

    // MARK: - Relationships

    @NSManaged public
    var game: Game?

}

