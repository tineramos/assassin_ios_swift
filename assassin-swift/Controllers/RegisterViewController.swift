//
//  RegisterViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 04/08/2016.
//  Copyright © 2016 Tine Ramos. All rights reserved.
//

import UIKit

class RegisterViewController: FXFormViewController {
    
    var userDictionary = [String : String]()
    
    override func awakeFromNib() {
        formController.form = RegistrationForm()
    }
    
    func register(cell: FXFormFieldCellProtocol) {
        
        // TODO: add registration user API
        // extract details
        print("register button pressed!")
        
        let form = cell.field.form as! RegistrationForm
        
        for key in form.keyFields() {
            
            if let value = form.valueForKey(key) {
                print("key: \(key)      value: \(value)")
            }
            else {
                
            }
            
        }
        
        if form.password == form.repeatPassword {
            print("same password")
        }
        else {
            print("oops. password not match")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
