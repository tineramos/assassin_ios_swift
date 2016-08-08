// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Game.swift instead.

import Foundation
import CoreData

public enum GameAttributes: String {
    case available_slots = "available_slots"
    case date_finished = "date_finished"
    case date_started = "date_started"
    case game_id = "game_id"
    case game_location = "game_location"
    case game_status = "game_status"
    case game_title = "game_title"
    case joined = "joined"
    case max_players = "max_players"
    case open_until = "open_until"
    case players_joined = "players_joined"
}

public enum GameRelationships: String {
    case players = "players"
    case winner = "winner"
}

public class _Game: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "Game"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Game.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var available_slots: NSNumber?

    @NSManaged public
    var date_finished: NSDate?

    @NSManaged public
    var date_started: NSDate?

    @NSManaged public
    var game_id: NSNumber?

    @NSManaged public
    var game_location: String?

    @NSManaged public
    var game_status: NSNumber?

    @NSManaged public
    var game_title: String?

    @NSManaged public
    var joined: NSNumber?

    @NSManaged public
    var max_players: NSNumber?

    @NSManaged public
    var open_until: NSDate?

    @NSManaged public
    var players_joined: NSNumber?

    // MARK: - Relationships

    @NSManaged public
    var players: NSSet

    @NSManaged public
    var winner: Winner?

}

extension _Game {

    func addPlayers(objects: NSSet) {
        let mutable = self.players.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as Set<NSObject>)
        self.players = mutable.copy() as! NSSet
    }

    func removePlayers(objects: NSSet) {
        let mutable = self.players.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as Set<NSObject>)
        self.players = mutable.copy() as! NSSet
    }

    func addPlayersObject(value: Player) {
        let mutable = self.players.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.players = mutable.copy() as! NSSet
    }

    func removePlayersObject(value: Player) {
        let mutable = self.players.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.players = mutable.copy() as! NSSet
    }

}

