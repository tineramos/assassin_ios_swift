//
//  BombScene.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 21/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import SceneKit

class BombScene: SCNScene {

    var sphereGeometry: SCNSphere!
    var bombNode: SCNNode!
    
    let sensingKit = PlayingFieldViewController().sensingKit
    
    func display() {
        
        sphereGeometry = SCNSphere(radius: 1.5)
        sphereGeometry.firstMaterial?.diffuse.contents = "bomb-2.jpg"
        sphereGeometry.firstMaterial?.diffuse.wrapS = .Repeat
        sphereGeometry.firstMaterial?.fresnelExponent = 1.0
        
        bombNode = SCNNode(geometry: sphereGeometry)
        bombNode.position = SCNVector3(x: 0, y: 2, z: 0)
        bombNode.physicsBody?.mass = 0.397  // mass of m67 grenade
        bombNode.physicsBody?.affectedByGravity = true
        
        rootNode.addChildNode(bombNode)
    }
    
    func throwBomb() {
        let randomZ: Float = 11.0
        let force = SCNVector3(x: 0, y: randomZ , z: -randomZ)
        bombNode.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: nil)
        bombNode.physicsBody?.velocity = SCNVector3Make(0, 0, -10)
        bombNode.physicsBody?.applyForce(force, atPosition: SCNVector3Zero, impulse: true)    // apply force on center of the node
        
       startSensingForLocation()
        
    }
    
    func startSensingForLocation() {
        
        // MARK: - Location Sensor Handler
        
        if sensingKit.isSensorRegistered(.Location) {
            
            sensingKit.subscribeToSensor(.Location, withHandler: { (sensorType, sensorData) in
                
                let locationData = sensorData as! SKLocationData
                print("latitude: \(locationData.location.coordinate.latitude)")
                print("longitude: \(locationData.location.coordinate.longitude)")
                
                // get long lat and send to API
                let latitude = locationData.location.coordinate.latitude
                let longitude = locationData.location.coordinate.longitude
                
                // once sent, stop the sensing to save battery
                self.sensingKit.stopContinuousSensingWithSensor(.Location)
                
            })
            
            sensingKit.startContinuousSensingWithSensor(.Location)
            
        }
        
    }

}
