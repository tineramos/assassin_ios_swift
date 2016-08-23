//
//  NerfGunScene.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 21/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import SceneKit

class NerfGunScene: SCNScene {

    func display() {
        createGolfBullet()
    }
    
    func createGolfBullet() {
        let geometry = SCNSphere(radius: 1.5)
        geometry.firstMaterial?.diffuse.contents = UIColor.whiteColor()
        geometry.firstMaterial?.diffuse.wrapS = .ClampToBorder
        geometry.firstMaterial?.reflective.contents = "ball_texture.jpg"
        geometry.firstMaterial?.fresnelExponent = 1.3
        
        let sphere = SCNNode(geometry: geometry)
        sphere.position = SCNVector3(x: 0, y: 0, z: 0)
        sphere.physicsBody = SCNPhysicsBody.dynamicBody()
//        sphere.physicsBody!.restitution = 0.9
        
        rootNode.addChildNode(sphere)
        
        
    }
    
}
