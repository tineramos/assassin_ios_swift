//
//  PlayingFieldViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 07/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

import SceneKit
import QuartzCore
import AVFoundation

import SnapKit

enum PlayMode : Int {
    case Attack = 0
    case Defend = 1
}

enum WeaponType: Int {
    case NerfGun    = 101
    case Poison     = 102
    case Lightsaber = 103
    case Bomb       = 104
    case Knife      = 105
}

enum DefenceType: Int {
    case Armour     = 201
    case Shield     = 202
    case GasMask    = 203
    case HPPotion   = 204
    case Detector   = 205   //pARk
}

class PlayingFieldViewController: BaseViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    lazy var sensingKit = SensingKitLib.sharedSensingKitLib()
    
    // ** capture session** //
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var captureLayer: AVCaptureVideoPreviewLayer!
    
    var captureView: UIView!
    let captureViewTag: Int = 1024
    
    var playerId: Int = 0
    var gameId: Int = 0
    
    var assassin: Assassin!
    var target: Target!
    
    var playMode: PlayMode?
    var playerWeaponsList: [PlayerWeapons] = []
    var playerDefenceList: [PlayerDefences] = []
    
    @IBOutlet weak var playingView: UIView?
    @IBOutlet weak var sceneView: SCNView?
    @IBOutlet var buttonArray: [UIButton]!
    
    // ** WEAPONS ** //
    lazy var nerfGunScene: NerfGunScene = NerfGunScene.init()
    lazy var poisonScene: PoisonScene = PoisonScene.init()
    lazy var bombScene: BombScene = BombScene.init()
    
    // handles the broadcasted estimated distance between beacons
    var distanceToTarget: Double = 0.0
    
//    var weaponsList: [Weapon] = []  // handles the list of official weapons
    var currentWeapon: WeaponType?
    
    var hasDetectedTarget: Bool = false
    var isOnAttack: Bool = false
    
    // ** DEFENCES ** //
    
    let videoOutput = AVCaptureVideoDataOutput()
    var faceDetector: CIDetector?

    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.registerSensors()
