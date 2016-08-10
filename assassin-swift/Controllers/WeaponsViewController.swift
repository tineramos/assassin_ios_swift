//
//  WeaponsViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 09/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

enum WeaponType: Int {
    case NerfGun    = 101
    case Poison     = 102
    case Lightsaber = 103
    case Bomb       = 104
    case Tripwire   = 105
}

class WeaponsViewController: BaseViewController {

    var weaponsList: [Weapon] = []
    
    lazy var sensingKit = SensingKitLib.sharedSensingKitLib()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        openiBeaconProximity()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBarWithBackButtonType(BackButton.Black, andTitle: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func weaponButtonPressed(sender: UIButton) {
        
        sensingKit.stopContinuousSensingWithAllRegisteredSensors()
        
        print("the tag: \(sender.tag)")
        
        let weaponTag = WeaponType(rawValue: sender.tag)!
        
        switch weaponTag {
        case .NerfGun:
            // TODO: show nerf gun simulation
            break
        case .Poison:
            // TODO: show poison simulation
            break
        case .Lightsaber:
            // TODO: show lightsaber simulation
            break
        default:
            break
        }
    }
    
    func openAccelerometer() {
        
        if sensingKit.isSensorAvailable(.Accelerometer) {
            
            print("I has Accelerometer!!")
            
            sensingKit.registerSensor(.Accelerometer)
            
            if sensingKit.isSensorRegistered(.Accelerometer) {
                
                sensingKit.subscribeToSensor(.Accelerometer, withHandler: { (sensorType, sensorData) in
                    
                    let accelerometerData = sensorData as! SKAccelerometerData
                    print("===== ACCELEROMETER =====");
                    print("x: %f", accelerometerData.acceleration.x);
                    print("y: %f", accelerometerData.acceleration.y);
                    print("z: %f", accelerometerData.acceleration.z);
                    
                })
                
                sensingKit.startContinuousSensingWithSensor(.Accelerometer)
                
            }
            
        }
        
    }
    
    func openGyroscope() {
        
        if sensingKit.isSensorAvailable(.Gyroscope) {
            
            print("I has Gyroscope!!")
            
            sensingKit.registerSensor(.Gyroscope)
            
            if sensingKit.isSensorRegistered(.Gyroscope) {
                
                sensingKit.subscribeToSensor(.Gyroscope, withHandler: { (sensorType, sensorData) in
                    
                    let gyroscopeData = sensorData as! SKGyroscopeData
                    print("===== ACCELEROMETER =====");
                    print("x: %f", gyroscopeData.rotationRate.x);
                    print("y: %f", gyroscopeData.rotationRate.y);
                    print("z: %f", gyroscopeData.rotationRate.z);
                    
                })
                
                sensingKit.startContinuousSensingWithSensor(.Gyroscope)
                
            }
            
        }
        
    }
    
    func openiBeaconProximity() {
        
        if sensingKit.isSensorAvailable(.iBeaconProximity) {
            
            let uuid = NSUUID.init(UUIDString: Constants.kAssassinUUID)
            
            let config: SKiBeaconProximityConfiguration = SKiBeaconProximityConfiguration.init(UUID: uuid)
            config.mode = .ScanAndBroadcast
            config.major = 1    //  game_id
            config.minor = 1    //  player_id
            
            print("I has iBeaconProximity!!")
            
            sensingKit.registerSensor(.iBeaconProximity)
            
            if sensingKit.isSensorRegistered(.iBeaconProximity) {
                
                sensingKit.subscribeToSensor(.iBeaconProximity, withHandler: { (sensorType, sensorData) in
                    
                    let iBeaconData = sensorData as! SKiBeaconDeviceData
                    print("iBeaconData: \(iBeaconData.proximityString)")
                    print("DATA: \(sensorData.dictionaryData)")
                    
                    // if minor == target_id
                    
                })
                
                sensingKit.startContinuousSensingWithSensor(.Gyroscope)
                
            }
            
        }
        
    }
    
}
