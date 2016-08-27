//
//  PlayingFieldViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 07/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

import SnapKit

enum PlayMode {
    case Attack
    case Defend
}

class PlayingFieldViewController: BaseViewController {
    
    lazy var sensingKit = SensingKitLib.sharedSensingKitLib()
    
    var playerId: Int = 0
    var gameId: Int = 0
    
    var assassin: Assassin!
    var target: Target!
    
    var playMode: PlayMode = .Attack
    var weaponsList: [PlayerWeapons] = []
    var defenceList: [PlayerDefences] = []
    
    @IBOutlet weak var playingView: UIView?
    @IBOutlet weak var sceneView: SCNView?
    @IBOutlet var buttonArray: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.registerSensors()
//        registerSensorsForDetectingPlayMode()
        
        getAssassinObject()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBarWithBackButtonType(BackButton.Black, andTitle: "")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        Helper.stopSensors()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var targetView: TargetDetailsView = {
        let target = TargetDetailsView.instanceFromNib()
        target.setBorderColor(UIColor.blackColor().CGColor)
        return target as! TargetDetailsView
    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Data methods
    
    func getAssassinObject() {
        CoreDataManager.sharedManager.getAssassinObject(gameId, playerId: playerId, successBlock: { (assassin) -> (Void) in
            
            if (assassin != nil) {
                self.assassin = assassin
                self.getTargetDetails()
            }
            else {
                self.showAlertErrorWithMessage("Assassin not found.")
            }
            
        }) { (errorString) -> (Void) in
            self.showAlertErrorWithMessage("GET ASSASSIN \(errorString)")
        }
    }
    
    func getTargetDetails() {
        
        DataManager.sharedManager.getTargetDetails(playerId, ofAssassin: self.assassin, successBlock: { (target) -> (Void) in
            
            if target != nil {
                self.target = target!
                self.getWeaponList()
            }
            else {
                self.showAlertErrorWithMessage("Target not found.")
            }
            
        }) { (errorString) -> (Void) in
            self.showAlertErrorWithMessage("TARGET DETAILS \(errorString)")
        }
    }
    
    func getWeaponList() {
        DataManager.sharedManager.getWeaponsList({ (array) -> (Void) in
            self.getDefenceList()
        }) { (errorString) -> (Void) in
            print(errorString)
            self.showAlertErrorWithMessage("WEAPONLIST: \(errorString)")
        }
    }
    
    func getDefenceList() {
        DataManager.sharedManager.getDefencesList({ (array) -> (Void) in
            self.getAmmoList()
        }) { (errorString) -> (Void) in
            print(errorString)
            self.showAlertErrorWithMessage("DEFENCELIST: \(errorString)")
        }
    }
    
    func getAmmoList() {
        
        DataManager.sharedManager.getAmmoForGameOfPlayer(playerId, successBlock: { (Void) -> (Void) in
            
            self.showAlertToShowTargetDetails()
            self.showWeaponsAndDefencesView()
            
            }) { (errorString) -> (Void) in
                self.showAlertErrorWithMessage("AMMO LIST \(errorString)")
        }
        
    }
    
    // MARK: - Alert methods
    
    func showAlertToShowTargetDetails() {
        let alertController = UIAlertController(title: "Target downloaded!", message: "", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Show", style: .Default) { (action) in
            self.showTargetDetails()
            })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Destructive) { (action) in })
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showAlertErrorWithMessage(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in })
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - View setup
    
    @IBAction func showTargetDetails() {
        view.addSubview(targetView)
        targetView.showTargetView(target)
        
        targetView.snp_makeConstraints { (make) in
            make.width.equalTo(280.0)
            make.height.equalTo(210.0)
            make.center.equalTo(playingView!.snp_center)
        }
    }
    
    func showWeaponsAndDefencesView() {
        
        print("PLAYER DEFENCE")
        
        weaponsList = self.assassin.weapons.allObjects as! [PlayerWeapons]
        defenceList = self.assassin.defences.allObjects as! [PlayerDefences]
        
        setPlayMode(.Attack)
    }
    
    func setPlayMode(mode: PlayMode) {
        
        if playMode == mode {
            return
        }
        
        playMode = mode
        
        switch mode {
        case .Attack:
            
            break
        case .Defend:
            
            break
        }
        
    }
    
    // MARK: - Sensors
    
    func registerSensorsForDetectingPlayMode() {
        
        if sensingKit.isSensorRegistered(.DeviceMotion) {
            
            sensingKit.subscribeToSensor(.DeviceMotion, withHandler: { (sensorType, sensorData) in
                
//                let data = sensorData as! SKDeviceMotionData
                
//                let accelerationX = data.userAcceleration.x
//                let accelerationY = data.userAcceleration.y
//                let accelerationZ = data.userAcceleration.z
//                
//                let attitude = data.attitude.roll
//                let attitude = data.attitude.pitch
//                let attitude = data.attitude.yaw
                
                
                
            })
            
        }
        
    }

}
