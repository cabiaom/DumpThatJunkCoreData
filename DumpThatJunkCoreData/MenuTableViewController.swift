//
//  MenuTableViewController.swift
//  DumpThatJunkCoreData
//
//  Created by Mark CABIAO on 3/5/16.
//  Copyright © 2016 Mark CABIAO. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var menuNames = ["Browse","Search","Notifications","About"]
    var menuPictures = ["commercial-delivery-symbol-of-a-list-on-clipboard-on-a-box-package",
                        "search-delivery-service-tool",
                        "delivery-box-and-timer",
                        "delivery-package-opened"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
            self.performSegueWithIdentifier("NotificationSegue", sender: self)
        }
        if indexPath.row == 3{
            self.performSegueWithIdentifier("AddLocationSegue", sender: self)
        }
        
    }



}
