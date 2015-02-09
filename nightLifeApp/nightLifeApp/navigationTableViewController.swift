//
//  navigationTableViewController.swift
//  nightLifeApp
//
//  Created by Jordan Weaver on 1/17/15.
//  Copyright (c) 2015 Jordan Weaver. All rights reserved.
//

import UIKit

protocol navTableViewDelegate{
    func navControleDidSelectRow(indexPath: NSIndexPath)
    
}

class navigationTableViewController: UITableViewController {
    
    
    var delegate:navTableViewDelegate?
    var tableData:Array<String> = []


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tableData.count
    }
    
    


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? UITableViewCell

        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.lightTextColor()
            
            let selectedView:UIView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height));
            selectedView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
            
            
            cell!.selectedBackgroundView = selectedView
        }

        cell!.textLabel?.text = tableData[indexPath.row]
        
        // Configure the cell...

        return cell!
    }


    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.navControleDidSelectRow(indexPath);
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
