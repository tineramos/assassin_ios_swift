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
    
    @IBOutlet weak var weaponView: UIView?
    
    var nerfGunView: NerfGunView?
    var lightSaberView: LightSaberView?
    
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
        
        weaponView?.subviews.forEach({ $0.removeFromSuperview() })
        
        print("the tag: \(sender.tag)")
        
        let weaponTag = WeaponType(rawValue: sender.tag)!
        
        switch weaponTag {
        case .NerfGun:
            nerfGunView = NerfGunView.init(frame: (weaponView?.frame)!)
            weaponView?.addSubview(nerfGunView!)
            nerfGunView?.start()
            break
        case .Poison:
            // TODO: show poison simulation
            openGyroscope()
            break
        case .Lightsaber:
            registerDeviceMotion()
            
            lightSaberView = LightSaberView.init(frame: (weaponView?.frame)!)
            weaponView?.addSubview(lightSaberView!)
            lightSaberView?.start()
            break
        default:
            break
        }
    }
    
    func registerDeviceMotion() {
        
        if sensingKit.isSensorRegistered(.DeviceMotion) {
            return
        }
        
        if sensingKit.isSensorAvailable(.DeviceMotion) {
            let config: SKDeviceMotionConfiguration = SKDeviceMotionConfiguration.init()
            config.sampleRate = Constants.eventFrequency
            sensingKit.registerSensor(.DeviceMotion, withConfiguration: config)
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
                    print("x: \(accelerometerData.acceleration.x)");
                    print("y: \(accelerometerData.acceleration.y)");
                    print("z: \(accelerometerData.acceleration.z)");
                    
                })
                 
                sensingKit.startContinuousSensingWithSensor(.Accelerometer)
                
            }
            
        }
        
    }
    
    func openGyroscope() {
        
        if sensingKit.isSensorAvailable(.Gyroscope) {
            
            print("I has Gyroscope!!")
            
            let config: SKGyroscopeConfiguration = SKGyroscopeConfiguration.init()
            config.sampleRate = Constants.eventFrequency
            
            sensingKit.registerSensor(.Gyroscope, withConfiguration: config)
            
            if sensingKit.isSensorRegistered(.Gyroscope) {
                
                sensingKit.subscribeToSensor(.Gyroscope, withHandler: { (sensorType, sensorData) in
                    
                    let gyroscopeData = sensorData as! SKGyroscopeData
                    print("===== GYROSCOPE =====");
                    print("x: \(gyroscopeData.rotationRate.x)");
                    print("y: \(gyroscopeData.rotationRate.y)");
                    print("z: \(gyroscopeData.rotationRate.z)");
                    
                    
                    
                })
                
                sensingKit.startContinuousSensingWithSensor(.Gyroscope)
                
            }
            
        }
        
    }
    
    func openDeviceMotion() {
        
        if sensingKit.isSensorAvailable(.DeviceMotion) {
            
            print("I has Device Motion!!")
            
            let config: SKDeviceMotionConfiguration = SKDeviceMotionConfiguration.init()
            config.sampleRate = Constants.eventFrequency
            
            
            sensingKit.registerSensor(.DeviceMotion, withConfiguration: config)
            
            if sensingKit.isSensorRegistered(.DeviceMotion ) {
                
                print("\(SKDeviceMotionData.csvHeader())")
                
                sensingKit.subscribeToSensor(.DeviceMotion, withHandler: { (sensorType, sensorData) in
                    
                    let motionDeviceData = sensorData as! SKDeviceMotionData
                    
                    print("\n--------------------------")
                    
//                    print("***** ATTITUDE *****");
//                    print("roll: ", motionDeviceData.attitude.roll);
//                    print("pitch: ", motionDeviceData.attitude.pitch);
//                    print("yaw: ", motionDeviceData.attitude.yaw);
//
//                    print("\n***** ROTATION RATE *****");
//                    print("x: ", motionDeviceData.rotationRate.x);
//                    print("y: ", motionDeviceData.rotationRate.y);
//                    print("z: ", motionDeviceData.rotationRate.z);
//
//                    print("\n***** ACCELEROMETER *****");
//                    print("x: ", motionDeviceData.userAcceleration.x);
//                    print("y: ", motionDeviceData.userAcceleration.y);
//                    print("z: ", motionDeviceData.userAcceleration.z);
//
//                    print("\n***** GRAVITY *****");
                    print("x: ", motionDeviceData.gravity.x);
//                    print("y: ", motionDeviceData.gravity.y);
                    print("z: ", motionDeviceData.gravity.z);
                    
//                    print("\(motionDeviceData.dictionaryData)")
                    
                })
                
            }
            
            sensingKit.startContinuousSensingWithSensor(.DeviceMotion)
            
        }
        
    }
    
    // MARK: Location/Proximity
    
    func openiBeaconProximity() {
        
        if sensingKit.isSensorAvailable(.iBeaconProximity) {
            
            let uuid = NSUUID.init(UUIDString: Constants.kAssassinUUID)
            
            let config: SKiBeaconProximityConfiguration = SKiBeaconProximityConfiguration.init(UUID: uuid!)
            config.mode = .ScanAndBroadcast
            config.major = 1    //  game_id
            config.minor = 1    //  player_id
            
            print("I has iBeaconProximity!!")
            
            sensingKit.registerSensor(.iBeaconProximity, withConfiguration: config)
            
            if sensingKit.isSensorRegistered(.iBeaconProximity) {
                
                sensingKit.subscribeToSensor(.iBeaconProximity, withHandler: { (sensorType, sensorData) in
                    
                    let iBeaconData = sensorData as! SKiBeaconDeviceData
                    print("iBeaconData: \(iBeaconData.proximityString)")
                    print("DATA: \(sensorData.dictionaryData)")
                    
                    // if minor == target_id
                    
                })
                
                sensingKit.startContinuousSensingWithSensor(.Location)
                
            }
            
        }
        
    }
    
    func openLocation() {
        
        if sensingKit.isSensorAvailable(.Location) {
            
            sensingKit.registerSensor(.Location)
            
            if sensingKit.isSensorRegistered(.Location) {
                
                sensingKit.subscribeToSensor(.Location, withHandler: { (sensorType, sensorData) in
                    
                    let locationData = sensorData as! SKLocationData
                    print("latitude: \(locationData.location.coordinate.latitude)")
                    print("longitude: \(locationData.location.coordinate.longitude)")
                    
                })
                
            }
            
            sensingKit.startContinuousSensingWithSensor(.Location)
            
        }
        
    }
    
//    // MARK:
//    
//    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
//        print("BEGAN")
//        print("motion: \(motion) with event: \(event)")
//    }
//    
//    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
//        print("ENDED")
//        print("motion: \(motion) with event: \(event)")
//    }
//    
}
