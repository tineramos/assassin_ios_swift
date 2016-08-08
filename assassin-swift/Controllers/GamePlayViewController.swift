//
//  GamePlayViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 07/08/2016.
//  Copyright © 2016 Tine Ramos. All rights reserved.
//

import UIKit

class GamePlayViewController: BaseViewController, UITableViewDataSource {

    var gameId: Int = 0
    
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

        // Do any additional setup after loading the view.
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBarWithBackButtonType(BackButton.Black, andTitle: "Title")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - TableView DataSource Methods
    
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
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "The section"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifier.playerCellId, forIndexPath: indexPath) as! GamesTableViewCell
        
        // TODO: add configure method in cell using Game core data entity
        
        return cell
    }

}
