//
//  UIViewExtension.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 06/08/2016.
//  Copyright © 2016 Tine Ramos. All rights reserved.
//

import Foundation

extension UIView {
    
    func setRadius(radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? 5.0
        self.layer.masksToBounds = true
    }
    
    func setBorderColor(color: CGColor? = UIColor.clearColor().CGColor) {
        self.layer.borderColor = color
        self.layer.borderWidth = 1
    }
    
}
