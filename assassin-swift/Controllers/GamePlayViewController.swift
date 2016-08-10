//
//  GamePlayViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 07/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

class GamePlayViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var gameId: Int = 0
    var playerList: [Player] = []
    
    @IBOutlet weak var gameTitleLabel: UILabel?
    @IBOutlet weak var gameLocationLabel: UILabel?
    @IBOutlet weak var gameStatusLabel: UILabel?
    @IBOutlet weak var playersLabel: UILabel?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var joinButton: UIButton?
    
    struct Constants {
        
        struct CellIdentifier {
            static let playerCellId = "playerCellId"
        }
        
        struct SegueIdentifier {
            static let joinGameSegue = "joinGameSegue"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinButton?.setBorderColor(UIColor.blackColor().CGColor)

        // Do any additional setup after loading the view.
        getGameDetails()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBarWithBackButtonType(BackButton.Black, andTitle: "Details")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getGameDetails() {
        
        DataManager.sharedManager.getGameDetailOfId(gameId, successBlock: { (game) -> (Void) in
            
            self.gameTitleLabel?.text = game?.game_title
            self.gameLocationLabel?.text = game?.game_location
            
            let status = game?.game_status!.capitalizedString
            self.gameStatusLabel?.text = status
            self.gameStatusLabel?.textColor = game?.getStatusColor()
            self.playersLabel?.text = game?.getPlayersTitle()
            
            if status == GameStatus.Open.rawValue {
                // show join button
                self.joinButton?.hidden = false
                self.tableView?.hidden = true
            }
            else {
                self.tableView?.reloadData()
            }
            
        }) { (errorString) -> (Void) in
            print("ERROR: \(errorString)")
        }
        
    }
    
    @IBAction func joinGameButtonPressed() {
        
        
        
    }
    
    // MARK: - TableView DataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifier.playerCellId, forIndexPath: indexPath) as! PlayersTableViewCell
        cell.configureCellWithPlayer(playerList[indexPath.row])
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: if game status is open/cancelled, no action
        // TODO: push GameDetail if finished or ongoing
    }

}
