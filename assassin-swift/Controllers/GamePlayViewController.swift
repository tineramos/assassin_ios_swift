//
//  GamePlayViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 07/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

class GamePlayViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var currentGame: Game!
    
    @IBOutlet weak var gameTitleLabel: UILabel?
    @IBOutlet weak var gameLocationLabel: UILabel?
    @IBOutlet weak var gameStatusLabel: UILabel?
    @IBOutlet weak var playersLabel: UILabel?
    
    @IBOutlet weak var tableViewHeader: UIView?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var joinButton: UIButton?
    @IBOutlet weak var leaveButton: UIButton?
    
    @IBOutlet weak var changeWeaponsButton: UIButton?
    @IBOutlet weak var changeDefencesButton: UIButton?
    
    struct Constants {
        struct CellIdentifier {
            static let playerCellId = "playerCellId"
        }
        
        struct SegueIdentifier {
            static let joinGameSegue = "joinGameSegue"
            static let presentOptionSegue = "presentWeaponDefenceSegue"
            static let presentWeaponOptionSegue = "presentWeaponSegue"
            static let presentDefenceOptionSegue = "presentDefenceSegue"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.tableFooterView = UIView.init()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBarWithBackButtonType(BackButton.Black, andTitle: "")
        getGameDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let navigation = segue.destinationViewController as! UINavigationController
        let chooseWeaponVC = navigation.viewControllers.first as! ChooseWeaponDefenceViewController
        chooseWeaponVC.game = currentGame
        
        if segue.identifier == Constants.SegueIdentifier.presentOptionSegue {
            chooseWeaponVC.displayMode = DisplayMode.WeaponAndDefence
        }
        else if segue.identifier == Constants.SegueIdentifier.presentWeaponOptionSegue {
            chooseWeaponVC.displayMode = DisplayMode.Weapon
        }
        else if segue.identifier == Constants.SegueIdentifier.presentDefenceOptionSegue {
            chooseWeaponVC.displayMode = DisplayMode.Defence
        }
    
    }
    
    func setupViewForStatus() {
        
        let status = GameStatus(rawValue: currentGame.game_status!)!
//        let isStatusOpen = (status == .Open)
        
        switch status {
        case .Open:
            tableView?.hidden = true
            tableViewHeader?.hidden = true
            
            joinButton?.hidden = currentGame.joinedValue()
            joinButton?.setBorderColor(UIColor.blackColor().CGColor)
            
            leaveButton?.hidden = !currentGame.joinedValue()
            leaveButton?.setBorderColor(UIColor.blackColor().CGColor)
            
//            changeWeaponsButton?.hidden = !currentGame.joinedValue
//            changeWeaponsButton?.setBorderColor(UIColor.blackColor().CGColor)
//            
//            changeDefencesButton?.hidden = !currentGame.joinedValue
//            changeDefencesButton?.setBorderColor(UIColor.blackColor().CGColor)
            
            break
        default:
            tableView?.hidden =  false
            tableViewHeader?.hidden = false
            
            joinButton?.hidden = true
            leaveButton?.hidden = true
            
            changeDefencesButton?.hidden = true
            changeWeaponsButton?.hidden = true
            
            tableView?.reloadData()
            break
        }
        
    }
    
    func getGameDetails() {
        
        let gameId = currentGame!.game_id?.integerValue
        
        DataManager.sharedManager.getGameDetailOfId(gameId!, successBlock: { (game) -> (Void) in
            
            self.currentGame = game
            
            self.gameTitleLabel?.text = game?.game_title
            self.gameLocationLabel?.text = game?.game_location
            
            let status = game?.game_status!
            self.gameStatusLabel?.text = status
            self.gameStatusLabel?.textColor = game?.getStatusColor()
            self.playersLabel?.text = game?.getPlayersTitle()
            
            self.setupViewForStatus()
            
        }) { (errorString) -> (Void) in
            print("ERROR: \(errorString)")
        }
        
    }
    
    @IBAction func joinGameButtonPressed() {
        
        if ((currentGame.availableSlotsInt() > 0)) {
            // display weapon and defence options
            performSegueWithIdentifier(Constants.SegueIdentifier.presentOptionSegue, sender: nil)
        }
        else {
            // display alert for max_players reached
        }
        
    }
    
    @IBAction func leaveGameButtonpressed() {
        
    }
    
    // MARK: - TableView DataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentGame.players.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifier.playerCellId, forIndexPath: indexPath) as! PlayersTableViewCell
        let playerList = currentGame?.players.allObjects as! [Player]
        cell.configureCellWithPlayer(playerList[indexPath.row])
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: if game status is open/cancelled, no action
        // TODO: push GameDetail if finished or ongoing
    }

}
