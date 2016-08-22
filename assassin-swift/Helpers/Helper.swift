//
//  Helper.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 05/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

import AVFoundation

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
    
    class func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        
        var audioPlayer:AVAudioPlayer?
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
    }
    
    class func isDeviceOrientationPortrait() -> Bool {
        return (UIDevice.currentDevice().orientation == .Portrait)
    }

    class func isDeviceOrientationUpsideDown() -> Bool {
        return (UIDevice.currentDevice().orientation == .PortraitUpsideDown)
    }
    
}
