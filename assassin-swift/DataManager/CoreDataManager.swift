//
//  CoreDataManager.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 07/08/2016.
//  Copyright © 2016 Tine Ramos. All rights reserved.
//

import UIKit
import CoreData

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
    
    func getCurrentActiveUser(successBlock: UserBlock, failureBlock: FailureBlock) {
        
        let userFetchRequest = NSFetchRequest(entityName: User.entityName())
        userFetchRequest.fetchLimit = 1
        
        do {
            let fetchedUser = try managedObjectContext?.executeFetchRequest(userFetchRequest) as? [User]
            
            if fetchedUser?.count == 1 {
                successBlock(user: fetchedUser![0])
            }
            else {
                successBlock(user: User.MR_createEntity()!)
            }
            
        }
        catch {
            failureBlock(errorString: "Can not fetch user: \(error)")
        }
    }
    
    func setCurrentActiveUser(params: NSDictionary, userBlock: UserBlock, failureBlock: FailureBlock) {
        
        getCurrentActiveUser({ (newUser: User) -> (Void) in
            
            newUser.insertUserWithDictionary(params["user"] as! NSDictionary)
            userBlock(user: newUser)
            
        }) { (errorString) -> (Void) in
            failureBlock(errorString: errorString)
        }
        
    }

}
