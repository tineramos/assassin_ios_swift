//
//  LoginViewController.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 06/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // Private Constants
    struct Constants {
        struct SegueIdentifier {
            static let pushGameDetailSegue = "showMenuSegue"
        }
    }
    
    @IBOutlet weak var codeNameTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    
    @IBOutlet weak var loginButton: UIButton?
    @IBOutlet weak var signupButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginButton?.setRadius()
        signupButton?.setBorderColor(UIColor.whiteColor().CGColor)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login() {
        
        let codeName = codeNameTextField?.text
        let password = passwordTextField?.text
        
        if codeName?.characters.count > 0 && password?.characters.count > 0 {
            DataManager.sharedManager.loginUser(codeName!, password: password!, successBlock: { (bool) -> (Void) in
                if bool {
                    self.performSegueWithIdentifier(Constants.SegueIdentifier.pushGameDetailSegue, sender: nil)
                } 
            }) { (errorString) -> (Void) in
                print(errorString)
            }
        }
        else {
            let alertController = UIAlertController(title: "", message: "login.error.empty.credentials".localized, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Destructive) { (action) in
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
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
