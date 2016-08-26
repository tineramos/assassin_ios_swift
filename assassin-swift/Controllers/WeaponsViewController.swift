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

import SnapKit

enum WeaponType: Int {
    case NerfGun    = 101
    case Poison     = 102
    case Lightsaber = 103
    case Bomb       = 104
    case Knife      = 105
}

class WeaponsViewController: BaseViewController {
        
    let captureSession = AVCaptureSession()
    let captureViewTag: Int = 1024
    
    var captureDevice: AVCaptureDevice?
    var captureView: UIView!
    var captureLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var weaponView: UIView?
    @IBOutlet weak var sceneView: SCNView?
    
    lazy var sensingKit = SensingKitLib.sharedSensingKitLib()
    lazy var nerfGunScene: NerfGunScene = NerfGunScene.init()
    lazy var poisonScene: PoisonScene = PoisonScene.init()
    lazy var bombScene: BombScene = BombScene.init()
    
    // handles the broadcasted estimated distance between beacons
    var distanceToTarget: Double = 0.0
    
    var weaponsList: [Weapon] = []  // handles the list of official weapons
    var currentWeapon: WeaponType?
    
    var hasDetectedTarget: Bool = false
    var isOnAttack: Bool = false
    
    var previousTouch: UITouch?
    var currentTouch: UITouch?
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // invoke centralised method to register sensors simultaneously
        Helper.registerSensors()

        setupSceneView()
        openiBeaconProximity()
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        Helper.stopSensors()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Lazy Initialisation
    
    lazy var cameraNode: SCNNode = {
        let node = SCNNode()
        node.camera = SCNCamera()
        node.position = SCNVector3(x: 0, y:5, z: 10)
        return node
    }()
    
    lazy var lightsaberView: LightsaberView = {
        LightsaberView.init(frame: self.weaponView!.frame)
    }()
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Scene Setup
    
    func setupSceneView() {
        sceneView?.autoenablesDefaultLighting = true
        sceneView?.playing = true
    }
    
    // MARK: - Camera Preview
    
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
    
    // MARK: - Weapon Selection
    
    @IBAction func weaponButtonPressed(sender: UIButton) {
        
        let weaponTag = WeaponType(rawValue: sender.tag)!
        
        if weaponTag == currentWeapon {
            return
        }
        
        currentWeapon = weaponTag
        
        cleanWeaponView()
        cleanScene()
        
        sceneView?.hidden = false
        
        switch weaponTag {
        case .NerfGun:
            nerfGunSimulation()
            break
        case .Poison:
            poisonSimulation()
            break
        case .Lightsaber:
            sceneView?.hidden = true
            lightsaberSimulation()
            break
        case .Bomb:
            bombSimulation()
            break
        case .Knife:
            knifeSimulation()
            break
        }
        
    }
    
    // MARK: - NerfGun methods
    
    func nerfGunSimulation() {
        
        let crosshairImageView = UIImageView.init(image: UIImage.init(named: "crosshair-nerfgun"))
        weaponView!.addSubview(crosshairImageView)
        
        sceneView?.scene = nerfGunScene
        nerfGunScene.rootNode.addChildNode(cameraNode)
        nerfGunScene.display()
        
        crosshairImageView.snp_makeConstraints { (make) in
            make.width.equalTo(50.0)
            make.height.equalTo(50.0)
            make.center.equalTo((weaponView?.snp_center)!)
        }

    }
    
    // MARK: - Poison methods
    
    func poisonSimulation() {
        sceneView?.scene = poisonScene
        poisonScene.rootNode.addChildNode(cameraNode)
        poisonScene.display()
    }
    
    // MARK: - Lightsaber methods
    
    func lightsaberSimulation() {
        weaponView!.addSubview(lightsaberView)
        lightsaberView.start()
    }
    
    // MARK: - Bomb methods
    
    func bombSimulation() {
//        openLocation()
        
        // when bomb is planted, send coordinates to game host
        
        sceneView!.scene = bombScene
        bombScene.rootNode.addChildNode(cameraNode)
        bombScene.display()
    }
    
    // MARK: - Knife methods
    func knifeSimulation() {
        
    }
    
