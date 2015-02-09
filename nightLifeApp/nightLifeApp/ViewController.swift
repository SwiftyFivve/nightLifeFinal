//
//  ViewController.swift
//  nightLifeApp
//
//  Created by Jordan Weaver on 1/10/15.
//  Copyright (c) 2015 Jordan Weaver. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    

    @IBOutlet weak var usernameField: UITextField!
   
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var forgotPassword: UIButton!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        /*Check NSUserDefaults on load*/
        
    }
    
    
    @IBAction func loginButton(sender: AnyObject) {
        
        
        /*Add NSUserDefaults to Successful login*/
        
        
        PFUser.logInWithUsernameInBackground(usernameField.text, password:passwordField.text) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                // Do stuff after successful login.
                self.performSegueWithIdentifier("mainViewSegue", sender: nil);
                self.passwordField.text = ""
                
                
                println("Login Successful!");
            } else {
                // The login failed. Check error to see why.
                
                var alertController = UIAlertController(title: "Failure Logging In", message: "Make sure you entered the correct credentials.", preferredStyle: .Alert)
                
                // Create the actions
                var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                
                alertController.addAction(okAction)
                
                self.presentViewController(alertController, animated: true, completion: {
                    self.forgotPassword.hidden = false;
                })
                
                
                println("Login failed");
            }
            
        }
    }
    

    @IBAction func forgotPasswordClick(sender: AnyObject) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

