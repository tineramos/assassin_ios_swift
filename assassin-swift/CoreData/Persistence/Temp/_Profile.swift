// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Profile.swift instead.

import Foundation
import CoreData

public enum ProfileAttributes: String {
    case average_kill_per_game = "average_kill_per_game"
    case games_won_count = "games_won_count"
    case total_games_count = "total_games_count"
}

public enum ProfileRelationships: String {
    case assassin = "assassin"
    case user = "user"
}

public class _Profile: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "Profile"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Profile.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var average_kill_per_game: NSNumber?

    @NSManaged public
    var games_won_count: NSNumber?

    @NSManaged public
    var total_games_count: NSNumber?

    // MARK: - Relationships

    @NSManaged public
    var assassin: NSSet

    @NSManaged public
    var user: User?

}

extension _Profile {

    func addAssassin(objects: NSSet) {
        let mutable = self.assassin.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as Set<NSObject>)
        self.assassin = mutable.copy() as! NSSet
    }

    func removeAssassin(objects: NSSet) {
        let mutable = self.assassin.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as Set<NSObject>)
        self.assassin = mutable.copy() as! NSSet
    }

    func addAssassinObject(value: NSManagedObject) {
        let mutable = self.assassin.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.assassin = mutable.copy() as! NSSet
    }

    func removeAssassinObject(value: NSManagedObject) {
        let mutable = self.assassin.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.assassin = mutable.copy() as! NSSet
    }

}

