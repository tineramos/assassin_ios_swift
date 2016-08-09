// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Assassin.swift instead.

import Foundation
import CoreData

public enum AssassinAttributes: String {
    case game_id = "game_id"
    case player_id = "player_id"
}

public enum AssassinRelationships: String {
    case defences = "defences"
    case profile = "profile"
    case target = "target"
    case weapons = "weapons"
}

public class _Assassin: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "Assassin"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Assassin.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var game_id: NSNumber?

    @NSManaged public
    var player_id: NSNumber?

    // MARK: - Relationships

    @NSManaged public
    var defences: NSSet

    @NSManaged public
    var profile: Profile?

    @NSManaged public
    var target: Target?

    @NSManaged public
    var weapons: NSSet

}

extension _Assassin {

    func addDefences(objects: NSSet) {
        let mutable = self.defences.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as Set<NSObject>)
        self.defences = mutable.copy() as! NSSet
    }

    func removeDefences(objects: NSSet) {
        let mutable = self.defences.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as Set<NSObject>)
        self.defences = mutable.copy() as! NSSet
    }

    func addDefencesObject(value: PlayerDefences) {
        let mutable = self.defences.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.defences = mutable.copy() as! NSSet
    }

    func removeDefencesObject(value: PlayerDefences) {
        let mutable = self.defences.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.defences = mutable.copy() as! NSSet
    }

}

extension _Assassin {

    func addWeapons(objects: NSSet) {
        let mutable = self.weapons.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as Set<NSObject>)
        self.weapons = mutable.copy() as! NSSet
    }

    func removeWeapons(objects: NSSet) {
        let mutable = self.weapons.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as Set<NSObject>)
        self.weapons = mutable.copy() as! NSSet
    }

    func addWeaponsObject(value: PlayerWeapons) {
        let mutable = self.weapons.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.weapons = mutable.copy() as! NSSet
    }

    func removeWeaponsObject(value: PlayerWeapons) {
        let mutable = self.weapons.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.weapons = mutable.copy() as! NSSet
    }

}

