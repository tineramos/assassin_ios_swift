import Foundation

import CoreData

@objc(Target)
public class Target: _Target {
	// Custom logic goes here.

    class func insertTargetObjectWithId(targetId: Int, inContext context: NSManagedObjectContext) -> Target {
        let target = Target.init(managedObjectContext: context) as Target!
        target.setValue(targetId, forKey: TargetAttributes.target_id.rawValue)
        return target
    }
    
    class func getTargetWithId(targetId: Int, inContext context: NSManagedObjectContext) -> Target {
        
        if let target = Target.MR_findFirstByAttribute(TargetAttributes.target_id.rawValue, withValue: targetId, inContext: context) {
            return target
        }
        else {
            return Target.insertTargetObjectWithId(targetId, inContext: context)
        }
    }
    
    class func populateTargetWithDictionary(dictionary: NSDictionary, ofAssassin assassin: Assassin, inContext context: NSManagedObjectContext) -> Target {
        
        let targetId = dictionary[TargetAttributes.target_id.rawValue] as! Int
        let targetObject = getTargetWithId(targetId, inContext: context)
        
        for (key, value) in dictionary as! [String: AnyObject] {
            
            if value is NSNull {
                continue
            }
            
            targetObject.setValue(value, forKey: key)
            
        }
        
        // set the target for the assassin
        let assassinObject = Assassin.MR_findFirstByAttribute(AssassinAttributes.player_id.rawValue,
                                                              withValue: assassin.player_id!, inContext: context) as Assassin!
        targetObject.setValue(assassinObject, forKey: TargetRelationships.assassin.rawValue)
        
        return targetObject
        
    }

}
