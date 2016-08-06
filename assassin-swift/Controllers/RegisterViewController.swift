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
        
//        let form = cell.field.form as! RegistrationForm
//        checkIfValuesAreValid(form)
        self.performSegueWithIdentifier("setMenuSegue", sender: nil)
        
    }
    
    func checkIfValuesAreValid(form: RegistrationForm) {
        
        for key in form.keyFields() {
            
            if let value = form.valueForKey(key) {
                
                if value is String {
                    stringParameterValidator(value as! String, forKey: key)
                }
                else if value is Int {
                    intParameterValidator(value as! Int, forKey: key)
                }
                else {
                    // photo?
                    print("photo may be??")
                }
            }
            else {
                showError("\(key) has null value!!")
                break
            }
            
        }
        
        if form.password == form.repeatPassword {
            print("same password")
        }
        else {
            print("oops. password not match")
        }
        
    }
    
    func stringParameterValidator(string: String, forKey key: String) {
        
        if !string.isEmpty {
            if key == "registration.account.field.email".localized &&
                !Helper.isValidEmail(string) {
                showError("EMAIL: INVALID FORMAT!!")
            }
        }
        else {
            showError("FIELD \(key) is EMPTYYYYY!!");
        }
        
    }
    
    func intParameterValidator(value: Int, forKey key: String) {
        if (key == "registration.details.field.age".localized ||
            key == "registration.details.field.height".localized) &&
            value == 0 {
            showError("\(key) can not be zero!!")
        }
        else {
            showError("nice! \(key) has value \(value)")
        }
    }
    
    func showError(message: String!) {
        let alertController = UIAlertController.init(title:"", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
