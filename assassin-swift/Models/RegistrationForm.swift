//
//  RegistrationForm.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 05/08/2016.
//  Copyright © 2016 Tine Ramos. All rights reserved.
//

import UIKit

class RegistrationForm: NSObject, FXForm {

    var email:String?
    var password : String?
    var repeatPassword: String?
    
    var name: String?
    var codeName: String?
    var course: String?
    var gender = 0
    var age: UInt = 0
    var height: UInt = 0

    var profilePhoto: UIImage?
    
    func keyFields() -> [String]! {
        
        var keys = [String]()
        
        for object in fields() {
            keys.append(object[FXFormFieldKey] as! String)
        }
        
        return keys
        
    }
    
    func fields() -> [AnyObject]! {
        
        return [
        
            /**
             *  Account section 
             **/
            
            [FXFormFieldKey: "registration.account.field.email".localized,
                FXFormFieldHeader: "registration.header.account".localized],
            
            [FXFormFieldKey: "registration.account.field.password".localized],
            [FXFormFieldKey: "registration.account.field.repeatPassword".localized],
            
            /**
             *  Details section 
             **/
            
            [FXFormFieldKey: "registration.details.field.name".localized,
                FXFormFieldHeader: "registration.header.details".localized,
                "textField.autocapitalizationType": UITextAutocapitalizationType.Words.rawValue,
                "textField.autocorrectionType": UITextAutocorrectionType.No.rawValue,
                "textField.spellCheckingType": UITextSpellCheckingType.No.rawValue],
            
            [FXFormFieldKey: "registration.details.field.codeName".localized,
                "textField.autocapitalizationType": UITextAutocapitalizationType.None.rawValue,
                "textField.autocorrectionType": UITextAutocorrectionType.No.rawValue,
                "textField.spellCheckingType": UITextSpellCheckingType.No.rawValue],
            
            [FXFormFieldKey: "registration.details.field.gender".localized,
                FXFormFieldOptions: ["registration.gender.options.male".localized,
                    "registration.gender.options.female".localized]],
            
            [FXFormFieldKey: "registration.details.field.age".localized],
            [FXFormFieldKey: "registration.details.field.height".localized],
            [FXFormFieldKey: "registration.details.field.profilePhoto".localized],
        
        ]
        
    }
    
    func extraFields() -> [AnyObject]! {
        return [
            [FXFormFieldCell: RegisterButtonCell.self, FXFormFieldHeader: "", FXFormFieldAction: "register:"],
        ]
    }

}
