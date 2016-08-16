//
//  BombView.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 15/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

import SpriteKit

class BombView: SKScene {

    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor.clearColor()
        view.allowsTransparency = true
    }
    
    func createBomb() {
        let bomb: SKSpriteNode  = SKSpriteNode(imageNamed: "bomb-3d")
        
        bomb.position = CGPoint(x: 0, y: 0)
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: bomb.size.width/2)
        self.addChild(bomb)
    }
    
    override func update(currentTime: NSTimeInterval) {
        
    }

}
