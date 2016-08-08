// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.swift instead.

import Foundation
import CoreData

public enum UserAttributes: String {
    case age = "age"
    case code_name = "code_name"
    case course = "course"
    case email = "email"
    case gender = "gender"
    case height = "height"
    case name = "name"
    case password = "password"
    case user_id = "user_id"
}

public enum UserRelationships: String {
    case profile = "profile"
}

public class _User: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "User"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _User.entity(managedObjectContext) else { return nil }
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
    var email: String?

    @NSManaged public
    var gender: String?

    @NSManaged public
    var height: NSNumber?

    @NSManaged public
    var name: String?

    @NSManaged public
    var password: String?

    @NSManaged public
    var user_id: NSNumber?

    // MARK: - Relationships

    @NSManaged public
    var profile: Profile?

}

