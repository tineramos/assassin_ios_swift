//
//  BaseViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 08/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showNavigationBarWithBackButtonType(backButtonType: BackButton!, andTitle title: String!) {
        self.navigationController?.navigationBarHidden = false
        
        self.navigationItem.hidesBackButton = true
        var backImage = UIImage(named: "back-icon-black")
        var titleColor = UIColor.blackColor()
        
        if backButtonType == .White {
            backImage = UIImage(named: "back-icon-white")
            titleColor = UIColor.whiteColor()
        }
        
        let backButton = UIButton(frame: CGRectMake(0, 0, 50, 50))
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
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 200, 40))
        titleLabel.font = UIFont(name: Constants.fontCourierNewBold, size: 40.0)
        titleLabel.textColor = titleColor
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = title.uppercaseString
        navigationItem.titleView = titleLabel
    }
    
    func hideNavigationBar() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBarHidden = true
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
