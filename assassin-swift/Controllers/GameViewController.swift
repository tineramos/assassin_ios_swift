//
//  GameViewController.swift
//  assassin-swift
//
//  Created by Tine Ramos on 04/08/2016.
//  Copyright (c) 2016 Tine Ramos. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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

    override func viewDidLoad() {
        super.viewDidLoad()
    
        DataManager.sharedManager.getGamesList({ (gamesList: NSArray!) -> (Void) in
            // add methods!
            self.tableView?.reloadData()
            
            print("games: \n \(gamesList)")
            
            }) { (error) -> (Void) in
                print(error)
                // show error
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifier.gamesCellId, forIndexPath: indexPath) as! GamesTableViewCell
        
        // TODO: add configure method in cell using Game core data entity
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: if game status is open/cancelled, no action
        // TODO: push GameDetail if finished or ongoing
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: change numbers
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // TODO: change depend on the game status
        return 3
    }

}
