import Foundation

import CoreData

enum GameStatus: String {
    case Open = "open"
    case Finished = "finished"
    case Ongoing = "ongoing"
    case Cancelled = "cancelled"
    case Closed = "closed"
}

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
    
    func getPlayersTitle() -> String {
        
        var returnString = ""
        
        let status = GameStatus(rawValue: game_status!)!
        
        switch status {
        case .Open:
            returnString = String(format: "\(available_slots!) available slots")
            break
        case .Finished:
            returnString = String(format: "\(players_joined!) players")
            break
        case .Ongoing:
            returnString = String(format: "\(players_joined!)/\(max_players!) players joined")
            break
        default:
            break
        }
        
        return returnString
        
    }
    
    func getStatusColor() -> UIColor {
        
        var color = UIColor.blackColor()
        
        let status = GameStatus(rawValue: game_status!)!
        
        switch status {
        case .Open:
            color = UIColor.greenColor()
            break
        case .Finished:
            color = UIColor.blueColor()
            break
        case .Ongoing:
            color = UIColor.yellowColor()
            break
        default:
            break
        }
        
        return color
        
    }
    
}
