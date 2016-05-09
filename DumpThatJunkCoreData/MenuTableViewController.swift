//
//  MenuTableViewController.swift
//  DumpThatJunkCoreData
//
//  Created by Mark CABIAO on 3/5/16.
//  Copyright © 2016 Mark CABIAO. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    //var coreDataStack: CoreDataStack!
    
    var menuNames = ["Inventory","Search","Future Notifications","Expired Boxes","About"]
    var menuPictures = ["contract",
                        "magnifying-glass",
                        "ring",
                        "clock","notepad"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.backgroundColor = UIColor.init(colorLiteralRed: 0.863, green: 0.863, blue: 0.867, alpha: 1)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        title = "Main Menu"
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
        return menuNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // runs once for each row in nuberOfRowsInSection
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = menuNames[indexPath.row]
        
        cell.backgroundColor = UIColor.clearColor()
        
        cell.imageView?.image = UIImage(named: menuPictures[indexPath.row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0{
            self.performSegueWithIdentifier("AddSegue", sender: self)
        }
        if indexPath.row == 1{
            self.performSegueWithIdentifier("SearchSegue", sender: self)
        }
        if indexPath.row == 2{
            
            // ask for permission to get local notifications
            let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
            
            self.performSegueWithIdentifier("NotificationSegue", sender: self)
        }
        if indexPath.row == 4{
            self.performSegueWithIdentifier("AboutSegue", sender: self)
        }
        if indexPath.row == 3{
            self.performSegueWithIdentifier("ExpiredSegue", sender: self)
        }
    }
    
   


}
