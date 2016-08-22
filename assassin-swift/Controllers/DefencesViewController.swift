//
//  DefencesViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 09/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit
import SceneKit
import AVFoundation

enum DefenceType: Int {
    case Armour     = 201
    case GasMask    = 202
    case Shield     = 203
    case HPPotion   = 204
    case Detector   = 205   //pARk
}

class DefencesViewController: BaseViewController {

    var defencesList: [Defence] = []
    var currentDefence: DefenceType?
    
    let captureSession = AVCaptureSession()
    let captureViewTag: Int = 1024
    
    var captureDevice: NSArray?
    var captureView: UIView!
    var captureLayer: AVCaptureVideoPreviewLayer?
    var cameraNode: SCNNode!
    var deviceInput: AVCaptureDeviceInput?
    
    lazy var sensingKit = SensingKitLib.sharedSensingKitLib()
    
    @IBOutlet weak var defenceView: UIView?
    @IBOutlet weak var sceneView: SCNView?
    
    var hasDetectedPotion: Bool = false
    
    var shakeCoordinates: [CMAcceleration] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSceneView()
        setupCamera()
        
        registerSensors()
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if sensingKit.isSensorSensing(.DeviceMotion) {
            sensingKit.stopContinuousSensingWithSensor(.DeviceMotion)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setupCameraPreview()
    }
    
    func registerSensors() {
        if sensingKit.isSensorAvailable(.DeviceMotion) {
            let config: SKDeviceMotionConfiguration = SKDeviceMotionConfiguration.init()
            config.sampleRate = Constants.eventFrequency
            sensingKit.registerSensor(.DeviceMotion, withConfiguration: config)
        }
        
        // TODO: add more sensors here if needed
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Options
    
    @IBAction func defenceButtonPressed(sender: UIButton) {
        
        let defenceTag = DefenceType(rawValue: sender.tag)!
        
        if defenceTag == currentDefence {
            return
        }
        
        captureView.removeFromSuperview()
        captureLayer?.removeFromSuperlayer()
        captureSession.removeInput(deviceInput)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.captureSession.stopRunning()
        })
        
        currentDefence = defenceTag
        
        switch defenceTag {
        case .Armour:
            break
        case .GasMask:
            activateGasMask()
            break
        case .Shield:
            break
        case .Detector:
            activateProximityDetector()
            break
        default:
            break
        }
        
    }
    
    // MARK: Camera Preview
    
    func setupCameraPreview() {
        captureView = UIView.init(frame: defenceView!.frame)
        captureView.bounds = defenceView!.bounds
        captureView.tag = captureViewTag
    }
    
    func openCameraPreviewInPosition(position: AVCaptureDevicePosition) {
        
        captureDevice = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        
        if captureDevice?.count == 0 {
            return
        }
        
        do {
            
            var tempCaptureDevice:AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            
            for device in captureDevice! {
                let device = device as! AVCaptureDevice
                if device.position == position {
                    tempCaptureDevice = device
                    break
                }
            }
            
            deviceInput = try AVCaptureDeviceInput.init(device: tempCaptureDevice)
            captureSession.addInput(deviceInput)
            captureSession.sessionPreset = AVCaptureSessionPresetHigh
            
            captureLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
            captureLayer!.frame = captureView.bounds
            captureLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            captureView.layer.addSublayer(captureLayer!)
            
        }
        catch let error as NSError {
            print("Error opening camera preview: \(error)")
        }
        
    }
    
    // MARK: - Drinking Motion
    
    func startSensingSequenceForPotion() {
        startDeviceMotionForPotion()
    }
    
    func startDeviceMotionForPotion() {
        if sensingKit.isSensorRegistered(.DeviceMotion) {
            sensingKit.subscribeToSensor(.DeviceMotion, withHandler: { (sensorType, sensorData) in
                let data = sensorData as! SKDeviceMotionData
                let gravity = data.gravity as CMAcceleration
                
                // check z-axis if 0 since it's assume z-axis always approach 0
                if floor(fabs(gravity.z)) == 0 {
                    self.shakeCoordinates.append(gravity)
                }
                else {
                    self.drinkingMotionInterrupted()
                }
                
                print("start")
            })
            
            sensingKit.startContinuousSensingWithSensor(.DeviceMotion)
        }
    }
    
    func drinkingMotionInterrupted() {
        
        print("stahp")
        
        hasDetectedPotion = false
        sensingKit.stopContinuousSensingWithSensor(.DeviceMotion)
        
        analyseCollectedDataIfDrinkMotionIsDetected()
    }
    
    func analyseCollectedDataIfDrinkMotionIsDetected() -> Bool {
        
        if shakeCoordinates.count > 0 {
            
            var compareY: Double = -1.0
            var lastXValue: Double = 0.0
            var counter: Int = 0
            
            for acceleration in shakeCoordinates {
                
                if compareY <= acceleration.y {
                    compareY = acceleration.y
                    lastXValue = acceleration.x
                    counter += 1
                }
                
            }
            
            // clear all coordinates for next detection
            shakeCoordinates.removeAll()
            
            // check if last value of y is close to 1
            // add check for x coord to refine detection
            // and check if we have enough correct data
            if ceil(compareY) == 1.0 && floor(fabs(lastXValue)) == 0.0 && counter > 25 {
                return true
            }
            else {
                return false
            }
            
        }
        
        return false
        
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake && isDeviceReadyForDrinkingMotion() {
            print("shake triggered")
            hasDetectedPotion = true
            startSensingSequenceForPotion()
            
            // stop DeviceMotion sensor - just give it sometime to collect data
            performSelector(#selector(drinkingMotionInterrupted), withObject: nil, afterDelay: 2.0)
        }
    }
    
    func isDeviceReadyForDrinkingMotion() -> Bool {
        return Helper.isDeviceOrientationPortrait() && !hasDetectedPotion
    }
    
    // MARK: Proximity Detector
    
    func setupBackCamera() {
        defenceView!.addSubview(captureView)
        defenceView!.sendSubviewToBack(captureView)
        
        openCameraPreviewInPosition(AVCaptureDevicePosition.Back)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.captureSession.startRunning()
        })
    }
    
    func activateProximityDetector() {
        setupBackCamera()
        
//       TODO: setupARView
    }
    
    // MARK: GasMask
    
    func setupFrontCamera() {
        defenceView!.addSubview(captureView)
        defenceView!.sendSubviewToBack(captureView)
        
        openCameraPreviewInPosition(AVCaptureDevicePosition.Front)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.captureSession.startRunning()
        })
    }
    
    func activateGasMask() {
        setupFrontCamera()
        
        // TODO: add nodes
    }
    
    
    
}
