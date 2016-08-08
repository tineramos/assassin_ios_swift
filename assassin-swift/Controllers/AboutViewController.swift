//
//  AboutViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 06/08/2016.
//  Copyright © 2016 Tine Ramos. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        navigationMode = NavigationBar.Shown
        backButtonType = BackButton.Black
        pageTitle = "page.title.about".localized
        
        super.viewWillAppear(animated)
    }
    
}
