//
//  GameViewController.swift
//  assassin-swift
//
//  Created by Tine Ramos on 04/08/2016.
//  Copyright (c) 2016 Tine Ramos. All rights reserved.
//

import UIKit

class GameViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    // Private Constants
    struct Constants {
        struct CellIdentifier {
            static let gamesCellId = "gamesCellId"
        }
        
        struct SegueIdentifier {
            static let pushGameDetailSegue = "pushGameDetailSegue"
        }
    }
    
    @IBOutlet weak var tableView: UITableView?
    
    var gamesList: [Game] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    
        DataManager.sharedManager.getGamesList({ (array: NSArray!) -> (Void) in
            
            self.gamesList = array as! [Game]
            self.tableView?.reloadData()
            
            }) { (error) -> (Void) in
                print(error)
                // show error
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBarWithBackButtonType(BackButton.White, andTitle: "page.title.games".localized)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == Constants.SegueIdentifier.pushGameDetailSegue {
            
            let selectedGame = sender as! Game
            let gameDetailVC = segue.destinationViewController as! GamePlayViewController
            gameDetailVC.gameId = (selectedGame.game_id?.integerValue)!
            
        }
        
     }

    
    // MARK: - TableView DataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: change numbers
        return gamesList.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // TODO: change depend on the game status
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifier.gamesCellId, forIndexPath: indexPath) as! GamesTableViewCell
        
        // TODO: add configure method in cell using Game core data entity
        cell.configureCell(gamesList[indexPath.row])
        return cell
    }

    // MARK: - TableView Delegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let game = gamesList[indexPath.row]
        performSegueWithIdentifier(Constants.SegueIdentifier.pushGameDetailSegue, sender: game)
    }
    
}
