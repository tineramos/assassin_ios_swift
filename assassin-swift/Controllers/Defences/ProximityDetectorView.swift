//
//  ProximityDetectorView.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 22/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

typealias mat4f_t = [Float]
typealias vec4f_t = [Float]

let DEGREES_TO_RADIANS = Float((M_PI/180.0))

class ProximityDetectorView: UIView {
    
    var projectionTransform: mat4f_t = []
    var cameraTransform: mat4f_t = []
    var placesOfInterestCoordinates: vec4f_t = []
    
    let sensingKit = WeaponsViewController().sensingKit
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        // get captureView from DefencesVC
        
        startDeviceMotion()
        startLocation()
        
        // Initialize projection matrix
        projectionTransform.reserveCapacity(16)
        createProjectionMatrix(projectionTransform,
                               fovy: 60*DEGREES_TO_RADIANS,
                               aspect: Float(bounds.size.width * 1.0) / Float(bounds.size.height),
                               zNear: 0.25, zFar: 1000.0)
    }
    
    // MARK: - Sensors
    func startDeviceMotion() {
        
        if sensingKit.isSensorRegistered(.DeviceMotion) {
            
            sensingKit.subscribeToSensor(.DeviceMotion, withHandler: { (sensorType, sensorData) in
                
            })
            
            sensingKit.startContinuousSensingWithSensor(.DeviceMotion)
            
        }
        
    }
    
    func startLocation() {
        
        if sensingKit.isSensorRegistered(.Location) {
            
            sensingKit.subscribeToSensor(.Location, withHandler: { (sensorType, sensorData) in
                
            })
            
            sensingKit.startContinuousSensingWithSensor(.Location)
            
        }
        
    }
    
    // MARK: - Matrix methods

    func createProjectionMatrix(mout: mat4f_t, fovy: Float, aspect: Float, zNear: Float, zFar: Float) {
        
        var moutMut = mout
        
        let f = 1.0 / tanf(fovy/2.0)
        moutMut[0] = f/aspect
        moutMut[1] = 0.0
        moutMut[2] = 0.0
        moutMut[3] = 0.0
        
        moutMut[4] = 0.0
        moutMut[5] = f
        moutMut[6] = 0.0
        moutMut[7] = 0.0
        
        moutMut[8] = 0.0
        moutMut[9] = 0.0
        moutMut[10] = (zFar + zNear) / (zNear - zFar)
        moutMut[11] = -1.0
        
        moutMut[12] = 0.0
        moutMut[13] = 0.0
        moutMut[14] = 2 * zFar * zNear / (zNear - zFar)
        moutMut[15] = 0.0
    }
    
}
