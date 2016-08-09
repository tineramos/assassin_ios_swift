import Foundation

import CoreData

@objc(Game)
public class Game: _Game {
	// Custom logic goes here.
    
    class func getGameWithId(gameId: Int, inContext context: NSManagedObjectContext) -> Game {
        
        if let game = Game.MR_findFirstByAttribute(GameAttributes.game_id.rawValue, withValue: gameId, inContext: context) {
            return game
        }
        else {
            return Game.init(managedObjectContext: context)!
        }
    }
    
    class func populateUserWithDictionary(dictionary: NSDictionary, inContext context: NSManagedObjectContext) {
        
        let gameId = dictionary[GameAttributes.game_id.rawValue] as! Int
        let newGame = getGameWithId(gameId, inContext: context)
        
        for (key, value) in dictionary as! [String: AnyObject] {
            
            if value is NSNull {
                continue
            }
            
            if key == GameAttributes.date_finished.rawValue ||
                key == GameAttributes.date_started.rawValue ||
                key == GameAttributes.open_until.rawValue {
                
                // format dates
                
                let dateValue = Parser.dateFromString(value as! String)
                newGame.setValue(dateValue, forKey: key)
            }
            else {
                newGame.setValue(value, forKey: key)
            }
            
        }
        
    }
    
}
