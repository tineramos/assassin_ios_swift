//
//  KnifeView.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 29/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

class KnifeView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let sensingKit = PlayingFieldViewController().sensingKit
    
    func display() {
        let knifeImageView = UIImageView.init(image: UIImage(named: "knife"))
        knifeImageView.contentMode = UIViewContentMode.ScaleAspectFit
        addSubview(knifeImageView)
        
        knifeImageView.snp_makeConstraints { (make) in
            make.height.equalTo(CGRectGetHeight(self.frame) - 20.0)
            make.width.equalTo(50.0)
            make.center.equalTo(self.center)
        }
        
        startDeviceMotionSensor()
    }
    
    func startDeviceMotionSensor() {
        
        if sensingKit.isSensorRegistered(.DeviceMotion) {
            
            sensingKit.subscribeToSensor(.DeviceMotion, withHandler: { (sensorType, sensorData) in
                
                let data = sensorData as! SKDeviceMotionData
                
                let accelerationX = data.userAcceleration.x
                let accelerationY = data.userAcceleration.y
                let accelerationZ = data.userAcceleration.z
                
                if accelerationY < -3 {
                    
                }
                
            })
            
            sensingKit.startContinuousSensingWithSensor(.DeviceMotion)
            
        }
        
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
