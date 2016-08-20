import Foundation

import CoreData

@objc(Defence)
public class Defence: _Defence {
	// Custom logic goes here.
    
    class func getDefenceWithId(defenceId: Int, inContext context: NSManagedObjectContext) -> Defence {
        
        if let defence = Defence.MR_findFirstByAttribute(DefenceAttributes.defence_id.rawValue, withValue: defenceId, inContext: context) {
            return defence
        }
        else {
            return Defence.init(managedObjectContext: context)!
        }
    }
    
    class func populateDefenceWithDictionary(dictionary: NSDictionary, inContext context: NSManagedObjectContext) -> Defence {
        
        let defenceId = dictionary[DefenceAttributes.defence_id.rawValue] as! Int
        let defence = getDefenceWithId(defenceId, inContext: context)
        
        for (key, value) in dictionary as! [String: AnyObject] {
            
            if value is NSNull {
                continue
            }
            
            defence.setValue(value, forKey: key)
            
        }
        
        return defence
        
    }
}
