//
//  LightsaberView.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 16/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

import AVFoundation

import SnapKit

class LightsaberView: UIView {
    
    // lightsaber
    var swingSound: AVAudioPlayer?
    var saberOn: AVAudioPlayer?
    var saberOff: AVAudioPlayer?
    
    var hiltButton = UIButton.init(type: .Custom)
    var lightsaberGlow = UIImageView.init(image: UIImage.init(named: "lightsaber-glow"))
    
    var isLsOn: Bool!
    
    let sensingKit = PlayingFieldViewController().sensingKit

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        swingSound = Helper.setupAudioPlayerWithFile("swing", type: "WAV")
        saberOn = Helper.setupAudioPlayerWithFile("saber-on", type: "wav")
        saberOff = Helper.setupAudioPlayerWithFile("saber-off", type: "wav")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func start() {
        isLsOn = false
        addLightsaberElements()
    }
    
    func startSensorForLightsaber() {
        
        if sensingKit.isSensorRegistered(.DeviceMotion) {
            
            sensingKit.subscribeToSensor(.DeviceMotion, withHandler: { (sensorType, sensorData) in
                
                let data = sensorData as! SKDeviceMotionData
                
                let accelerationX = data.userAcceleration.x
                let accelerationY = data.userAcceleration.y
                let accelerationZ = data.userAcceleration.z
                
                if accelerationX > 0.5 {
                    
                    let playFieldVC = Helper.getPlayingFieldViewController()
                    
                    playFieldVC!.turnOnFlash()
                    
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
                    
                    let distance = playFieldVC?.distanceToTarget
                    let distanceEstimate: Int = Int(floor(distance!))
                    
                    if distance >= 0.0 && distanceEstimate <= 1 {
                        playFieldVC!.attackWithDamage(Constants.Damage.lightsaber)
                    }
                    
//                    print("DISTANCE FROM LIGHTSABER VIEW: \(damage)")
                    
                    playFieldVC!.performSelector(#selector(PlayingFieldViewController().turnOffFlash), withObject: nil, afterDelay: 0.5)
                    
                }
                
            })
            
            sensingKit.startContinuousSensingWithSensor(.DeviceMotion)
            
        }
        
    }
    
    func addLightsaberElements() {
        
        let hiltImage = UIImage.init(named: "lightsaber-hilt")
        
        hiltButton.frame = CGRectMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) - 90.0, 15.0, 70.0)
        hiltButton.setBackgroundImage(hiltImage!, forState: .Normal)
        hiltButton.addTarget(self, action: #selector(hiltIsPressed), forControlEvents: .TouchUpInside)
        hiltButton.adjustsImageWhenHighlighted = false
        addSubview(hiltButton)
        
//        hiltButton.snp_makeConstraints { (make) in
//            make.left.equalTo(self.snp_centerX)
//            make.top.equalTo(CGRectGetMaxY(self.frame)).offset(-90)
//            make.width.equalTo(15.0)
//            make.height.equalTo(70.0)
//        }
        
        lightsaberGlow.frame = CGRectMake(CGRectGetMinX(hiltButton.frame) - 5, 0.0, 25.0, 0.0)
        lightsaberGlow.removeFromSuperview()
        
    }
    
    func hiltIsPressed() {
        
        if isLsOn == true {
            
            stopSensor()
            saberOff?.play()
            
            UIView.animateWithDuration(0.8, animations: {
                var f = self.lightsaberGlow.frame
                f.origin.y = CGRectGetMinY(self.hiltButton.frame) + 5
                f.size.height = 0
                self.lightsaberGlow.frame = f
            }, completion: { (finished) in
                self.lightsaberGlow.removeFromSuperview()
            })
            
        }
        else {
            
            startSensorForLightsaber()
            saberOn?.play()
            
            UIView.animateWithDuration(0.8, animations: {
                var f = self.lightsaberGlow.frame
                f.origin.y = CGRectGetMinY(self.hiltButton.frame) - 245.0
                f.size.height = 250.0
                self.lightsaberGlow.frame = f
            }, completion: { (finished) in
                self.addSubview(self.lightsaberGlow)
                self.insertSubview(self.lightsaberGlow, belowSubview: self.hiltButton)
            })
            
        }
        
        isLsOn = !isLsOn
        
    }
    
    override func removeFromSuperview() {
        stopSensor()
        super.removeFromSuperview()
    }
    
    func stopSensor() {
        
        if sensingKit.isSensorSensing(.DeviceMotion) {
            sensingKit.stopContinuousSensingWithSensor(.DeviceMotion)
        }
    }
    
}
