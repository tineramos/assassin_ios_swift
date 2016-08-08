//
//  BaseViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 08/08/2016.
//  Copyright © 2016 Tine Ramos. All rights reserved.
//

import UIKit

enum NavigationBar {
    case Hidden
    case Shown
}

enum BackButton {
    case Black
    case White
}

class BaseViewController: UIViewController {

    // default value
    var navigationMode = NavigationBar.Shown
    var backButtonType = BackButton.Black
    var pageTitle: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        switch navigationMode {
        case .Hidden:
            self.navigationController?.navigationBarHidden = true
            break
        case .Shown:
            self.navigationController?.navigationBarHidden = false
            createCustomNavigationBarWithTitle(pageTitle);
            break
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createCustomNavigationBarWithTitle(title: String) {
        
        self.navigationItem.hidesBackButton = true
        var backImage = UIImage(named: "back-icon-black")
        
        if backButtonType == .White {
            backImage = UIImage(named: "back-icon-white")
        }
        
        let backButton = UIButton(frame: CGRectMake(0, 0, 58, 58))
        backButton.setImage(backImage, forState: UIControlState.Normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        // make a clear background navigation bar
        let navBar = self.navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar?.shadowImage = UIImage()
        navBar?.translucent = true
        
        // create and customise the title view of the page
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
        titleLabel.font = UIFont(name: Constants().font, size: 50.0)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = title.uppercaseString
        navigationItem.titleView = titleLabel
    }
    
    func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
