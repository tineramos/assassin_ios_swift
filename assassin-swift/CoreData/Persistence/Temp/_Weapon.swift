// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Weapon.swift instead.

import Foundation
import CoreData

public enum WeaponAttributes: String {
    case weapon_id = "weapon_id"
    case weapon_name = "weapon_name"
}

public enum WeaponRelationships: String {
    case playerWeapon = "playerWeapon"
}

public class _Weapon: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "Weapon"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Weapon.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var weapon_id: NSNumber?

    @NSManaged public
    var weapon_name: String?

    // MARK: - Relationships

    @NSManaged public
    var playerWeapon: NSSet

}

extension _Weapon {

    func addPlayerWeapon(objects: NSSet) {
        let mutable = self.playerWeapon.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as Set<NSObject>)
        self.playerWeapon = mutable.copy() as! NSSet
    }

    func removePlayerWeapon(objects: NSSet) {
        let mutable = self.playerWeapon.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as Set<NSObject>)
        self.playerWeapon = mutable.copy() as! NSSet
    }

    func addPlayerWeaponObject(value: PlayerWeapons) {
        let mutable = self.playerWeapon.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.playerWeapon = mutable.copy() as! NSSet
    }

    func removePlayerWeaponObject(value: PlayerWeapons) {
        let mutable = self.playerWeapon.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.playerWeapon = mutable.copy() as! NSSet
    }

}

