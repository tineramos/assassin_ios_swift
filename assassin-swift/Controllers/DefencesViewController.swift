//
//  DefencesViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 09/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

enum DefenceType: Int {
    case Armour     = 201
    case GasMask    = 202
    case Shield     = 203
    case HPPotion   = 204
    case Detector   = 205   //pARk
}

class DefencesViewController: UIViewController {

    var defencesList: [Defence] = []
    var currentDefence: DefenceType?
    
    lazy var sensingKit = SensingKitLib.sharedSensingKitLib()
    
    @IBOutlet weak var defenceView: UIView?
    @IBOutlet weak var sceneView: SCNView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerSensors()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerSensors() {
        
        if sensingKit.isSensorAvailable(.DeviceMotion) {
            sensingKit.registerSensor(.DeviceMotion)
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
    
    @IBAction func activateProximityDetector() {
        
    }
    
}
