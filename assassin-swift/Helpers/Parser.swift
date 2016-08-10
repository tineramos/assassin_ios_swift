//
//  Parser.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 09/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

class Parser: NSObject {

    class func dateFromString(json: String) -> NSDate {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let theDate = formatter.dateFromString(json)
        
        return theDate!
        
    }
    
}
