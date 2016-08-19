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
    
    func display() {
        let geometry = SCNCylinder(radius: 1.3, height: 3.5)
        geometry.materials.first?.diffuse.contents = UIColor.greenColor()
        
        let cylinderNode = SCNNode(geometry: geometry)
        cylinderNode.physicsBody = SCNPhysicsBody(type: .Static, shape: nil)
        cylinderNode.position = SCNVector3(x: 2, y: 2.5, z: 0)
        
        let label = UILabel()
        label.textAlignment = .Center
        label.text = "Poison Gas"
        
        rootNode.addChildNode(cylinderNode)
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
