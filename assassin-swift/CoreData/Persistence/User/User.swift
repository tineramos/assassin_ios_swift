import Foundation

import MagicalRecord

@objc(User)
public class User: _User {
	// Custom logic goes here.
    
    func getUser() -> User {
        return User.MR_findFirst()! as User
    }
    
    func insertUserWithDictionary(dictionary: NSDictionary) -> (User) {

        let user: User = User.MR_createEntity()!
        for (key, value) in dictionary {
            user.setValue(value, forKey: key as! String)
        }
        
        return user
        
    }
    
    func updateUserWithDictionary(dictionary: NSDictionary) -> (User) {
        
        let user: User = getUser()
        for (key, value) in dictionary {
            user.setValue(value, forKey: key as! String)
        }
        
        return user
        
    }
    
}
