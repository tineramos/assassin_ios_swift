//
//  BombScene.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 21/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import SceneKit

class BombScene: SCNScene {
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func display() {
        
        let geometry = SCNSphere(radius: 1.5)
        geometry.firstMaterial?.diffuse.contents = "bomb-2.jpg"
        geometry.firstMaterial?.diffuse.wrapS = .Repeat
//        geometry.firstMaterial?.reflective.contents =
        geometry.firstMaterial?.fresnelExponent = 1.0
        
        let sphere = SCNNode(geometry: geometry)
        sphere.position = SCNVector3(x: 3, y: 2, z: 0)
        
        sphere.physicsBody = SCNPhysicsBody.dynamicBody()
        sphere.physicsBody!.restitution = 0.9
        
        rootNode.addChildNode(sphere)
    }

}
