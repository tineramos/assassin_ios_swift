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
    
    func fields() -> [AnyObject]! {
        
        return [
        
            /**
             *  Account section 
             **/
            
            [FXFormFieldKey: "registration.account.field.email",
                FXFormFieldHeader: "registration.header.account".localized],
            
            "registration.account.field.password".localized,
            "registration.account.field.repeatPassword".localized,
            
            /**
             *  Details section 
             **/
            
            [FXFormFieldKey: "registration.details.field.name",
                FXFormFieldHeader: "registration.header.details".localized,
                "textField.autocapitalizationType": UITextAutocapitalizationType.Words.rawValue],
            
            "registration.details.field.codeName".localized,
            
            [FXFormFieldKey: "registration.details.field.gender",
                FXFormFieldOptions: ["registration.gender.options.male".localized, "registration.gender.options.male".localized]],
            
            "registration.details.field.age".localized,
            "registration.details.field.height".localized,
            "registration.details.field.profilePhoto".localized,
        
        ]
        
    }
    
    func extraFields() -> [AnyObject]! {
        return [
            [FXFormFieldCell: RegisterButtonCell.self, FXFormFieldHeader: "", FXFormFieldAction: ""],
        ]
    }

}
