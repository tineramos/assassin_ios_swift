import Foundation

import CoreData

enum GameStatus: String {
    case Open = "Open"
    case Finished = "Finished"
    case Ongoing = "Ongoing"
    case Cancelled = "Cancelled"
    case Closed = "Closed"
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
        
        switch game_status! {
        case GameStatus.Open.rawValue:
            returnString = String(format: "\(available_slots) available slots")
            break
        case GameStatus.Finished.rawValue:
            returnString = String(format: "\(players_joined) players")
            break
        case GameStatus.Ongoing.rawValue:
            returnString = String(format: "\(players_joined)/\(max_players) players joined")
            break
        default:
            break
        }
        
        return returnString
        
    }
    
    func getStatusColor() -> UIColor {
        
        var color = UIColor.blackColor()
    
        switch game_status! {
        case GameStatus.Open.rawValue:
            color = UIColor.greenColor()
            break
        case GameStatus.Finished.rawValue:
            color = UIColor.blueColor()
            break
        case GameStatus.Ongoing.rawValue:
            color = UIColor.yellowColor()
            break
        default:
            break
        }
        
        return color
        
    }
    
}
