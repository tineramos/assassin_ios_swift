import Foundation

import CoreData

@objc(Weapon)
public class Weapon: _Weapon {
	// Custom logic goes here.
    
    class func getWeaponWithId(weaponId: Int, inContext context: NSManagedObjectContext) -> Weapon {
        
        if let weapon = Weapon.MR_findFirstByAttribute(WeaponAttributes.weapon_id.rawValue, withValue: weaponId, inContext: context) {
            return weapon
        }
        else {
            return Weapon.init(managedObjectContext: context)!
        }
    }
    
    class func populateWeaponWithDictionary(dictionary: NSDictionary, inContext context: NSManagedObjectContext) -> Weapon {
        
        let weaponId = dictionary[WeaponAttributes.weapon_id.rawValue] as! Int
        let weapon = getWeaponWithId(weaponId, inContext: context)
        
        for (key, value) in dictionary as! [String: AnyObject] {
            
            if value is NSNull {
                continue
            }
            
            weapon.setValue(value, forKey: key)
            
        }
        
        return weapon
        
    }
    
}
