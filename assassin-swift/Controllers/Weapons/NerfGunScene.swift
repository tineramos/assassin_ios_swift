//
//  NerfGunScene.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 21/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import SceneKit

class NerfGunScene: SCNScene {
    
    var sphereGeometry: SCNSphere!
    var golfBulletNode: SCNNode!
    
    var numberOfShots: Int = 10
    
    func display() {
        
        // TODO: fetch number of shots left
        
        sphereGeometry = SCNSphere(radius: 1.5)
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.whiteColor()
        sphereGeometry.firstMaterial?.diffuse.wrapS = .ClampToBorder
        sphereGeometry.firstMaterial?.reflective.contents = "ball_texture.jpg"
        sphereGeometry.firstMaterial?.fresnelExponent = 1.5
        
        if numberOfShots > 0 {
            createGolfBullet()
        }

    }

    func createGolfBullet() {
        
        golfBulletNode = SCNNode(geometry: sphereGeometry)
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
    
        numberOfShots -= 1
        
        let playFieldVC = Helper.getPlayingFieldViewController()
        let distance = playFieldVC!.distanceToTarget
        let distanceEstimate = Int(floor(distance))
        playFieldVC?.attackWithDamage(Constants.Damage.nerfGun / distanceEstimate)
        
        performSelector(#selector(display), withObject: nil, afterDelay: 2.0)
        
    }

}
