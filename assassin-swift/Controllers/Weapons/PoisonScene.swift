//
//  PoisonScene.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 19/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import SceneKit

class PoisonScene: SCNScene {

    let sensingKit = WeaponsViewController().sensingKit
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func display() {
        let geometry = SCNCylinder(radius: 1.3, height: 3.5)
        geometry.firstMaterial?.diffuse.contents = "poison-gas.jpg"
        geometry.firstMaterial?.diffuse.mipFilter = .Linear
        
//        geometry.materials.first?.diffuse.contents = UIColor.greenColor()
        
        let cylinder = SCNNode(geometry: geometry)
        cylinder.position = SCNVector3(x: 2, y: 2.5, z: 0)
        
        rootNode.addChildNode(cylinder)
    }
    
    func startSensorForPoison() {
        
        if sensingKit.isSensorRegistered(.DeviceMotion) {
            
            sensingKit.subscribeToSensor(.DeviceMotion, withHandler: { (sensorType, sensorData) in
                
//                let data = sensorData as! SKDeviceMotionData
                
//                let accelerationX = data.userAcceleration.x
//                let accelerationY = data.userAcceleration.y
//                let accelerationZ = data.userAcceleration.z
//                
//                let rotationRateX = data.rotationRate.x
//                let rotationRateY = data.rotationRate.y
//                let rotationRateZ = data.rotationRate.z
                
                
                
            })
            
        }
        
    }
    
    
    
}
