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

class DefencesViewController: UIViewController {

    var defencesList: [Defence] = []
    var currentDefence: DefenceType?
    
    let captureSession = AVCaptureSession()
    let captureViewTag: Int = 1024
    
    var captureDevice: AVCaptureDevice?
    var captureView: UIView!
    var captureLayer: AVCaptureVideoPreviewLayer!
    var cameraNode: SCNNode!
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        analyseCollectedData()
    }
    
    func analyseCollectedData() {
        
        if shakeCoordinates.count > 0 {
            
//            var didDrinkingMotionDetected: Bool = false
            
            var compareY: Double = -1.0
            var counter: Int = 0
            
            for acceleration in shakeCoordinates {
                
                if compareY <= acceleration.y {
                    compareY = acceleration.y
                    counter += 1
                }
                
            }
            
            // check if last value of y is close to 1
            if ceil(compareY) == 1.0 && counter > 10 {
                print("drink motion detected bitch")
            }
            else {
                print("nope. no drink motion!")
            }
            
            // clear all coordinates for next detection
            shakeCoordinates.removeAll()
            
        }
        else {
            return
        }
        
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
    
    @IBAction func activateProximityDetector() {
        
    }
    
}
