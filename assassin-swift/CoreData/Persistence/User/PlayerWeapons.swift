import Foundation

import CoreData

@objc(PlayerWeapons)
public class PlayerWeapons: _PlayerWeapons {
	// Custom logic goes here.
    
    class func createWeaponWithDictionary(dictionary: NSDictionary, inContext context: NSManagedObjectContext) -> PlayerWeapons {
        let weapon = PlayerWeapons.init(managedObjectContext: context) as PlayerWeapons!
        weapon.setValue(dictionary[PlayerWeaponsAttributes.shots_left.rawValue], forKey: PlayerWeaponsAttributes.shots_left.rawValue)
        weapon.setValue(dictionary[PlayerWeaponsAttributes.in_use.rawValue], forKey: PlayerWeaponsAttributes.in_use.rawValue)
        
        // associate the weapon object
        let weaponId = dictionary[WeaponAttributes.weapon_id.rawValue] as! Int
        weapon.weapon = Weapon.getWeaponWithId(weaponId, inContext: context)
                
        return weapon
    }
    
    class func getWeaponDetailsOfPlayerId(playerId: Int, ofWeaponId weaponId: Int, inContext context: NSManagedObjectContext) {
        // TODO: additional method
    }
    
}
