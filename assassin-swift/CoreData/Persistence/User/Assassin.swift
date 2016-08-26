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
    
}
