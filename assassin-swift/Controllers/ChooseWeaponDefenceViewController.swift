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
    
    var weaponsList: [Weapon] = []
    var defenceList: [Defence] = []
    
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
        print("hello join game please!")
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
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.playerCellId, forIndexPath: indexPath)
        
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
