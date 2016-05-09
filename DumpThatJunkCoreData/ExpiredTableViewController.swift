//
//  ExpiredTableViewController.swift
//  DumpThatJunkCoreData
//
//  Created by Mark CABIAO on 5/2/16.
//  Copyright © 2016 Mark CABIAO. All rights reserved.
//  Some code adapted from http://agstya.com/core-data-tutorial-in-swift-2-0
//

import UIKit
import CoreData

class ExpiredTableViewController: UITableViewController {
    
    @IBOutlet weak var onTableViewBoxCell: UITableView!
    
    var boxes = [String]()
    var boxNames = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.backgroundColor = UIColor.init(colorLiteralRed: 1, green: 0.898, blue: 0.851, alpha: 1)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        title = "Expired Boxes"
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
        return boxNames.count
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            print("Delete closure called")
            self.deleteName(indexPath.row)
        }
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: deleteClosure)
        
        return [deleteAction] //, editAction, pictureAction]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // Intentionally blank. Required to use UITableViewRowActions
    }

    func deleteName(atIndex : Int)
    {
        
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let objectToRemove = boxNames[atIndex] as NSManagedObject
        
        managedContext.deleteObject(objectToRemove)
        
        do{
            try managedContext.save()
        }
        catch{
            print("There is some error while updating CoreData.")
        }
        
        boxNames.removeAtIndex(atIndex)
        
        self.onTableViewBoxCell.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        fetchAllBoxes()
    }
    
    func fetchAllBoxes(){
        
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest(entityName: "BoxUnit")
        //let doubleid = idOfLocation! as Double
        //print ("double id: \(doubleid)")
        
        //print("idOfLocation \(idOfLocation)")
        
        let currentDate = NSDate()
        
        let monthsToAdd = 0
        let daysToAdd = -1
        
        var calculatedDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Month, value: monthsToAdd, toDate: currentDate, options: NSCalendarOptions.init(rawValue: 0))
        calculatedDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: daysToAdd, toDate: calculatedDate!, options: NSCalendarOptions.init(rawValue: 0))
        
        // fetch only dates that are greater than
        
        let locationIdPredicate = NSPredicate(format: "%K < %@", "dateModified" , calculatedDate!)
        fetchRequest.predicate = locationIdPredicate
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            let fetchedResult = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult{
                //boxNames = results
                print("All the boxes: \(boxNames)") // fault
                for box in results{
                    
                    //print (" _")
                    //let name = box.valueForKey( "name")
                    //print("box name: \(name)")
                    
                    //let idlocation = box.valueForKey("Location") as? Location
                    //let idloc = idlocation?.locationID
                    //print ("idlocation: \(idloc)")
                    
                    let dateModified = box.valueForKey("dateModified") as? NSDate
                    
                     if (calculatedDate?.timeIntervalSinceReferenceDate > dateModified?.timeIntervalSinceReferenceDate){
                     boxNames.append(box)
                     }
                    
                }
                
            }
            else{
                print("Could not fetch result")
            }
        }
        catch{
            print("There is an error fetching all the boxes.")
        }
        
        self.onTableViewBoxCell.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("boxCell", forIndexPath: indexPath)
        
        tableView.separatorInset = UIEdgeInsetsZero
        
        cell.backgroundColor = UIColor.clearColor()
        
        //cell.accessoryType = .DisclosureIndicator
        
        // box name
        let room = boxNames[indexPath.row]
        let name = room.valueForKey("name") as? String
        // box modified date
        let dateNS = room.valueForKey("dateModified") as? NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let dateString = dateFormatter.stringFromDate(dateNS!)
        // box location
        
        let location = room.valueForKey("location") as! Location
        let locationName = location.name
        
        cell.textLabel!.text = name!
        cell.detailTextLabel?.text = "EXPIRED: " + dateString + ", LOCATION: " + locationName!
        
        return cell
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
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
