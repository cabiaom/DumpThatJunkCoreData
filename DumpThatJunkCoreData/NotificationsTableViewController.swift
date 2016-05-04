//
//  NotificationsTableViewController.swift
//  DumpThatJunkCoreData
//
//  Created by Mark CABIAO on 5/1/16.
//  Copyright © 2016 Mark CABIAO. All rights reserved.
//

import UIKit
import CoreData

class NotificationsTableViewController: UITableViewController {
    
    var  notifications = UIApplication.sharedApplication().scheduledLocalNotifications

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.init(colorLiteralRed: 0.937, green: 0.584, blue: 0.616, alpha: 1)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        title = "Future Notifications"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifications!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest(entityName: "BoxUnit")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let row = indexPath.row
        let fireDate = (notifications![row].fireDate)!
        let dateString = NSDateFormatter.localizedStringFromDate(fireDate, dateStyle: .ShortStyle, timeStyle: .LongStyle)
        cell.textLabel?.text = "Notification at " + dateString
        cell.backgroundColor = UIColor.clearColor()
        
        let keyUserInfo = notifications![row].userInfo as![String:NSNumber]
        let key = keyUserInfo["w00t"]! as NSNumber
        
        //print ("using key: \(key)")
        
        let predicate = NSPredicate(format: "%K == %@", "unitID", key)
        fetchRequest.predicate = predicate
        
        do
        {
            let fetchResult = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            for theResult in fetchResult!{
                let name = theResult.valueForKey("name") as? String
                print("Box found: \(name)")
            
                let loc = theResult.valueForKey("location") as? Location
                let locName = loc?.name
                
                //let location = (box?.location)! as Location
                //let locationName = location.name
                
                //print("\(boxName)")
                cell.detailTextLabel?.numberOfLines = 0
                cell.detailTextLabel?.text = " LOCATION:  "+locName! + ",  BOX: " + name!
             
            }
 
        }
        catch
        {
            print("Some error in fetching queries.")
        }
 

        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            print("Delete closure called")
            let row = indexPath.row
            if  let notification = self.notifications?[row]{
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                self.notifications = UIApplication.sharedApplication().scheduledLocalNotifications
                tableView.reloadData()
            }
        }
        /*
        let editClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            print("Edit closure called")
            //self.showEditNameAlert(atIndex: indexPath.row)
        }
        
         let pictureClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
         print("Picture closure called")
         }
         */
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: deleteClosure)
        //let editAction = UITableViewRowAction(style: .Normal, title: "Edit", handler: editClosure)
        //let pictureAction = UITableViewRowAction(style: .Normal, title: "Picture", handler: pictureClosure)
        
        return [deleteAction] //, editAction, pictureAction]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // Intentionally blank. Required to use UITableViewRowActions
    }
    
    /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        if  let notification = notifications?[row]{
            UIApplication.sharedApplication().cancelLocalNotification(notification)
            notifications = UIApplication.sharedApplication().scheduledLocalNotifications
            tableView.reloadData()
        }
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
