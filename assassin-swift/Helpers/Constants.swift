//
//  Constants.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 07/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import Foundation

struct Constants {
  
    static let DEVICE_TOKEN = "devicetoken"
    
    static let fontCourierNewBold = "CourierNewPS-BoldMT"
    
    static let kAssassinUUID = "E7737784-23AB-41F7-8BCD-76C41978F0B7"
    
    static let eventFrequency: UInt = 45
    
    static let kTotalHP = 100
    
    static let kYes = "YES"
    static let kNo = "NO"
    
    
    // MARK: - iBeacon Constants
    
    static let kCalibratedPower = -58
    static let kRadNetworkConstantOne = 0.89976
    static let kRadNetworkConstantTwo = 7.7095
    static let kRadNetworkConstantThree = 0.111
    
    
    // MARK: - Weapons
    
    struct Damage {
        static let nerfGun      = 10
        static let lightsaber   = 10
        static let poisonGas    = 7
        static let bomb         = 50
    }
    
}
