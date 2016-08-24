//
//  InternalNotificationList.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 24/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import Foundation

class InternalNotificationList {
    
    class var sharedInstance: InternalNotificationList {
        struct Static {
            static let instance: InternalNotificationList = InternalNotificationList()
        }
        return Static.instance
    }
    
}