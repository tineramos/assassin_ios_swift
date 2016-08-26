import Foundation

import CoreData

@objc(PlayerDefences)
public class PlayerDefences: _PlayerDefences {
	// Custom logic goes here.
    
    class func createDefenceWithDictionary(dictionary: NSDictionary, inContext context: NSManagedObjectContext) -> PlayerDefences {
        let defence = PlayerDefences.init(managedObjectContext: context) as PlayerDefences!
        defence.setValue(dictionary[PlayerDefencesAttributes.authorize_usage.rawValue], forKey: PlayerDefencesAttributes.authorize_usage.rawValue)
        defence.setValue(dictionary[PlayerDefencesAttributes.in_use.rawValue], forKey: PlayerDefencesAttributes.in_use.rawValue)
        defence.setValue(dictionary[PlayerDefencesAttributes.quantity.rawValue], forKey: PlayerDefencesAttributes.quantity.rawValue)
        
        // associate the defence object
        let defenceId = dictionary[DefenceAttributes.defence_id.rawValue] as! Int
        defence.defence = Defence.getDefenceWithId(defenceId, inContext: context)
        
        return defence
    }
    
    class func getDefenceDetailsOfPlayerId(playerId: Int, ofDefenceId defenceId: Int, inContext context: NSManagedObjectContext) {
        // TODO: additional method
    }
    
}
