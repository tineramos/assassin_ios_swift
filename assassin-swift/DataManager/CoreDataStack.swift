//
//  CoreDataStack.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 08/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit
import MagicalRecord

class CoreDataStack: NSObject {

    struct Constants {
        static let kPersistentStoreFileName = "AssassinSwift.sqlite"
    }
    
    static let sharedInstance = CoreDataStack()
    
    class var sharedManager: CoreDataStack {
        return sharedInstance
    }
    
    override init() {
        super.init()
        MagicalRecord.enableShorthandMethods()
        MagicalRecord.setupAutoMigratingCoreDataStack()
    }
    
    func clearCoreDataState() {
        NSManagedObjectContext.MR_defaultContext().MR_saveOnlySelfAndWait()
    }
    
    func cleanUp() {
        MagicalRecord.cleanUp()
    }
    
}
