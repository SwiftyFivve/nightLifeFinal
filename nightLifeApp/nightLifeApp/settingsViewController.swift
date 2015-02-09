//
//  settingsViewController.swift
//  nightLifeApp
//
//  Created by Jordan Weaver on 1/14/15.
//  Copyright (c) 2015 Jordan Weaver. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController, UIAlertViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    @IBAction func forgotPassword(sender: AnyObject) {
//        
//        let vc : AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("forgotPasswordViewController");
//        self.showViewController(vc as UIViewController, sender: vc)
//        
//    }
    
    @IBAction func logOutButton(sender: AnyObject) {
        
        /*This will log the user out*/
        
        var alertController = UIAlertController(title: "Log Out",  message: "Are you sure you want to log out?", preferredStyle: .Alert)
        
        
        /*Clear NSUserDefaults in YesAction*/
        
        
        // Create the actions
        var yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            /*This will log the user out*/
            PFUser.logOut()
            var currentUser = PFUser.currentUser() // this will now be nil
            NSLog("Yes Pressed")
            
            //self.dismissViewControllerAnimated(true, completion: nil);
            
            self.performSegueWithIdentifier("unwindToSignIn", sender: nil);
        }
        
        var noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSLog("No Pressed")
        }
        
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
        
        
    }

    @IBAction func unwindSegue(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
   

}
