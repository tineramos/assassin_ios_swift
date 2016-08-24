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

class DefencesViewController: BaseViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    var defencesList: [Defence] = []
    var currentDefence: DefenceType?
    
    let captureViewTag: Int = 1024
    
    var captureDevice: NSArray?
    var captureView: UIView!
    var captureLayer: AVCaptureVideoPreviewLayer?
    var cameraNode: SCNNode!
    var deviceInput: AVCaptureDeviceInput?
    let videoOutput = AVCaptureVideoDataOutput()
    
    var faceDetector: CIDetector?
    
    lazy var sensingKit = SensingKitLib.sharedSensingKitLib()
    
    @IBOutlet weak var defenceView: UIView?
    @IBOutlet weak var sceneView: SCNView?
    
    var hasDetectedPotion: Bool = false
    
    var shakeCoordinates: [CMAcceleration] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSceneView()
        setupCamera()
        
        Helper.registerSensors()
    }
    
    lazy var cameraSession: AVCaptureSession = {
        let s = AVCaptureSession()
        s.sessionPreset = AVCaptureSessionPresetHigh
        return s
    }()
    
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
        Helper.stopSensors()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setupCameraPreview()
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
        
        resetCamera()
        currentDefence = defenceTag
        
        switch defenceTag {
        case .Armour:
            break
        case .GasMask:
            sceneView?.hidden = false
            activateGasMask()
            break
        case .Shield:
            break
        case .Detector:
            getProximityCoordinates()
            break
        default:
            break
        }
        
    }
    
    func resetCamera() {
        captureView.removeFromSuperview()
        captureLayer?.removeFromSuperlayer()
        cameraSession.removeInput(deviceInput)
        cameraSession.stopRunning()
        
        sceneView?.hidden = false
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
            
            cameraSession.beginConfiguration()
            
            deviceInput = try AVCaptureDeviceInput.init(device: tempCaptureDevice)
            cameraSession.addInput(deviceInput)
            
            if position == .Front && currentDefence == .GasMask {
                videoOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(unsignedInt: kCMPixelFormat_32BGRA)]
                videoOutput.alwaysDiscardsLateVideoFrames = true
//                (videoOutput.connectionWithMediaType(AVMediaTypeVideo)).enabled = true
                
                if cameraSession.canAddOutput(videoOutput) == true {
                    cameraSession.addOutput(videoOutput)
                }
            }
            
            captureLayer = AVCaptureVideoPreviewLayer.init(session: cameraSession)
            captureLayer!.frame = captureView.bounds
            captureLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            captureView.layer.addSublayer(captureLayer!)
            
            cameraSession.commitConfiguration()
            
            videoOutput.setSampleBufferDelegate(self, queue: dispatch_queue_create("sample buffer delegate", DISPATCH_QUEUE_SERIAL))
            
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
            self.cameraSession.startRunning()
        })
    }
    
    func getProximityCoordinates() {
        
        // add array of coordinates

        activateProximityDetector()
        
    }
    
    func activateProximityDetector() {
        setupBackCamera()
        
        // TODO: setupARView
    }
    
    // MARK: GasMask
    
    func setupFrontCameraForMask() {
        
        let gasmask: UIImage = UIImage.init(named: "gasmask-view")!
        let imageView: UIImageView = UIImageView.init(image: gasmask)
        imageView.frame = CGRectMake(0, 0, 400, 600)
        imageView.contentMode = .ScaleAspectFit
        imageView.center = (defenceView?.center)!
        defenceView!.addSubview(imageView)
        
        defenceView!.addSubview(captureView)
        defenceView!.sendSubviewToBack(captureView)
        
        openCameraPreviewInPosition(AVCaptureDevicePosition.Front)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.cameraSession.startRunning()
        })
    }
    
    func activateGasMask() {
        setupFrontCameraForMask()
        
        // TODO: add nodes
    }
    
    // CaptureOutput Delegate
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let cameraImage = CIImage(CVPixelBuffer: pixelBuffer!)
        
        let detectorOptions = [CIDetectorAccuracy:CIDetectorAccuracyHigh]
        let detector = CIDetector.init(ofType: CIDetectorTypeFace, context: nil, options:detectorOptions)
        let features = detector.featuresInImage(cameraImage, options: [CIDetectorImageOrientation: NSNumber.init(integer: 6)])  // to correctly detect face in portrait mode
        
        for f in features {
            
            let faceFeature: CIFaceFeature = f as! CIFaceFeature
//            let faceWidth = faceFeature.bounds.size.width
//            let faceHeight = faceFeature.bounds.size.height
            
            if faceFeature.hasLeftEyePosition && faceFeature.hasRightEyePosition && faceFeature.hasMouthPosition {
//                print("MOUTH POSITION") // interchange origin
//                print("x: \(faceFeature.mouthPosition.y)")
//                print("y: \(faceFeature.mouthPosition.x)")
//                
//                let mouthX = faceFeature.mouthPosition.y - faceWidth*0.2
//                let mouthY = faceFeature.mouthPosition.x - faceHeight*0.2
//                
//                print("computed x: \(mouthX)")
//                print("computed y: \(mouthY)")
                
                // get the clean aperture
                // the clean aperture is a rectangle that defines the portion of the encoded pixel dimensions
                // that represents image data valid for display.
//                let fdesc: CMFormatDescriptionRef = CMSampleBufferGetFormatDescription(sampleBuffer)!
//                let clap: CGRect = CMVideoFormatDescriptionGetCleanAperture(fdesc, false /*originIsTopLeft == false*/)
                
                // TODO: send gas mask
                DataManager.sharedManager.putUpDefence(Int(Constants.minor), defenceId: 3, successBlock: { (bool) -> (Void) in
                    
                    if bool {
                        // TODO: notify user that defence is activated
                    }
                    else {
                        // TODO: notify user -- defence activiation failed
                    }
                    
                    }, failureBlock: { (errorString) -> (Void) in
                        // TODO: notify user -- defence activiation failed
                        print("error: \(errorString)")
                })
                
                self.cameraSession.stopRunning()
                
            }
            
        }
    }
    
}
