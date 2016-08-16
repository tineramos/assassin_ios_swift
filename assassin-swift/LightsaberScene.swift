//
//  LightsaberScene.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 16/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import SceneKit

class LightsaberScene: SCNScene {

    let hilt = SCNNode()
    
    override init() {
        super.init()
        
        let image = UIImage.init(named: "lightsaber-hilt")
        
        hilt.position = SCNVector3(3, 0, 0)
        rootNode.addChildNode(hilt)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
