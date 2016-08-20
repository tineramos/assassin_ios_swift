import Foundation

import CoreData

@objc(Player)
public class Player: _Player {
	// Custom logic goes here.
    
    class func insertPlayerObjectWithId(playerId: Int, inContext context: NSManagedObjectContext) -> Player {
        let player = Player.init(managedObjectContext: context) as Player!
        player.setValue(playerId, forKey: PlayerAttributes.player_id.rawValue)
        return player
    }
    
    class func getPlayerWithId(playerId: Int, inContext context: NSManagedObjectContext) -> Player {
        
        if let player = Player.MR_findFirstByAttribute(PlayerAttributes.player_id.rawValue, withValue: playerId, inContext: context) {
            return player
        }
        else {
            return Player.init(managedObjectContext: context)!
        }
    }
    
    class func populatePlayerWithDictionary(dictionary: NSDictionary, inContext context: NSManagedObjectContext) -> Player {
        
        let playerId = dictionary[PlayerAttributes.player_id.rawValue] as! Int
        let playerObject = getPlayerWithId(playerId, inContext: context)
        
        for (key, value) in dictionary as! [String: AnyObject] {
            
            if value is NSNull {
                continue
            }
            
            playerObject.setValue(value, forKey: key)
            
        }
        
        return playerObject
        
    }
    
}
