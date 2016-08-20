//
//  CoreDataManager.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 07/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

import CoreData
import MagicalRecord

class CoreDataManager: NSObject {
    
    static let sharedInstance = CoreDataManager()
    
    class var sharedManager: CoreDataManager {
        return sharedInstance
    }
    
    override init() {
        super.init()
    }
    
    // MARK: User methods
    
    func setCurrentActiveUser(params: NSDictionary, userBlock: UserBlock, failureBlock: FailureBlock) {

        NSManagedObjectContext.MR_defaultContext().MR_saveWithBlock({ (context) in
            
            let newUser = User.init(managedObjectContext: context)
            
            if newUser != nil {
                newUser!.populateUserWithDictionary(params["user"] as! NSDictionary)
            }
            
        }) { (success, error) in
            if success {
                userBlock(user: User.getUser())
            }
            else {
                failureBlock(errorString: "User not saved")
            }
        }
        
    }
    
    class func hasUserLoggedIn(completion: BoolBlock) {
        let currentUser = User.getUser()
        completion(bool: (currentUser != nil))
    }
    
    // MARK: Games method
    
    func saveGamesList(gamesList: NSArray, successBlock: ArrayBlock, failureBlock: FailureBlock) {
        NSManagedObjectContext.MR_defaultContext().MR_saveWithBlockAndWait { (context) in
            for dictionary in gamesList {
                Game.populateGameWithDictionary(dictionary as! NSDictionary, inContext: context)
            }
        }
        successBlock(array: Game.MR_findAll()!)
    }
    
    func saveGameInfo(gameDictionary: NSDictionary, successBlock: GameBlock, failureBlock: FailureBlock) {
        NSManagedObjectContext.MR_defaultContext().MR_saveWithBlockAndWait { (context) in
            let gameDetail = Game.populateGameWithDetails(gameDictionary, inContext: context)
            successBlock(game: gameDetail)
        }
    }
    
    // MARK: Weapons and Defences
    
    func saveWeaponsList(weaponsList: NSArray, successBlock: ArrayBlock, failureBlock: FailureBlock) {
        NSManagedObjectContext.MR_defaultContext().MR_saveWithBlockAndWait { (context) in
            for dictionary in weaponsList {
                Weapon.populateWeaponWithDictionary(dictionary as! NSDictionary, inContext: context)
            }
        }
        successBlock(array: Weapon.MR_findAll()!)
    }
    
    
    func saveDefencesList(defenceList: NSArray, successBlock: ArrayBlock, failureBlock: FailureBlock) {
        NSManagedObjectContext.MR_defaultContext().MR_saveWithBlockAndWait { (context) in
            for dictionary in defenceList {
                Defence.populateDefenceWithDictionary(dictionary as! NSDictionary, inContext: context)
            }
        }
        successBlock(array: Defence.MR_findAll()!)
    }
    
    /*
     
     NSManagedObjectContext.MR_defaultContext().MR_saveWithBlock({ (context) in
     
     }) { (success, error) in
     
     }
     
     */
    
}
