//
//  NerfGunView.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 10/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit
import AVFoundation

import Masonry

class NerfGunView: UIView {

    let captureSession = AVCaptureSession()
    
    var captureDevice: AVCaptureDevice?
    
    var captureView: UIView!
    var captureLayer: AVCaptureVideoPreviewLayer!
    
    var sensingKit = WeaponsViewController().sensingKit

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSetup()
    }
    
    func initializeSetup() {
        
        captureView = UIView.init(frame: bounds)
        captureView.bounds = bounds
        addSubview(captureView)
        sendSubviewToBack(captureView)
        
    }
    
    // MARK: Start sensors and open views
    
    func start() {
        startDeviceMotionSensor()
        openCameraPreview()
    }
    
    func startDeviceMotionSensor() {
        // Start device motion sensor
        print("Start device motion sensor")
    }
    
    func openCameraPreview() {
        
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
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
            
            let crosshairImageView = UIImageView.init(image: UIImage.init(named: "crosshair-nerfgun"))
            crosshairImageView.center = center
            captureView.addSubview(crosshairImageView)
//            crosshairImageView.mas_makeConstraints{ make in
//                make.center.equalTo()(self)
//                return()
//            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { 
                self.captureSession.startRunning()
            })
            
        }
        catch let error as NSError {
            print("Error opening camera preview: \(error)")
        }
        
    }
    
    // MARK: Stop sensors and hide views

    func stop() {
        stopDeviceMotionSensor()
        stopCameraPreview()
    }
    
    func stopDeviceMotionSensor() {
        // Stop device motion sensor
        print("Stop device motion sensor")
    }
    
    func stopCameraPreview() {
        
        captureSession.stopRunning()
        captureLayer.removeFromSuperlayer()
        captureLayer = nil
        
    }
    
}
