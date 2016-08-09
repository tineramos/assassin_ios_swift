//
//  CoreDataManager.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 07/08/2016.
//  Copyright © 2016 Tine Ramos. All rights reserved.
//

import UIKit

import CoreData
import MagicalRecord

class CoreDataManager: NSObject {
    
    var managedObjectContext: NSManagedObjectContext?
    var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    
    static let sharedInstance = CoreDataManager()
    
    class var sharedManager: CoreDataManager {
        return sharedInstance
    }
    
    override init() {
        super.init()
        managedObjectContext = ((UIApplication.sharedApplication().delegate) as! AppDelegate).managedObjectContext
        managedObjectContext?.undoManager = nil
    }
    
    // MARK: User methods
    
    func setCurrentActiveUser(params: NSDictionary, userBlock: UserBlock, failureBlock: FailureBlock) {
        
        MagicalRecord.saveWithBlock({ (context) in
            
            let newUser = User.init(managedObjectContext: context)
            
            if newUser != nil {
                newUser!.populateUserWithDictionary(params["user"] as! NSDictionary)
            }
            
        }) { (success, error) in
            if success {
                userBlock(user: User.getUser())
            }
            else {
                failureBlock(errorString: "User entity not create")
            }
        }
        
    }
    
    class func hasUserLoggedIn(completion: BoolBlock) {
        let currentUser = User.getUser()
        completion(bool: (currentUser != nil))
    }
//    
//    func saveContext(completion: BoolBlock) {
//        managedObjectContext?.MR_saveToPersistentStoreWithCompletion({ (success, error) in
//            completion(bool: success)
//        })
//    }

}
