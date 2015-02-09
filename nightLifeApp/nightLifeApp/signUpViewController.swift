//
//  signUpViewController.swift
//  nightLifeApp
//
//  Created by Jordan Weaver on 1/13/15.
//  Copyright (c) 2015 Jordan Weaver. All rights reserved.
//

import UIKit

class signUpViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {

    /*This handles all SignUp view events*/
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var birthdayField: UITextField!
  
    @IBOutlet weak var datePicker: UIDatePicker!

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    @IBAction func dateAction(sender: UITextField) {
        datePicker.hidden = false;
        datePicker.datePickerMode = UIDatePickerMode.Date;
        sender.inputView = datePicker
        datePicker.addTarget(self, action: Selector("handleDatePicker"), forControlEvents: UIControlEvents.ValueChanged);
        
    }
    
    
    func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy";
        birthdayField.text = dateFormatter.stringFromDate(sender.date);
    }
    
    

    
    
    
    
    
    
    @IBAction func agreeSignUpButton(sender: AnyObject) {
        
        var alertController = UIAlertController(title: "Successful", message: "Login to get started", preferredStyle: .Alert)
        
        // Create the actions
        var okAction = UIAlertAction(title: "Hell Yeah!", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            NSLog("OK Pressed")
            self.performSegueWithIdentifier("pleaseWorkSegue", sender: nil);
        }
        
        alertController.addAction(okAction)

        var user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        user.email = emailField.text

        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
                self.presentViewController(alertController, animated: true, completion:nil)
                
            } else {
                //let errorString = userInfo["error"] as NSString
                // Show the errorString somewhere and let the user try again.
            }
        }
        
        println("\(emailField.text)")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        
        datePicker.addTarget(self, action: Selector("dataPickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    func datePickerChanged(datePicker:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        birthdayField.text = strDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Unwind segue from signUp page
    @IBAction func unwindSegue(sender: UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func unwindSignUpSegue(sender: UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
}
