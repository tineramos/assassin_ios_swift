//
//  StringExtension.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 05/08/2016.
//  Copyright © 2016 Tine Ramos. All rights reserved.
//
//  Acknowledgements: http://blog.oskoui-oskoui.com/?p=8812
//

import Foundation

extension String {
    
    var localized: String {
        
//        let path = NSBundle.mainBundle().pathForResource(lang, ofType: "lproj")        
//        let bundle = NSBundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), comment: "");
        
    }
    
}
