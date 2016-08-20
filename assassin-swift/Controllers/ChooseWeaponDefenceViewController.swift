//
//  ChooseWeaponDefenceViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 08/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

class ChooseWeaponDefenceViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    struct CellIdentifier {
        static let playerCellId = "weaponDefenceCellId"
    }
    
    struct Limits {
        static let maxWeapon = 3
        static let maxDefence = 3
    }
    
    var weaponsList: [Weapon] = []
    var defenceList: [Defence] = []
    
    var chosenWeapons: [Int] = []
    var chosenDefences: [Int] = []
    
    var game: Game!
    
    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeaponList()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBarWithBackButtonType(BackButton.Close, andTitle: "")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addTableViewFooter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTableViewFooter() {
        
        let footerView = UIView.init(frame: CGRectMake(0, 0, CGRectGetWidth(tableView!.frame), 60.0))
//        footerView.snp_makeConstraints { (make) in
//            make.width.equalTo(CGRectGetWidth(tableView!.frame))
//            make.height.equalTo(60.0)
//        }
        
        let submitButton = UIButton(type: .Custom)
        submitButton.setTitle("Submit", forState: .Normal)
        submitButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        submitButton.titleLabel?.font = UIFont(name: Constants.fontCourierNewBold, size: 17)
        submitButton.frame = CGRectMake(0, 0, 250, 40)
        submitButton.addTarget(self, action: #selector(joinGame), forControlEvents: .TouchUpInside)
        submitButton.setBorderColor(UIColor.blackColor().CGColor)
        submitButton.center = footerView.center
        
        footerView.addSubview(submitButton)
        
        tableView!.tableFooterView = footerView
    }

    func getWeaponList() {
        DataManager.sharedManager.getWeaponsList({ (array) -> (Void) in
            self.weaponsList = array as! [Weapon]
            self.getDefenceList()
        }) { (errorString) -> (Void) in
            print(errorString)
        }
    }
    
    func getDefenceList() {
        DataManager.sharedManager.getDefencesList({ (array) -> (Void) in
            self.defenceList = array as! [Defence]
            self.tableView?.reloadData()
        }) { (errorString) -> (Void) in
            print(errorString)
        }
    }
    
    func joinGame() {

        if chosenWeapons.count < Limits.maxWeapon && chosenDefences.count < Limits.maxDefence {
            return
        }
        
        DataManager.sharedManager.joinGame(game,
                                           weapons: chosenWeapons,
                                           defences: chosenDefences,
                                           successBlock: { (bool) -> (Void) in
            if bool {
                self.navigationController?.dismissViewControllerAnimated(true, completion: {
                    
                })
                
            }
            
        }) { (errorString) -> (Void) in
            print(errorString)
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
            return "Weapons"
        }
        return "Defences"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.playerCellId, forIndexPath: indexPath)
        
        let row = indexPath.row
        if indexPath.section == 0 {
            let weapon = weaponsList[row]
            cell.textLabel?.text = weapon.weapon_name
            lookUpElement((weapon.weapon_id?.integerValue)!, inArray: chosenWeapons, onCell: cell)
        }
        else {
            let defence = defenceList[row]
            cell.textLabel?.text = defence.defence_name
            lookUpElement((defence.defence_id?.integerValue)!, inArray: chosenDefences, onCell: cell)
        }
        
        return cell
    }
    
    func lookUpElement(row: Int, inArray array: NSArray, onCell cell: UITableViewCell) {
        
        if array.containsObject(row) {
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }
        
    }
    
    // MARK: - TableView Delegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        let section = indexPath.section
        let row = indexPath.row
        
        if cell.accessoryType == .None {
            
            if section == 0 {
                if chosenWeapons.count < Limits.maxWeapon {
                    let weapon = weaponsList[row]
                    cell.accessoryType = .Checkmark
                    chosenWeapons.append((weapon.weapon_id?.integerValue)!) // add 1 to match with defence/weapon_id
                }
            }
            else {
                if chosenDefences.count < Limits.maxDefence {
                    let defence = defenceList[row]
                    cell.accessoryType = .Checkmark
                    chosenDefences.append((defence.defence_id?.integerValue)!)
                }
            }
        }
        else {
            cell.accessoryType = .None
            
            if section == 0 {
                let weapon = weaponsList[row]
                chosenWeapons = chosenWeapons.filter{$0 != (weapon.weapon_id?.integerValue)!}
            }
            else {
                let defence = defenceList[row]
                chosenDefences = chosenDefences.filter{$0 != (defence.defence_id?.integerValue)!}
            }
        }
    }

}
