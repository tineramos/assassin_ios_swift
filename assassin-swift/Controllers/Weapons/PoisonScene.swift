//
//  PoisonScene.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 19/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import SceneKit

class PoisonScene: SCNScene {

    let sensingKit = PlayingFieldViewController().sensingKit

    var cylinderGeometry: SCNCylinder!
    var poisonNode: SCNNode!
    
    func display() {
        cylinderGeometry = SCNCylinder(radius: 1.3, height: 3.5)
        cylinderGeometry.firstMaterial?.diffuse.contents = "poison-gas.jpg"
        cylinderGeometry.firstMaterial?.diffuse.mipFilter = .Linear
        
        poisonNode = SCNNode(geometry: cylinderGeometry)
        poisonNode.position = SCNVector3(x: 0, y: 2.5, z: 0)
        
        rootNode.addChildNode(poisonNode)
    }
    
    func throwPoison() {
        
        let randomZ: Float = 11.0
        let force = SCNVector3(x: 0, y: randomZ , z: -randomZ)
        poisonNode.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: nil)
        poisonNode.physicsBody?.velocity = SCNVector3Make(0, 0, -30)
        poisonNode.physicsBody?.applyForce(force, atPosition: SCNVector3Zero, impulse: true)    // apply force on center of the node
    
        // TODO: update CoreData of poison quantity
        
        let playFieldVC = Helper.getPlayingFieldViewController()
        playFieldVC?.attackWithDamage(Constants.Damage.nerfGun)
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
