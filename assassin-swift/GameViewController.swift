//
//  GameViewController.swift
//  assassin-swift
//
//  Created by Tine Ramos on 04/08/2016.
//  Copyright (c) 2016 Tine Ramos. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sensing = SensingKitLib.sharedSensingKitLib()
        
        if sensing.isSensorAvailable(SKSensorType.Battery) {
            
            print("i has battery sensor hehehe ")
            
            sensing.registerSensor(SKSensorType.Battery)
            
            if sensing.isSensorRegistered(SKSensorType.Battery) {
                sensing.subscribeToSensor(SKSensorType.Battery, withHandler: { (sensorType, sensorData) in
                    let batteryData = sensorData as! SKBatteryData
                    print("Battery Level: \(batteryData.level)")
                })
                
                sensing.startContinuousSensingWithSensor(SKSensorType.Battery)
            }
            
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
