//
//  safeDriversViewController.swift
//  nightLifeApp
//
//  Created by Jordan Weaver on 1/26/15.
//  Copyright (c) 2015 Jordan Weaver. All rights reserved.
//

import UIKit

class safeDriversViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate, UITableViewDelegate {

    @IBOutlet weak var safeDriversTableView: UITableView!
    
    var contacts: [String] = [];
    
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
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        if property == kABPersonPhoneProperty {
            
            
            let phones : ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue();
            //let names: ABMultiValueRef = ABRecordCopyValue(person, kABPersonFirstNameProperty).takeRetainedValue();
            
            //let nameIndex = ABMultiValueGetIndexForIdentifier(names, identifier);
           // let selectedName = ABMultiValueCopyValueAtIndex(names, nameIndex).takeRetainedValue()
            
            if ABMultiValueGetCount(phones) > 0 {
                let index = ABMultiValueGetIndexForIdentifier(phones, identifier);
                
                let selectedPhone = ABMultiValueCopyValueAtIndex(phones, index).takeRetainedValue() as String
                
                println("Selected Phone: \(selectedPhone)")
                //println("Selected Name: \(selectedName)")
                
                
            }
            
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.safeDriversTableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        
        return cell
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*This unwinds segue*/
    @IBAction func unwindSafeSegue(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }

}
