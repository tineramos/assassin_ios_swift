//
//  Helper.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 05/08/2016.
//  Copyright © 2016 Tine Ramos. All rights reserved.
//

import UIKit

class Helper: NSObject {

    func isNull(obj: AnyObject?) -> Bool {
        let variable = obj
        return ((variable) != nil) ? true : false
    }
    
    // acknowledgement: http://stackoverflow.com/a/25471164
    class func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email)
    }
}
