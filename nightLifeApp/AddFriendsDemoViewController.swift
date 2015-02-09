//
//  AddFriendsDemoViewController.swift
//  nightLifeApp
//
//  Created by Jordan Weaver on 1/29/15.
//  Copyright (c) 2015 Jordan Weaver. All rights reserved.
//

import UIKit

class AddFriendsDemoViewController: UIViewController {
    
    @IBOutlet weak var userSearchBar: UITextField!
    
    
    @IBOutlet weak var foundUser: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    var userSet:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    @IBAction func searchButton(sender: AnyObject) {
        
        var userName:String = userSearchBar.text;
        
        /*Check if text field is filled. */
        if userSearchBar.text != "" {
            /*Searches for user in data base*/
            var query = PFUser.query()
            query.whereKey("username", equalTo: userName)
            query.findObjectsInBackgroundWithBlock {(objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    println(objects)
                    
                    if objects == nil{
                        /*This function runs if that user doesn't exist in the data base*/
                        self.friendNotFound()
                        
                    } else {
                        
                        /*If the user is found it pulls it as an AnyObject*/
                        var foundUsername: AnyObject = objects[0]
                        /*Sets the username to a String */
                        self.userSet = foundUsername["username"] as? String
                        
                        
                        
                        
                        /*ALERT TO TELL USER FRIEND WAS FOUND*/
                        var alertController = UIAlertController(title: "Friend Found!",  message: "Would you like to add \(self.userSet) as a friend?", preferredStyle: .Alert)
                        
                        
                        // Create the actions
                        var yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
                            UIAlertAction in
                            
                            NSLog("Yes Pressed")
                            
                            
                            
                            /*ADDS FRIENDS TO USERS PARSE DATA IN ARRAY FORM*/
                            var usersQuery = PFUser.currentUser()
                            var usersFriends = usersQuery["friends"] as [String]
                            
                                    //This bool is to use to determine if the searched user is already friended
                                     var newUser:Bool?
                            //Was erroring if the users friends array in parse was empty
                                    if usersFriends.count == 0 {
                                        
                                        //This saves the searched friend to the empty parse friends array
                                        var user = PFUser.currentUser()
                                        user.setObject([self.userSet], forKey: "friends")
                                        user.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError!) -> Void in
                                            println("success")
                                            
                                        });
                                        
                                    } else {
                                    
                                       
                                        /*CHECKS IF USER ALREADY HAS THAT FRIEND*/
                                        for index in usersFriends {
                                            //This sets the Bool that makes sure user does not already have that friend
                                            if index == self.userSet{
                                                newUser = false
                                            } else {
                                                newUser = true
                                            }
                                            
                                            // If the user does not have this friend this code runs
                                        if newUser == true {
                                            //appends the new friend to the old friend array
                                            usersFriends.append(self.userSet)
                                        //This function prompts an alert view that just said it finished adding
                                            self.finishedAdding(newUser!);
                                            
                                            //This block saves the new array to parse
                                            var user = PFUser.currentUser()
                                            user.setObject(usersFriends, forKey: "friends")
                                            user.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError!) -> Void in
                                                println("success")
                                                
                                                
                                            });
                                        
                                        } else {
                                            
                                            //This function prompts an alert that the user already has this friend. Two alerts are held in this function. It is determined by the Bool which one runs
                                            self.finishedAdding(newUser!)
                                            
                                            /*POPUP you already have the friend */
                                            
                                            //This ReSaves the users friends array. Not sure if this is needed. Staying for now. REFACTOR!
                                            var user = PFUser.currentUser()
                                            user.setObject(usersFriends, forKey: "friends")
                                            user.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError!) -> Void in
                                                println("success")
                                            });
                                        }
                                        
                                    }
                                    
                                    }
                                    
                                }
                        
                    
                    
                    var noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                        NSLog("No Pressed")
                    }
                    
                    
                    alertController.addAction(yesAction)
                    alertController.addAction(noAction)
                    
                    self.presentViewController(alertController, animated: true, completion:nil)
                    
                    }
                
                } else {
                    
                    NSLog("Error: %@ %@", error, error.userInfo!)
                    
                    
                    /*ALERT TO TELL USER FRIEND WAS NOT FOUND*/
                    
                    var NotFoundalertController = UIAlertController(title: "Not Found",  message: "The user you were searching for was not found. Please try again.", preferredStyle: .Alert)
                    
                    
                    /*Clear NSUserDefaults in YesAction*/
                    
                    
                    // Create the actions
                    var OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                        
                        NSLog("OK Pressed")
                        
                        //self.dismissViewControllerAnimated(true, completion: nil);
                    }
                    
                    NotFoundalertController.addAction(OKAction)
                    
                    self.presentViewController(NotFoundalertController, animated: true, completion:nil)
                    
                }
                
            }
            
        }
        
    }
    
    
    //This function is explained in the Search Button IBAction. Only contains alert views and dismiss view controllers
    func finishedAdding(sender: Bool) {
        if sender == true {
            
            var alertController = UIAlertController(title: "Friend was Added",  message: "You may now view your friends location when they are out.", preferredStyle: .Alert)
            
            
            
            // Create the actions
            var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
                NSLog("OK Pressed")
                
                self.dismissViewControllerAnimated(true, completion: nil);
            }
            
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion:nil)
            
            
            
        } else {
            var alertController = UIAlertController(title: "Already Added",  message: "You already have that user as a friend.", preferredStyle: .Alert)
            
            
            
            // Create the actions
            var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
                NSLog("OK Pressed")
                
                self.dismissViewControllerAnimated(true, completion: nil);
            }
            
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion:nil)
            
        }
        
        
        
        
    }
    
    //This function contains an alert view that tells users they already have that friend.
    func friendNotFound() {
        var alertNotFoundController = UIAlertController(title: "Not Found",  message: "The user you were searching for was not found. Please try again.", preferredStyle: .Alert)
        
        
        /*Clear NSUserDefaults in YesAction*/
        
        
        // Create the actions
        var okNotFound = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            NSLog("OK Pressed")
            
            self.dismissViewControllerAnimated(true, completion: nil);
        }
        
        alertNotFoundController.addAction(okNotFound)
        
        self.presentViewController(alertNotFoundController, animated: true, completion:nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Not sure if this is working yet. Computer was crashing, but is better now. May be able to hook it up
    @IBAction func unwindAddFriendsSegue(sender: UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
}
