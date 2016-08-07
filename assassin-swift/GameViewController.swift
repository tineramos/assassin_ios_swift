//
//  GameViewController.swift
//  assassin-swift
//
//  Created by Tine Ramos on 04/08/2016.
//  Copyright (c) 2016 Tine Ramos. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView?
    
    let gamesCellId = "gamesCellId"
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(gamesCellId, forIndexPath: indexPath) as! GamesTableViewCell
        
        // TODO: add configure method in cell using Game core data entity
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
