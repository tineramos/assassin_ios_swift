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
    
    class func getPlayingFieldViewController() -> PlayingFieldViewController? {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let navigationController = appDelegate.window?.rootViewController as! UINavigationController
        for viewController in navigationController.viewControllers {
            if viewController.isKindOfClass(PlayingFieldViewController) {
                return (viewController as! PlayingFieldViewController)
            }
        }
        
        return nil
    }
    
    class func isiPhone() -> Bool {
        return (UIDevice.currentDevice().userInterfaceIdiom == .Phone)
    }
    
    class func isiPad() -> Bool {
        return (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
    }
    
    class func isDeviceOrientationPortrait() -> Bool {
        return (UIDevice.currentDevice().orientation == .Portrait)
    }

    class func isDeviceOrientationUpsideDown() -> Bool {
        return (UIDevice.currentDevice().orientation == .PortraitUpsideDown)
    }
    
    class func registerSensors() {
        
        let sensingKit = SensingKitLib.sharedSensingKitLib()
        
        if sensingKit.isSensorAvailable(.DeviceMotion) && !sensingKit.isSensorRegistered(.DeviceMotion) {
            let config: SKDeviceMotionConfiguration = SKDeviceMotionConfiguration.init()
            config.sampleRate = Constants.eventFrequency
            sensingKit.registerSensor(.DeviceMotion, withConfiguration: config)
        }
        
        if sensingKit.isSensorAvailable(.Location) && !sensingKit.isSensorRegistered(.Location) {
            let config: SKLocationConfiguration = SKLocationConfiguration.init()
            config.locationAccuracy = .Best
            config.locationAuthorization = .WhenInUse
            sensingKit.registerSensor(.Location, withConfiguration: config)
        }
        
    }
    
    class func registerBeaconWithMajor(major: Int, andMinor minor: Int) {
        
        let sensingKit = SensingKitLib.sharedSensingKitLib()
        
        if sensingKit.isSensorAvailable(.iBeaconProximity) && !sensingKit.isSensorRegistered(.iBeaconProximity) {
            
            let uuid = NSUUID.init(UUIDString: Constants.kAssassinUUID)
            
            let config: SKiBeaconProximityConfiguration = SKiBeaconProximityConfiguration.init(UUID: uuid!)
            config.mode = .ScanAndBroadcast
            config.major = UInt16(major)    //  game_id
            config.minor = UInt16(minor)    //  player_id
            
            print("I has iBeaconProximity with major \(major) and minor \(minor)!!")
            
            sensingKit.registerSensor(.iBeaconProximity, withConfiguration: config)
        }
    }
    
    class func stopSensors() {
        
        let sensingKit = SensingKitLib.sharedSensingKitLib()
        
        if sensingKit.isSensorSensing(.DeviceMotion) {
            sensingKit.stopContinuousSensingWithSensor(.DeviceMotion)
        }

        if sensingKit.isSensorSensing(.Location) {
            sensingKit.stopContinuousSensingWithSensor(.Location)
        }
        
        if sensingKit.isSensorSensing(.iBeaconProximity) {
            sensingKit.stopContinuousSensingWithSensor(.iBeaconProximity)
        }
    
    }
    
}
