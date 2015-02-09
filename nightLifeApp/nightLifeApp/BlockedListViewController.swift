//
//  BlockedListViewController.swift
//  nightLifeApp
//
//  Created by Jordan Weaver on 1/26/15.
//  Copyright (c) 2015 Jordan Weaver. All rights reserved.
//

import UIKit

class BlockedListViewController: UIViewController , ABPeoplePickerNavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func showPeoplePicker(sender: AnyObject) {
        
        var peoplePicker: ABPeoplePickerNavigationController = ABPeoplePickerNavigationController()
        
        peoplePicker.peoplePickerDelegate = self
        
        self.presentViewController(peoplePicker, animated: true, completion: nil)
    }
    
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, shouldContinueAfterSelectingPerson person: ABRecord!) -> Bool {
        return true;
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, shouldContinueAfterSelectingPerson person: ABRecord!, property: ABPropertyID, identifier: ABMultiValueIdentifier) -> Bool {
        
        if property == kABPersonPhoneProperty
        {
            //ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty)
            
        }
        
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*This unwinds segue*/
    @IBAction func unwindBlockedSegue(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }

}
