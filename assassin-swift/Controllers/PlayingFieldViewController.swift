//
//  PlayingFieldViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 07/08/2016.
//  Copyright © 2016 Tine Ramos. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class PlayingFieldViewController: UIViewController {
    
    lazy var sensingKit = SensingKitLib.sharedSensingKitLib()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openSensingKit() {
        
        if sensingKit.isSensorAvailable(SKSensorType.Battery) {
            
            print("i has battery sensor hehehe ")
            
            sensingKit.registerSensor(SKSensorType.Battery)
            
            if sensingKit.isSensorRegistered(SKSensorType.Battery) {
                sensingKit.subscribeToSensor(SKSensorType.Battery, withHandler: { (sensorType, sensorData) in
                    let batteryData = sensorData as! SKBatteryData
                    print("Battery Level: \(batteryData.level)")
                })
                
                sensingKit.startContinuousSensingWithSensor(SKSensorType.Battery)
            }
            
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
