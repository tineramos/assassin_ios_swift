//
//  NerfGunScene.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 21/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import SceneKit

class NerfGunScene: SCNScene {

    var golfBulletNode: SCNNode!
    
    func display() {
        createGolfBullet()
    }

    func createGolfBullet() {
        let geometry = SCNSphere(radius: 1.5)
        geometry.firstMaterial?.diffuse.contents = UIColor.whiteColor()
        geometry.firstMaterial?.diffuse.wrapS = .ClampToBorder
        geometry.firstMaterial?.reflective.contents = "ball_texture.jpg"
        geometry.firstMaterial?.fresnelExponent = 1.5
        
        golfBulletNode = SCNNode(geometry: geometry)
        golfBulletNode.position = SCNVector3(x: 0, y: 0, z: 0)
        golfBulletNode.physicsBody?.mass = 0.04593 // set mass of the golf ball; nerf bullet is 0.0015kg
        golfBulletNode.physicsBody?.affectedByGravity = true
        
        rootNode.addChildNode(golfBulletNode)
    }
    
    // NOTE: standard speed of nerfgun: 14.69 m/s or 32. mi/h
    
    func shootGolfBall() {
        
        let randomZ: Float = 11.0
        let force = SCNVector3(x: 0, y: randomZ , z: -randomZ)
        golfBulletNode.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: nil)
        golfBulletNode.physicsBody?.velocity = SCNVector3Make(0, 0, -64)
        golfBulletNode.physicsBody?.applyForce(force, atPosition: SCNVector3Zero, impulse: true)    // apply force on center of the node
    
    }

}
