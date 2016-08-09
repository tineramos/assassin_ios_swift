import Foundation

import MagicalRecord

@objc(User)
public class User: _User {
	// Custom logic goes here.
    
    class func getUser() -> User? {
        return User.MR_findFirst() as User?
    }
    
    func populateUserWithDictionary(dictionary: NSDictionary) -> (User) {
        for (key, value) in dictionary {
            setValue(value, forKey: key as! String)
        }
        return self
    }
    
}
