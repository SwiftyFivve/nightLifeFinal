//
//  forgotPasswordViewController.swift
//  nightLifeApp
//
//  Created by Jordan Weaver on 1/14/15.
//  Copyright (c) 2015 Jordan Weaver. All rights reserved.
//

import UIKit

class forgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetPasswordButton(sender: AnyObject) {
        
        /*This will reset the password*/
        PFUser.requestPasswordResetForEmail(emailField.text);
        
        
        var alertController = UIAlertController(title: "Reset Password", message: "An Email was sent to you to reset your password.", preferredStyle: .Alert)
        
        // Create the actions
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
        
        
    }


    @IBAction func unwindPasswordSegue(sender: UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }

}
