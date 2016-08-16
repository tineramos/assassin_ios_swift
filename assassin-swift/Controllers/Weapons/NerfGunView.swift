//
//  NerfGunView.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 10/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit
import AVFoundation

class NerfGunView: UIView {

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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Start sensors and open views
    
    func start() {
        startDeviceMotionSensor()
    }
    
    func startDeviceMotionSensor() {
        // Start device motion sensor
        print("Start device motion sensor")
    }
    
    // MARK: Stop sensors and hide views

    func stop() {
        stopDeviceMotionSensor()
    }
    
    func stopDeviceMotionSensor() {
        // Stop device motion sensor
        print("Stop device motion sensor")
    }
    
}
