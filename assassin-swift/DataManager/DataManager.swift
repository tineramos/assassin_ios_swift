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
    
    // TODO: add public methods!!
    
    func signUp(params: NSDictionary, successBlock: (Void) -> (Void), failureBlock: (error: String) -> (Void)) {
        
        self.POST("user/", parameters: params, progress: nil, success: { (task, response) in
            print("response is: \(response)")
            successBlock()
            }) { (task, error) in
                failureBlock(error: error.localizedDescription)
        }
    }

    func getGamesList(successBlock: (gamesList: NSArray!) -> (Void), failureBlock: (error: String) -> (Void)) {
        self.GET("games", parameters: nil, progress: nil, success: { (task, response) in
            // TODO: save in CoreData bitch
            successBlock(gamesList: response as! NSArray)
            }) { (task, error) in
                failureBlock(error: error.localizedDescription)
        }
    }
}
