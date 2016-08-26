//
//  DataManager.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 07/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

import AFNetworking

class DataManager: AFHTTPSessionManager {
    
    struct DataManagerConstants {
//        let BASE_URL = "http://192.168.0.6:8000/api/v1/assassin/"
        let BASE_URL = "http://Tine.local:8000/api/v1/assassin/"
//        let BASE_URL = "http://assassin.app:8000/api/v1/assassin/"
    }
    
    static let sharedInstance = DataManager(baseURL: NSURL(string: DataManagerConstants().BASE_URL))
    
    class var sharedManager: DataManager {
        return sharedInstance
    }
    
    override init(baseURL url: NSURL?, sessionConfiguration configuration: NSURLSessionConfiguration?) {
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = ["Content-Type": "application/json"];
        
        super.init(baseURL: url, sessionConfiguration: configuration)
        self.requestSerializer = AFJSONRequestSerializer() as AFJSONRequestSerializer
        self.responseSerializer = AFJSONResponseSerializer() as AFJSONResponseSerializer
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - User methods
    
    func signUp(params: NSDictionary, successBlock: VoidBlock, failureBlock: FailureBlock) {
        
        self.POST("user", parameters: params, progress: nil, success: { (task, response) in
            
            CoreDataManager.sharedManager.setCurrentActiveUser(response as! NSDictionary, userBlock: { (user) -> (Void) in
                successBlock()
            }, failureBlock: { (errorString) -> (Void) in
                failureBlock(errorString: errorString)
            })
        
        }) { (task, error) in
            failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
    func loginUser(codeName: String, password: String, successBlock: BoolBlock, failureBlock: FailureBlock) {
        
        let params = [UserAttributes.code_name.rawValue: codeName,
                      UserAttributes.password.rawValue: password]
        
        self.POST("user/login", parameters: params, progress: nil, success: { (task, response) in
            
            let dictionary = response as! NSDictionary
            
            if let user = dictionary["success"] as? NSDictionary {
                CoreDataManager.sharedManager.setCurrentActiveUser(["user":user], userBlock: { (user) -> (Void) in
                    successBlock(bool: true)
                    }, failureBlock: { (errorString) -> (Void) in
                        failureBlock(errorString: errorString)
                })
            }
            else {
                failureBlock(errorString: "User not found.")
            }
            
            }) { (task, error) in
                failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
    // MARK: - Games methods
    
    func getGamesList(successBlock: ArrayBlock, failureBlock: FailureBlock) {
        
        self.GET("games", parameters: nil, progress: nil, success: { (task, response) in            
            CoreDataManager.sharedManager.saveGamesList(response as! NSArray, successBlock: { (array) -> (Void) in
                successBlock(array: array)
            }, failureBlock: { (errorString) -> (Void) in
                failureBlock(errorString: errorString)
            })
            
        }) { (task, error) in
            failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
    func getGameDetailOfId(gameId: Int, successBlock: GameBlock, failureBlock: FailureBlock) {
        
        let user = User.getUser()!
        let path = String(format: "game/gameId/\(gameId)/userId/\(user.user_id!)")
//        let path = String(format: "game/gameId/\(gameId)/userId/\(Constants.userId)")
        
        self.GET(path, parameters: nil, progress: nil, success: { (task, response) in
            CoreDataManager.sharedManager.saveGameInfo(response as! NSDictionary, successBlock: { (game) -> (Void) in
                successBlock(game: game)
            }, failureBlock: { (errorString) -> (Void) in
                failureBlock(errorString: errorString)
            })
        }) { (task, error) in
            failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
    func joinGame(game: Game, weapons: NSArray, defences: NSArray, successBlock: BoolBlock, failureBlock: FailureBlock) {
        
        let user = User.MR_findFirst() as User!
        
        let params = [GameAttributes.game_id.rawValue: game.game_id!,
                      UserAttributes.user_id.rawValue: user.user_id!,
                      AssassinRelationships.weapons.rawValue: weapons,
                      AssassinRelationships.defences.rawValue: defences] as NSDictionary
        
        self.POST("game/join", parameters: params, progress: nil, success: { (task, response) in
            let dictionary = response as! NSDictionary
            
            if (dictionary["success"] as! Bool) == true {
                
                let playerId = dictionary["player_id"] as! Int
                
                CoreDataManager.sharedManager.savePlayerWithId(playerId, successBlock: { (player) -> (Void) in
                    
                    if player != nil {
                        game.addPlayersObject(player!)
                        successBlock(bool: true)
                    }
                    
                    failureBlock(errorString: "Player object not created.")
                    
                    }, failureBlock: { (errorString) -> (Void) in
                        failureBlock(errorString: errorString)
                })
                
            }
            else {
                failureBlock(errorString: "Can not join game.")
            }
            
        }) { (task, error) in
            failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
    func leaveGame(playerId: Int, successBlock: BoolBlock, failureBlock: FailureBlock) {
        
        self.DELETE("game/leave/\(playerId)", parameters: nil, success: { (task, response) in
            
            let dictionary = response as! NSDictionary
            let success = dictionary["success"] as! Bool
            
            if success {
                CoreDataManager.sharedManager.deletePlayerWithId(playerId, successBlock: { (bool) -> (Void) in
                    successBlock(bool: bool)
                    }, failureBlock: { (errorString) -> (Void) in
                        failureBlock(errorString: errorString)
                })
            }
            else {
                
            }
            
            
            }) { (task, error) in
                failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
    // MARK: - Weapons
    
    func getWeaponsList(successBlock: ArrayBlock, failureBlock: FailureBlock) {
        
        self.GET("weapons", parameters: nil, progress: nil, success: { (task, response) in
            CoreDataManager.sharedManager.saveWeaponsList(response as! NSArray, successBlock: { (array) -> (Void) in
                successBlock(array: array)
            }, failureBlock: { (errorString) -> (Void) in
                failureBlock(errorString: errorString)
            })
        }) { (task, error) in
            failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
    func updateWeapons(playerId: Int, params: NSArray, successBlock: VoidBlock, failureBlock: FailureBlock) {
        
        self.PUT("player/changeWeapons/" + String(playerId), parameters: ["weapons": params], success: { (task, response) in
            // TODO: save list of weapons in core data bitch
            successBlock()
        }) { (task, error) in
            failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
    // MARK: - Defences
    
    func getDefencesList(successBlock: ArrayBlock, failureBlock: FailureBlock) {
        
        self.GET("defences", parameters: nil, progress: nil, success: { (task, response) in
            CoreDataManager.sharedManager.saveDefencesList(response as! NSArray, successBlock: { (array) -> (Void) in
                successBlock(array: array)
            }, failureBlock: { (errorString) -> (Void) in
                failureBlock(errorString: errorString)
            })
        }) { (task, error) in
            failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
    func updateDefences(playerId: Int, params: NSArray, successBlock: VoidBlock, failureBlock: FailureBlock) {
        
        self.PUT("player/changeDefences/" + String(playerId), parameters: ["defences": params], success: { (task, response) in
            // TODO: save list of defences in core data bitch
            successBlock()
        }) { (task, error) in
            failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
    // MARK: - GAMEPLAY
    
    func getTargetDetails(playerId: Int, ofAssassin assassin: Assassin, successBlock: TargetBlock, failureBlock: FailureBlock) {
        
        let user = User.MR_findFirst() as User!
        
        let path = String(format: "target/userId/\(user.user_id!)/playerId/\(playerId)")
        self.GET(path, parameters: nil, progress: nil, success: { (task, response) in
            CoreDataManager.sharedManager.saveTargetDetails(response as! NSDictionary, ofAssassin: assassin, successBlock: { (target) -> (Void) in
                successBlock(target: target)
                }, failureBlock: { (errorString) -> (Void) in
                    failureBlock(errorString: errorString)
            })
        }) { (task, error) in
            failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
    func getAmmoForGameOfPlayer(playerId: Int, successBlock: VoidBlock, failureBlock: FailureBlock) {
        let path = String(format: "gameplay/getammo/\(playerId)")
        
        self.GET(path, parameters: nil, progress: nil, success: { (task, response) in
            
            CoreDataManager.sharedManager.saveAmmoForGameOfPlayer(playerId, ammoDictionary: response as! NSDictionary, successBlock: { () -> (Void) in
                successBlock()
                }, failureBlock: { (errorString) -> (Void) in
                    failureBlock(errorString: errorString)
            })
            
        }) { (task, error) in
            failureBlock(errorString: error.localizedDescription)
        }
    }
    
    func getWeapons(playerId: Int, successBlock: ArrayBlock, failureBlock: FailureBlock) {
        let path = String(format: "gameplay/getweapons/\(playerId)")
        
        self.GET(path, parameters: nil, progress: nil, success: { (task, response) in
            //
            }) { (task, error) in
                failureBlock(errorString: error.localizedDescription)
        }
    }
    
    func getDefences(playerId: Int, successBlock: ArrayBlock, failureBlock: FailureBlock) {
        let path = String(format: "gameplay/getdefences/\(playerId)")
        
        self.GET(path, parameters: nil, progress: nil, success: { (task, response) in
            //
            }) { (task, error) in
                failureBlock(errorString: error.localizedDescription)
        }
    }
    
    // MARK: - Attack
    
    func attack(assassinId: Int, targetId: Int, gameId: Int, weaponId: Int, damage: Int, successBlock: BoolBlock, failureBlock: FailureBlock) {
        
        let params: [String: Int] = [AssassinAttributes.player_id.rawValue: assassinId,
                                     TargetAttributes.target_id.rawValue: targetId,
                                     GameAttributes.game_id.rawValue: gameId,
                                     WeaponAttributes.weapon_id.rawValue: weaponId,
                                     "damage": damage]
        
        self.PUT("gameplay/attack", parameters: params, success: { (task, response) in
            //
            }) { (task, error) in
                failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
    // MARK: - Defend
    
    func putUpDefence(playerId: Int, defenceId: Int, successBlock: BoolBlock, failureBlock: FailureBlock) {
        
        let params: [String:Int] = [PlayerAttributes.player_id.rawValue: playerId, DefenceAttributes.defence_id.rawValue: defenceId]
        
        self.PUT("gameplay/defend", parameters: params, success: { (task, response) in
            //
            }) { (task, error) in
                failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
}
