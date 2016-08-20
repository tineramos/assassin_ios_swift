//
//  ChooseWeaponDefenceViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 08/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

class ChooseWeaponDefenceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    struct Constants {
        struct CellIdentifier {
            static let playerCellId = "weaponDefenceCellId"
        }
    }
    
    var weaponsList: [Weapon] = []
    var defenceList: [Defence] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return weaponsList.count
        }
        return defenceList.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Weapon"
        }
        return "Defence"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifier.playerCellId, forIndexPath: indexPath)
        
        // TODO: add configure method in cell using Game core data entity
        let row = indexPath.row
        if indexPath.section == 0 {
            let weapon = weaponsList[row]
            cell.textLabel?.text = weapon.weapon_name
        }
        else {
            let defence = defenceList[row]
            cell.textLabel?.text = defence.defence_name
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        cell.accessoryType = ((cell.accessoryType == .None) ? .Checkmark: .None)
    }

}
