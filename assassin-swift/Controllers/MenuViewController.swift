//
//  MenuViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 06/08/2016.
//  Copyright © 2016 Tine Ramos. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {
    
    @IBOutlet weak var playButton: UIButton?
    @IBOutlet weak var profileButton: UIButton?
    @IBOutlet weak var aboutButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playButton?.setBorderColor(UIColor.whiteColor().CGColor)
        profileButton?.setBorderColor(UIColor.whiteColor().CGColor)
        aboutButton?.setBorderColor(UIColor.whiteColor().CGColor)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//    }

}
