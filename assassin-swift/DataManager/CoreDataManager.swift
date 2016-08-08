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
    
    class CoreDataManager {
        static let sharedInstance = CoreDataManager()
    }
    
    override init() {
        super.init()
        managedObjectContext = ((UIApplication.sharedApplication().delegate) as! AppDelegate).managedObjectContext
        managedObjectContext?.undoManager = nil
    }
    
    

}
