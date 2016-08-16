//
//  WeaponsViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 09/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

import SpriteKit
import AVFoundation

enum WeaponType: Int {
    case NerfGun    = 101
    case Poison     = 102
    case Lightsaber = 103
    case Bomb       = 104
    case Tripwire   = 105
}

class WeaponsViewController: BaseViewController {

    var weaponsList: [Weapon] = []
    var currentWeapon: WeaponType?
    
    @IBOutlet weak var weaponView: UIView?
    
    var nerfGunView: NerfGunView?
    var lightSaberView: LightSaberView?
    var bombView: BombView?
    
    let captureSession = AVCaptureSession()
    
    var captureDevice: AVCaptureDevice?
    
    var captureView: UIView!
    var captureLayer: AVCaptureVideoPreviewLayer!
    
    lazy var sensingKit = SensingKitLib.sharedSensingKitLib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        uncomment when bluetooth is available
//        openiBeaconProximity()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBarWithBackButtonType(BackButton.Black, andTitle: "")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        initializeSetup()
        openCameraPreview()
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
    
    // MARK: camera
    
    func initializeSetup() {
        
        captureView = UIView.init(frame: weaponView!.frame)
        captureView.bounds = weaponView!.bounds
        weaponView!.addSubview(captureView)
        weaponView!.sendSubviewToBack(captureView)
        
    }
    
    func openCameraPreview() {
        
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        let camera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        if camera == nil {
            return
        }
        
        do {
            
            let deviceInput = try AVCaptureDeviceInput.init(device: camera)
            captureSession.addInput(deviceInput)
            
            captureLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
            captureLayer.frame = captureView.bounds
            captureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            captureView.layer.addSublayer(captureLayer)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                self.captureSession.startRunning()
            })
            
        }
        catch let error as NSError {
            print("Error opening camera preview: \(error)")
        }
        
    }
    
    // MARK: Weapon Selection
    
    @IBAction func weaponButtonPressed(sender: UIButton) {
        
        let weaponTag = WeaponType(rawValue: sender.tag)!
        
        if weaponTag == currentWeapon {
            return
        }
        
        currentWeapon = weaponTag
        sensingKit.stopContinuousSensingWithAllRegisteredSensors()
        captureView?.subviews.forEach({ $0.removeFromSuperview() })
        
        switch weaponTag {
        case .NerfGun:
            nerfGunSimulation()
            break
        case .Poison:
            poisonSimulation()
            break
        case .Lightsaber:
            lightsaberSimulation()
            break
        case .Bomb:
            bombSimulation()
            break
        case .Tripwire:
            tripwireSimulation()
            break
        }
    }
    
    // MARK: NerfGun methods
    
    func nerfGunSimulation() {
        
        let crosshairImageView = UIImageView.init(image: UIImage.init(named: "crosshair-nerfgun"))
        crosshairImageView.frame = CGRectMake(0, 0, 50, 50)
        crosshairImageView.center = weaponView!.center
        captureView.addSubview(crosshairImageView)
        
    }
    
    // MARK: Poison methods
    
    func poisonSimulation() {
        
        
    }
    
    // MARK: Lightsaber methods
    
    func lightsaberSimulation() {
        registerDeviceMotion()
        
        
    }
    
    // MARK: Bomb methods
    
    func bombSimulation() {
        openLocation()
        
        // when bomb is planted, send coordinates to game host
    }
    
    // MARK: Tripwire methods
    
    func tripwireSimulation() {
        openLocation()
        
        // when tripwire is planted, send coordinates to game host
    }
    
    // MARK: Register Sensors
    
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
    
    func stopCameraPreview() {
        
        captureSession.stopRunning()
        captureLayer.removeFromSuperlayer()
        captureLayer = nil
        
    }
}