//        registerSensorsForDetectingPlayMode()
        
        getAssassinObject()
        
        setupSceneView()
        
        Helper.registerBeaconWithMajor(gameId, andMinor: playerId)
        openiBeaconProximity()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBarWithBackButtonType(BackButton.Black, andTitle: "")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        Helper.stopSensors()
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
    
    // MARK: - Lazy Initialisation
    
    lazy var cameraSession: AVCaptureSession = {
        let s = AVCaptureSession()
        s.sessionPreset = AVCaptureSessionPresetHigh
        return s
    }()
    
    lazy var cameraNode: SCNNode = {
        let node = SCNNode()
        node.camera = SCNCamera()
        node.position = SCNVector3(x: 0, y:5, z: 10)
        return node
    }()
    
    lazy var targetView: TargetDetailsView = {
        let target = TargetDetailsView.instanceFromNib()
        target.setBorderColor(UIColor.blackColor().CGColor)
        return target as! TargetDetailsView
    }()
    
    lazy var lightsaberView: LightsaberView = {
        LightsaberView.init(frame: self.playingView!.frame)
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
        captureView = UIView.init(frame: playingView!.frame)
        captureView.bounds = playingView!.bounds
        captureView.tag = captureViewTag
        playingView!.addSubview(captureView)
        playingView!.sendSubviewToBack(captureView)
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
    
    // MARK: - Data methods
    
    func getAssassinObject() {
        CoreDataManager.sharedManager.getAssassinObject(gameId, playerId: playerId, successBlock: { (assassin) -> (Void) in
            
            if (assassin != nil) {
                self.assassin = assassin
                self.getTargetDetails()
            }
            else {
                self.showAlertErrorWithMessage("Assassin not found.")
            }
            
        }) { (errorString) -> (Void) in
            self.showAlertErrorWithMessage("GET ASSASSIN \(errorString)")
        }
    }
    
    func getTargetDetails() {
        
        DataManager.sharedManager.getTargetDetails(playerId, ofAssassin: self.assassin, successBlock: { (target) -> (Void) in
            
            if target != nil {
                self.target = target!
                self.getWeaponList()
            }
            else {
                self.showAlertErrorWithMessage("Target not found.")
            }
            
        }) { (errorString) -> (Void) in
            self.showAlertErrorWithMessage("TARGET DETAILS \(errorString)")
        }
    }
    
    func getWeaponList() {
        DataManager.sharedManager.getWeaponsList({ (array) -> (Void) in
            self.getDefenceList()
        }) { (errorString) -> (Void) in
            print(errorString)
            self.showAlertErrorWithMessage("WEAPONLIST: \(errorString)")
        }
    }
    
    func getDefenceList() {
        DataManager.sharedManager.getDefencesList({ (array) -> (Void) in
            self.getAmmoList()
        }) { (errorString) -> (Void) in
            print(errorString)
            self.showAlertErrorWithMessage("DEFENCELIST: \(errorString)")
        }
    }
    
    func getAmmoList() {
        
        DataManager.sharedManager.getAmmoForGameOfPlayer(playerId, successBlock: { (Void) -> (Void) in
            
            self.showAlertToShowTargetDetails()
            self.showWeaponsAndDefencesView()
            
            }) { (errorString) -> (Void) in
                self.showAlertErrorWithMessage("AMMO LIST \(errorString)")
        }
        
    }
    
    // MARK: - Alert methods
    
    func showAlertToShowTargetDetails() {
        let alertController = UIAlertController(title: "Target downloaded!", message: "", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Show", style: .Default) { (action) in
            self.showTargetDetails()
            })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Destructive) { (action) in })
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showAlertErrorWithMessage(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in })
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - View setup
    
    @IBAction func showTargetDetails() {
        
        if view.subviews.contains(targetView) {
            return
        }
        
        view.addSubview(targetView)
        targetView.showTargetView(target)
        
        targetView.snp_makeConstraints { (make) in
            make.width.equalTo(280.0)
            make.height.equalTo(210.0)
            make.center.equalTo(playingView!.snp_center)
        }
    }
    
    func showWeaponsAndDefencesView() {
        
        playerWeaponsList = self.assassin.weapons.allObjects as! [PlayerWeapons]
        playerDefenceList = self.assassin.defences.allObjects as! [PlayerDefences]
        
        setPlayMode(.Attack)
    }
    
    func setPlayMode(mode: PlayMode) {
        
        if playMode == mode {
            return
        }
        
        playMode = mode
        
        switch mode {
        case .Attack:
            switchToAttack()
            break
        case .Defend:
            switchToDefence()
            break
        }
        
    }
    
    func switchToAttack() {
        
        for (index, button) in buttonArray.enumerate() {
            let playerWeapon = playerWeaponsList[index]
            let weaponId = playerWeapon.weapon!.weapon_id!
            let imageName = String("weapon-\(weaponId)")
            let image = UIImage.init(named: imageName)
            button.tag = weaponId.integerValue + 100
            button.setBackgroundImage(image, forState: .Normal)
            button.addTarget(self, action: #selector(weaponButtonPressed), forControlEvents: .TouchUpInside)
        }
        
    }
    
    func switchToDefence() {
        
        for (index, button) in buttonArray.enumerate() {
            let playerDefence = playerDefenceList[index]
            let defenceId = playerDefence.defence!.defence_id!
            let imageName = String("defence-\(defenceId)")
            let image = UIImage.init(named: imageName)
            button.tag = defenceId.integerValue + 200
            button.setBackgroundImage(image, forState: .Normal)
//            button.addTarget(self, action: #selector(defenceButtonPressed:), forControlEvents: .TouchUpInside)
        }

    }
    
    @IBAction func segmentedControlValueChanged(segmentedControl: UISegmentedControl) {
        let value = segmentedControl.selectedSegmentIndex
        setPlayMode(PlayMode(rawValue: value)!)
    }
    
    // MARK: - Weapon Selection
    
    func weaponButtonPressed(sender: UIButton) {
        
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
        playingView!.addSubview(crosshairImageView)
        
        sceneView?.scene = nerfGunScene
        nerfGunScene.rootNode.addChildNode(cameraNode)
        nerfGunScene.display()
        
        crosshairImageView.snp_makeConstraints { (make) in
            make.width.equalTo(50.0)
            make.height.equalTo(50.0)
            make.center.equalTo((playingView?.snp_center)!)
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
        playingView!.addSubview(lightsaberView)
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
    
    // MARK: - Clean-up Methods
    
    func stopCameraPreview() {
        captureSession.stopRunning()
        captureLayer.removeFromSuperlayer()
        captureLayer = nil
    }
    
    func cleanWeaponView() {
        playingView?.subviews.forEach({
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
    
    // MARK: - Sensors
    // MARK: iBeacon Handler
    
    func openiBeaconProximity() {
        
        if sensingKit.isSensorRegistered(.iBeaconProximity) {
            
            sensingKit.subscribeToSensor(.iBeaconProximity, withHandler: { (sensorType, sensorData) in
                
                let proximityData = sensorData as! SKProximityData
                let devices = proximityData.devices as! [SKiBeaconDeviceData]
                
                // with the detected beacons, filter the desired device using target_id and game_id as minor and major values respectively //
                let targetBeacon = devices.filter {
                    ($0.major == UInt16(self.gameId) && $0.minor == UInt16(self.target.target_id!.integerValue))
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
    
    /*
    func registerSensorsForDetectingPlayMode() {
        
        if sensingKit.isSensorRegistered(.DeviceMotion) {
            
            sensingKit.subscribeToSensor(.DeviceMotion, withHandler: { (sensorType, sensorData) in
                
                let data = sensorData as! SKDeviceMotionData
                
                let accelerationX = data.userAcceleration.x
                let accelerationY = data.userAcceleration.y
                let accelerationZ = data.userAcceleration.z
                
                let attitude = data.attitude.roll
                let attitude = data.attitude.pitch
                let attitude = data.attitude.yaw
     
            })
            
        }
        
    }
    */
    
    // MARK: - Send attack
    
    func attackWithDamage(damage: Int) {
        
        print("attack with: \(currentWeapon) || DAMAGE is \(damage)")
        
        let weaponId = (currentWeapon?.rawValue)!
        
        DataManager.sharedManager.attack(playerId, targetId: (target.target_id?.integerValue)!, gameId: gameId, weaponId: weaponId, damage: damage, successBlock: { (bool) -> (Void) in
                print("ayun umatake!!!")
            }) { (errorString) -> (Void) in
                self.showAlertErrorWithMessage(errorString)
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

}
