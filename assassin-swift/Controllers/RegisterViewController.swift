//
//  RegisterViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 04/08/2016.
//  Copyright © 2016 Tine Ramos. All rights reserved.
//

import UIKit

class RegisterViewController: FXFormViewController {
    
    var userDictionary = [String : AnyObject]()
    var errorMessage: String?
    
    override func awakeFromNib() {
        formController.form = RegistrationForm()
    }
    
    func register(cell: FXFormFieldCellProtocol) {
        
        // TODO: add registration user API
        
        let form = cell.field.form as! RegistrationForm
        
        if checkIfValuesAreValid(form) {
            if form.password == form.repeatPassword {
                
                DataManager.sharedManager.signUp(userDictionary, successBlock: { () -> (Void) in
                    self.performSegueWithIdentifier("setMenuSegue", sender: nil)
                    }, failureBlock: { (error: String!) -> (Void) in
                        self.showError(error)
                })
                
            }
            else {
                showError("registration.error.password.notmatch".localized)
            }
        }
        else {
            showError(errorMessage)
        }

    }
    
    func checkIfValuesAreValid(form: RegistrationForm) -> Bool {
        
        var valid: Bool = true
        
        for key in form.keyFields() {
            
            if let value = form.valueForKey(key) {
                
                switch value {
                case is String:
                    valid = stringParameterValidator(value as! String, forKey: key)
                    break
                case is Int:
                    valid = intParameterValidator(value as! Int, forKey: key)
                    break
                case is NSData:
                    // add photo handler
                    break
                default:
                    break
                }
                
            }
            else {
                if key == "registration.details.field.profilePhoto".localized {
                    return valid
                }
                else {
                    errorMessage = "\(key) has null value!!"
                    return !valid
                }
            }
            
        }
        
        return valid
        
    }
    
    func stringParameterValidator(string: String, forKey key: String) -> Bool {
        
        var valid: Bool = true
        
        userDictionary[key] = string
        
        if !string.isEmpty {
            if key == "registration.account.field.email".localized &&
                !Helper.isValidEmail(string) {
                showError("registration.error.invalid.emailformat".localized)
                valid = false
            }
        }
        else {
            showError("FIELD \(key) is EMPTYYYYY!!");
            valid = false
        }
        
        return valid
        
    }
    
    func intParameterValidator(value: Int, forKey key: String) -> Bool {
        
        var valid: Bool = true
        
        if (key == "registration.details.field.age".localized ||
            key == "registration.details.field.height".localized) &&
            value == 0 {
            showError("\(key) can not be zero!!")
            valid = false
        }
        
        return valid
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
    }

}
