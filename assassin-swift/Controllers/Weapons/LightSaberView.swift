//
//  LightSaberView.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 10/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit
import AVFoundation

class LightSaberView: UIView {

    let captureSession = AVCaptureSession()
    
    var captureDevice: AVCaptureDevice?
    var swingSound: AVAudioPlayer?
    
    var sensing = WeaponsViewController().sensingKit
    
//    let swing = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("swing", ofType: "wav")!)
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let swingSound = self.setupAudioPlayerWithFile("swing", type: "WAV") {
            self.swingSound = swingSound
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func start() {
        
        if sensing.isSensorRegistered(.DeviceMotion) {
            
            sensing.subscribeToSensor(.DeviceMotion, withHandler: { (sensorType, sensorData) in
                
                let data = sensorData as! SKDeviceMotionData
                
                let accelerationX = data.userAcceleration.x
                let accelerationY = data.userAcceleration.y
                let accelerationZ = data.userAcceleration.z
                
                if accelerationX > 0.5 {
                    if accelerationZ < -0.5 {
                        print("LEFT swing")
                        print("Acceleration: \(accelerationX), \(accelerationY), \(accelerationZ)")
                    }
                    else if accelerationY > 0.5 {
                        print("RIGHT swing")
                        print("Acceleration: \(accelerationX), \(accelerationY), \(accelerationZ)")
                    }
                    
                    self.swingSound?.volume = 0.5
                    self.swingSound?.play()
                    
                }
                
            })
            
            sensing.startContinuousSensingWithSensor(.DeviceMotion)
            
        }
        
    }
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        
        var audioPlayer:AVAudioPlayer?
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
    }
    
}
