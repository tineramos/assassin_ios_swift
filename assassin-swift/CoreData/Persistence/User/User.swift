import Foundation

@objc(User)
public class User: _User {
	// Custom logic goes here.
    
    class func getUser() -> User? {
        return User.MR_findFirst() as User?
    }
    
    func populateUserWithDictionary(dictionary: NSDictionary) -> (User) {
        for (key, value) in dictionary {
            
            if !self.respondsToSelector(NSSelectorFromString(key as! String)) {
                continue
            }
            
            setValue(value, forKey: key as! String)
        }
        return self
    }
    
}
