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
        
//        physicsWorld.gravity = SCNVector3(x: 0, y: 0, z: -9.8)
        
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
        
//        shootGolfBall()
        
        rootNode.addChildNode(golfBulletNode)
    }
    
    // NOTE: standard speed of nerfgun: 14.69 m/s or 32. mi/h
    
    func shootGolfBall() {
        print("do shooting action")
        
//        var p: GLKVector3 = SCNVector3ToGLKVector3(golfBulletNode.presentationNode.position)
        
        
//        geometryNode.physicsBody?.applyForce(force, atPosition: position, impulse: true)

        // TODO: get distance and send shoot attack
//
//        golfBulletNode.physicsBody.
//        let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
//        SCNTransaction.begin()
//        
//        golfBulletNode.physicsBody?.velocity = SCNVector3Make(0, 1, 3)
        
//
//        SCNTransaction.commit()
        
//        let randomY: Float = 5.0
        let randomZ: Float = 11.0
        let force = SCNVector3(x: 0, y: randomZ , z: -randomZ)
        let position = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
        golfBulletNode.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: nil)
        golfBulletNode.physicsBody?.velocity = SCNVector3Make(0, 0, -64)
//        golfBulletNode.physicsBody?.angularVelocity = SCNVector4Make(0.0, 14, 14, 2)    // rotate object in x-axis
        golfBulletNode.physicsBody?.applyForce(force, atPosition: position, impulse: true)
//        golfBulletNode.runAction(SCNAction.sequence([SCNAction.waitForDuration(2.0),
//                                 SCNAction.fadeOutWithDuration(0.125),
//                                 SCNAction.removeFromParentNode()]))
    }
    

}
