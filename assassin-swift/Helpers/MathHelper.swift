//
//  MathHelper.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 23/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

class MathHelper: NSObject {

    class func radiansToDegrees(radians: CGFloat) -> CGFloat {
        return ((radians) * (180.0 / CGFloat(M_PI)))
    }
    
    class func degreesToRadians(angle: CGFloat) -> CGFloat {
        return ((angle) / 180.0 * CGFloat(M_PI))
    }
    
    class func distanceOfFirstPoint(pointOne: CGPoint, pointTwo: CGPoint) -> CGFloat {
        let dx = fabs(pointTwo.x - pointOne.x)
        let dy = fabs(pointTwo.y - pointOne.y)
        return sqrt(dx*dx + dy*dy)
    }
    
    // MARK: - Bluetooth Distance Helper
    // http://developer.radiusnetworks.com/2014/12/04/fundamentals-of-beacon-ranging.html
    
    class func calculateDistance(rssi: Double) -> Double {
        if rssi == 0 {
            return -1.0 // distance can not be determined
        }
        
        let ratio: Double = rssi * 1.0 / Double(Constants.kCalibratedPower)
        if ratio < 1.0 {
            return pow(ratio, 10.0)
        }
        else {
            return (Constants.kRadNetworkConstantOne) * pow(ratio, Constants.kRadNetworkConstantTwo) + Constants.kRadNetworkConstantThree
        }
    }
    
}
