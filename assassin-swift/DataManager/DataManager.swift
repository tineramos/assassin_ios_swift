//
//  DataManager.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 07/08/2016.
//  Copyright © 2016 Tine Ramos. All rights reserved.
//

import UIKit

import AFNetworking

class DataManager: AFHTTPSessionManager {
    
    struct DataManagerConstants {
        let BASE_URL = "http://localhost:8000/api/v1/assassin/"
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
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func getGamesList(successBlock: ArrayBlock, failureBlock: FailureBlock) {
        
        self.GET("games", parameters: nil, progress: nil, success: { (task, response) in
            // TODO: save in CoreData bitch
            successBlock(array: response as! NSArray)
        }) { (task, error) in
            failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
    func getWeaponsList(successBlock: ArrayBlock, failureBlock: FailureBlock) {
        
        self.GET("weapons", parameters: nil, progress: nil, success: { (task, response) in
            // TODO: save list of weapons in core data bitch
            successBlock(array: response as! NSArray)
        }) { (task, error) in
            failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
    func getDefencesList(successBlock: ArrayBlock, failureBlock: FailureBlock) {
        
        self.GET("defences", parameters: nil, progress: nil, success: { (task, response) in
            // TODO: save list of defences in core data bitch
            successBlock(array: response as! NSArray)
        }) { (task, error) in
            failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
    func updateWeapons(playerId: Int, params: NSArray, successBlock: VoidBlock, failureBlock: FailureBlock) {
       
        self.PUT("/player/changeWeapons/" + String(playerId), parameters: ["weapons": params], success: { (task, response) in
            // TODO: save list of defences in core data bitch
            successBlock()
        }) { (task, error) in
            failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
    func updateDefences(playerId: Int, params: NSArray, successBlock: VoidBlock, failureBlock: FailureBlock) {
        
        self.PUT("/player/changeDefences/" + String(playerId), parameters: ["defences": params], success: { (task, response) in
            // TODO: save list of defences in core data bitch
            successBlock()
        }) { (task, error) in
            failureBlock(errorString: error.localizedDescription)
        }
        
    }
    
}
