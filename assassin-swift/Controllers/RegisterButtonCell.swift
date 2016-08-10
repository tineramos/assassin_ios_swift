//
//  RegisterButtonCell.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 05/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

class RegisterButtonCell: FXFormBaseCell {
    
    @IBAction func registerButtonAction(sender: UIButton) {
        if let action = field.action {
            action(self)
        }
    }

}
