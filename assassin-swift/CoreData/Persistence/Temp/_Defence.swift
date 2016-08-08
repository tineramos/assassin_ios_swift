// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Defence.swift instead.

import Foundation
import CoreData

public enum DefenceAttributes: String {
    case defence_id = "defence_id"
    case defence_name = "defence_name"
}

public enum DefenceRelationships: String {
    case playerDefence = "playerDefence"
}

public class _Defence: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "Defence"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Defence.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var defence_id: NSNumber?

    @NSManaged public
    var defence_name: String?

    // MARK: - Relationships

    @NSManaged public
    var playerDefence: NSSet

}

extension _Defence {

    func addPlayerDefence(objects: NSSet) {
        let mutable = self.playerDefence.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as Set<NSObject>)
        self.playerDefence = mutable.copy() as! NSSet
    }

    func removePlayerDefence(objects: NSSet) {
        let mutable = self.playerDefence.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as Set<NSObject>)
        self.playerDefence = mutable.copy() as! NSSet
    }

    func addPlayerDefenceObject(value: PlayerDefences) {
        let mutable = self.playerDefence.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.playerDefence = mutable.copy() as! NSSet
    }

    func removePlayerDefenceObject(value: PlayerDefences) {
        let mutable = self.playerDefence.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.playerDefence = mutable.copy() as! NSSet
    }

}

