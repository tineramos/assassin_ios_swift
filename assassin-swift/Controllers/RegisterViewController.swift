//
//  RegisterViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 04/08/2016.
//  Copyright © 2016 Tine Ramos. All rights reserved.
//

import UIKit

class RegisterViewController: FXFormViewController {
    
    override func awakeFromNib() {
        formController.form = RegistrationForm()
    }
    
    func register(cell: FXFormFieldCellProtocol) {
        
        // TODO: add registration user API
        // extract details
        print("register button pressed!")
        
        let form = cell.field.form as! RegistrationForm
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
