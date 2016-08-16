//
//  WeaponsViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 09/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

import SceneKit
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
        
    let captureSession = AVCaptureSession()
    
    var captureDevice: AVCaptureDevice?
    var captureView: UIView!
    var captureLayer: AVCaptureVideoPreviewLayer!
    
    let captureViewTag: Int = 1024
    
    lazy var sensingKit = SensingKitLib.sharedSensingKitLib()
    
    @IBOutlet weak var weaponView: UIView?
    @IBOutlet weak var sceneView: SCNView?
    
    var lightsaberView: LightsaberView?
    
    var cameraNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSceneView()
        setupCamera()
        
        registerDeviceMotion()
        
//        TODO: uncomment when bluetooth is available
//        openiBeaconProximity()
    }
    
    func setupSceneView() {
        sceneView?.autoenablesDefaultLighting = true
        sceneView?.playing = true
    }
    
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y:5, z: 10)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationBarWithBackButtonType(BackButton.Black, andTitle: "")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setupCameraPreview()
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
    
    // MARK: Camera Preview
    
    func setupCameraPreview() {
        
        captureView = UIView.init(frame: weaponView!.frame)
        captureView.bounds = weaponView!.bounds
        captureView.tag = captureViewTag
        weaponView!.addSubview(captureView)
        weaponView!.sendSubviewToBack(captureView)
        
    }
    
    func openCameraPreview() {
        
        captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        if captureDevice == nil {
            return
        }
        
        do {
            
            captureSession.sessionPreset = AVCaptureSessionPresetHigh
            
            let deviceInput = try AVCaptureDeviceInput.init(device: captureDevice)
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
        
        weaponView?.subviews.forEach({
            if $0.tag != captureViewTag {
                $0.removeFromSuperview()
            }
        })
        
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
        
        sceneView?.hidden = false
        
        let crosshairImageView = UIImageView.init(image: UIImage.init(named: "crosshair-nerfgun"))
        crosshairImageView.frame = CGRectMake(0, 0, 50, 50)
        crosshairImageView.center = weaponView!.center
        weaponView!.addSubview(crosshairImageView)
        
    }
    
    // MARK: Poison methods
    
    func poisonSimulation() {
        
    }
    
    // MARK: Lightsaber methods
    
    func lightsaberSimulation() {
        
        sceneView?.hidden = true
        
        if lightsaberView == nil {
            lightsaberView = LightsaberView.init(frame: weaponView!.frame)
        }
        
        weaponView!.addSubview(lightsaberView!)
        lightsaberView?.start()
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
    
    // MARK: Flash
    
    func turnOnFlash() {
        
        if self.captureDevice!.hasTorch && self.captureDevice!.hasFlash {
            
            do {
                try self.captureDevice?.lockForConfiguration()
                
                self.captureDevice?.flashMode = AVCaptureFlashMode.On
                
                self.captureDevice?.torchMode = AVCaptureTorchMode.On
                try self.captureDevice?.setTorchModeOnWithLevel(1.0)
            } catch let error as NSError {
                print("Error opening camera flash: \(error)")
            }
            
        }
        
    }
    
    func turnOffFlash() {
        
        do {
            self.captureDevice?.flashMode = AVCaptureFlashMode.Off
            
            self.captureDevice?.torchMode = AVCaptureTorchMode.Off
            try self.captureDevice?.setTorchModeOnWithLevel(0.0)
        } catch let error as NSError {
            print("Error opening camera flash: \(error)")
        }
        
        
        captureDevice?.unlockForConfiguration()
    }
    
    // MARK: Register Sensors
    
    func registerDeviceMotion() {
        if sensingKit.isSensorAvailable(.DeviceMotion) {
            let config: SKDeviceMotionConfiguration = SKDeviceMotionConfiguration.init()
            config.sampleRate = Constants.eventFrequency
            sensingKit.registerSensor(.DeviceMotion, withConfiguration: config)
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
    
    // MARK: iBeacon
    
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
    
    func stopCameraPreview() {
        
        captureSession.stopRunning()
        captureLayer.removeFromSuperlayer()
        captureLayer = nil
        
    }
}
