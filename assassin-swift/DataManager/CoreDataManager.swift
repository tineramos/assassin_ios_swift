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
    
    // MARK: - User methods
    
    func setCurrentActiveUser(params: NSDictionary, userBlock: UserBlock, failureBlock: FailureBlock) {

        NSManagedObjectContext.MR_defaultContext().MR_saveWithBlockAndWait { (context) in
            let newUser = User.init(managedObjectContext: context)
            
            if newUser != nil {
                newUser!.populateUserWithDictionary(params["user"] as! NSDictionary)
            }
        }
        
        let user = User.getUser()
        if user != nil {
            userBlock(user: user)
        }
        else {
            failureBlock(errorString: "User not created or found.")
        }
        
    }
    
    class func hasUserLoggedIn(completion: BoolBlock) {
        let currentUser = User.getUser()
        completion(bool: (currentUser != nil))
    }
    
    func logout() {
        NSManagedObjectContext.MR_defaultContext().MR_saveWithBlockAndWait { (context) in
            let allEntries: NSArray = (NSManagedObjectModel.MR_defaultManagedObjectModel()?.entities)!
            allEntries.enumerateObjectsUsingBlock({ (entityDescription, index, stop) in
                NSClassFromString(entityDescription.managedObjectClassName)?.MR_truncateAll()
            })
        }
    }
    
    // MARK: - Games method
    
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
            Game.populateGameWithDetails(gameDictionary, inContext: context)
        }
        
        let dictionary = gameDictionary["game"] as! NSDictionary
        let gameId = dictionary[GameAttributes.game_id.rawValue] as! Int
        let gameDetail = Game.MR_findFirstByAttribute(GameAttributes.game_id.rawValue, withValue: gameId)
        successBlock(game: gameDetail)
    }
    
    // MARK: - Weapons and Defences
    
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
    
    func savePlayerWithId(playerId: Int, successBlock: PlayerBlock, failureBlock: FailureBlock) {
        NSManagedObjectContext.MR_defaultContext().MR_saveWithBlockAndWait { (context) in
            Player.insertPlayerObjectWithId(playerId, inContext: context)
        }
        successBlock(player: Player.MR_findFirstByAttribute(PlayerAttributes.player_id.rawValue, withValue: playerId))
    }
    
    func deletePlayerWithId(playerId: Int, successBlock: BoolBlock, failureBlock: FailureBlock) {
        NSManagedObjectContext.MR_defaultContext().MR_saveWithBlockAndWait { (context) in
            let player = Player.MR_findFirstByAttribute(PlayerAttributes.player_id.rawValue, withValue: playerId)
            player?.MR_deleteEntityInContext(context)
        }
        
        let player = Player.MR_findFirstByAttribute(PlayerAttributes.player_id.rawValue, withValue: playerId)
        if player == nil {
            successBlock(bool: true)
        }
        else {
            failureBlock(errorString: "Player \(playerId) not removed in context")
        }
    }
    
    // MARK: - Game Play 
    
    func getAssassinObject(gameId: Int, playerId: Int, successBlock: AssassinBlock, failureBlock: FailureBlock) {
        NSManagedObjectContext.MR_defaultContext().MR_saveWithBlockAndWait { (context) in
            Assassin.getAssassinWithPlayerId(playerId, withGameId: gameId, inContext: context)
        }
        
        let predicate = NSPredicate(format: "(%K = %@) AND (%K = %@)",
                                    argumentArray: [AssassinAttributes.player_id.rawValue, playerId, AssassinAttributes.game_id.rawValue, gameId])
        successBlock(assassin: Assassin.MR_findFirstWithPredicate(predicate))
    }
    
    func saveTargetDetails(targetDictionary: NSDictionary, ofAssassin assassin: Assassin, successBlock: TargetBlock, failureBlock: FailureBlock) {
        NSManagedObjectContext.MR_defaultContext().MR_saveWithBlockAndWait { (context) in
            Target.populateTargetWithDictionary(targetDictionary, ofAssassin: assassin, inContext: context)
        }
        
        let targetId = targetDictionary[TargetAttributes.target_id.rawValue] as! Int
        successBlock(target: Target.MR_findFirstByAttribute(TargetAttributes.target_id.rawValue, withValue: targetId))
    }
    
    func saveAmmoForGameOfPlayer(playerId: Int, ammoDictionary: NSDictionary, successBlock: VoidBlock, failureBlock: FailureBlock) {
        NSManagedObjectContext.MR_defaultContext().MR_saveWithBlockAndWait { (context) in
            // we assume that an assassin object was created previously during downloading target details
            let assassin = Assassin.MR_findFirstByAttribute(AssassinAttributes.player_id.rawValue, withValue: playerId, inContext: context) as Assassin!
            assassin.populateWithAmmoDictionary(ammoDictionary, inContext: context)
        }
        successBlock()
    }
    
    func decrementQuantityOfWeapon(weaponId: Int, inPlayerWeaponObject object:PlayerWeapons, successBlock: BoolBlock, failureBlock: FailureBlock) {
        
    }
    
    func decrementQuantityOfDefence(defenceId: Int, inPlayerDefenceObject object:PlayerDefences, successBlock: BoolBlock, failureBlock: FailureBlock) {
        
    }
    
    /*
     
     NSManagedObjectContext.MR_defaultContext().MR_saveWithBlock({ (context) in
     
     }) { (success, error) in
     
     }
     
     */
    
}
