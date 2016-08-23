//
//  Constants.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 07/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import Foundation

struct Constants {
    
    struct CoreDataModel {
        
        
        
    }
    
    static let fontCourierNewBold = "CourierNewPS-BoldMT"
    
    static let kAssassinUUID = "E7737784-23AB-41F7-8BCD-76C41978F0B7"
    
    static let eventFrequency: UInt = 45
    
    static let userId: Int = 3
    
    static let major: UInt16 = 4   // game id - open
    static let minor: UInt16 = (Helper.isIPhone() ? 4 : 5)
    
    static let target: UInt16 = (Helper.isIPhone() ? 5 : 4)
    
}
