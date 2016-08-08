//
//  CoreDataStack.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 08/08/2016.
//  Copyright © 2016 Tine Ramos. All rights reserved.
//

import UIKit
import MagicalRecord

class CoreDataStack: NSObject {

    struct Constants {
        static let kPersistentStoreFileName = "AssassinSwift.sqlite"
    }
    
    func setup() {
        MagicalRecord.enableShorthandMethods()
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed(Constants.kPersistentStoreFileName)
    }
    
    func clearCoreDataState() {
        NSManagedObjectContext.MR_defaultContext().MR_saveOnlySelfAndWait()
    }
    
    func cleanUp() {
        MagicalRecord.cleanUp()
    }
    
}
