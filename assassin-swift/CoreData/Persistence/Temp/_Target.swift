// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Target.swift instead.

import Foundation
import CoreData

public enum TargetAttributes: String {
    case age = "age"
    case code_name = "code_name"
    case course = "course"
    case gender = "gender"
    case height = "height"
    case target_id = "target_id"
}

public enum TargetRelationships: String {
    case assassin = "assassin"
}

public class _Target: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "Target"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Target.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var age: NSNumber?

    @NSManaged public
    var code_name: String?

    @NSManaged public
    var course: String?

    @NSManaged public
    var gender: String?

    @NSManaged public
    var height: NSNumber?

    @NSManaged public
    var target_id: NSNumber?

    // MARK: - Relationships

    @NSManaged public
    var assassin: Assassin?

}