    // MARK: - Flash
    
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
        self.captureDevice?.flashMode = AVCaptureFlashMode.Off
        self.captureDevice?.torchMode = AVCaptureTorchMode.Off
        captureDevice?.unlockForConfiguration()
    }
    
    // MARK: - Location Sensor Handler

    func openLocation() {
        
        if sensingKit.isSensorRegistered(.Location) {
            
            sensingKit.subscribeToSensor(.Location, withHandler: { (sensorType, sensorData) in
                
                let locationData = sensorData as! SKLocationData
                print("latitude: \(locationData.location.coordinate.latitude)")
                print("longitude: \(locationData.location.coordinate.longitude)")
                
                // get long lat and send to API
                
            })
            
            sensingKit.startContinuousSensingWithSensor(.Location)
            
        }
        
    }
    
    // MARK: - iBeacon Sensor Handler
    
    func openiBeaconProximity() {
        
        if sensingKit.isSensorRegistered(.iBeaconProximity) {
            
            sensingKit.subscribeToSensor(.iBeaconProximity, withHandler: { (sensorType, sensorData) in
                
                let proximityData = sensorData as! SKProximityData
                let devices = proximityData.devices as! [SKiBeaconDeviceData]
                
                // with the detected beacons, filter the desired device using target_id and game_id as minor and major values respectively //
                let targetBeacon = devices.filter {
                    ($0.major == Constants.major && $0.minor == Constants.target)
                }
                
                if targetBeacon.count > 0 {
                    if self.hasDetectedTarget == false {
                        self.hasDetectedTarget = true
                        self.targetDetected(self.hasDetectedTarget)
                    }
                    
                    if self.isOnAttack && self.hasDetectedTarget {
                        let beacon = targetBeacon.first!
                        self.distanceToTarget = MathHelper.calculateDistance(Double(beacon.rssi))
                    }
                }
                else {
                    // if target was previously detected but went out of range,
                    // set distanceToTarget = -1
                    // set hasDetected property to false
                    // and display alert that target can not be detected
                    if self.hasDetectedTarget == true {
                        self.distanceToTarget = -1
                        self.hasDetectedTarget = false
                        self.targetDetected(self.hasDetectedTarget)
                    }
                }
                

            })
            
            sensingKit.startContinuousSensingWithSensor(.iBeaconProximity)
            
        }
        
    }
    
    func targetDetected(detected: Bool) {
        if detected {
            showTargetDetectedAlert()
        }
        else {
            targetGoneAlert()
        }
    }
    
    func showTargetDetectedAlert() {
        let alertController = UIAlertController.init(title: "", message: "target.detected".localized, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "attack.title".localized, style: .Default) { (action) in
            print("weapons enabled!!")
            self.isOnAttack = true
            })
        alertController.addAction(UIAlertAction(title: "later.title".localized, style: .Destructive) { (action) in
            self.navigationController?.popViewControllerAnimated(true)
            })
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func targetGoneAlert() {
        let alertController = UIAlertController.init(title: "", message: "target.gone".localized, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in
            print("weapons disabled!!")
            self.isOnAttack = false
            })
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Clean-up Methods
    
    func stopCameraPreview() {
        captureSession.stopRunning()
        captureLayer.removeFromSuperlayer()
        captureLayer = nil
    }
    
    func cleanWeaponView() {
        weaponView?.subviews.forEach({
            if $0.tag != captureViewTag {
                $0.removeFromSuperview()
            }
        })
    }
    
    func cleanScene() {
        if sceneView?.scene == nil {
            return
        }
        
        for node in (sceneView?.scene?.rootNode.childNodes)! {
            node.removeFromParentNode()
        }
    }
    
    // MARK: - Handle Tap Interaction
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let positionInView = touch.locationInView(sceneView)
        print("position in view: \(positionInView)")
        
        if currentWeapon == WeaponType.NerfGun {
            nerfGunScene.shootGolfBall()
        }
        else if currentWeapon == WeaponType.Bomb {
            bombScene.throwBomb()
        }
        else if currentWeapon == WeaponType.Poison {
            poisonScene.throwPoison()
        }
    }
    
    // MARK: - Attack Methods
    
    
    
}
