import Foundation

import CoreData

@objc(Assassin)
public class Assassin: _Assassin {
	// Custom logic goes here.
    
    class func insertAssassinObjectWithPlayerId(playerId: Int, withGameId gameId: Int, inContext context: NSManagedObjectContext) -> Assassin {
        let assassin = Assassin.init(managedObjectContext: context) as Assassin!
        assassin.setValue(gameId, forKey: AssassinAttributes.game_id.rawValue)
        assassin.setValue(playerId, forKey: AssassinAttributes.player_id.rawValue)
        return assassin
    }
    
    class func getAssassinWithPlayerId(playerId: Int, withGameId gameId: Int, inContext context: NSManagedObjectContext) -> Assassin {
        let predicate = NSPredicate(format: "(%K = %@) AND (%K = %@)",
                                    argumentArray: [AssassinAttributes.player_id.rawValue, playerId, AssassinAttributes.game_id.rawValue, gameId])
        
        if let assassin = Assassin.MR_findFirstWithPredicate(predicate, inContext: context) {
            return assassin
        }
        else {
            return Assassin.insertAssassinObjectWithPlayerId(playerId, withGameId: gameId, inContext: context)
        }
    }
    
    public func populateWithAmmoDictionary(ammoDictionary: NSDictionary, inContext context: NSManagedObjectContext) {
        
        // remove all defences and weapons
        self.defences.allObjects.forEach { self.removeDefencesObject($0 as! PlayerDefences) }
        self.weapons.allObjects.forEach { self.removeWeaponsObject($0 as! PlayerWeapons) }
        
        // create/update values
        let weaponsArray = ammoDictionary[AssassinRelationships.weapons.rawValue] as! NSArray
        if weaponsArray.count > 0 {
            for dictionary in weaponsArray {
                let weapon = PlayerWeapons.createWeaponWithDictionary(dictionary as! NSDictionary, inContext: context)
                self.addWeaponsObject(weapon)
            }
        }
        
        let defencesArray = ammoDictionary[AssassinRelationships.defences.rawValue] as! NSArray
        if defencesArray.count > 0 {
            for dictionary in defencesArray {
                let defence = PlayerDefences.createDefenceWithDictionary(dictionary as! NSDictionary, inContext: context)
                self.addDefencesObject(defence)
            }
        }
    }
    
}
