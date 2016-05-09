//
//  ItemTableViewController.swift
//  DumpThatJunkCoreData
//
//  Created by Mark CABIAO on 3/19/16.
//  Copyright © 2016 Mark CABIAO. All rights reserved.
//  Code adapted from Table views http://agstya.com/core-data-tutorial-in-swift-2-0/
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController {
    
    var items = [String]()
    var itemNames = [NSManagedObject]()
    
    @IBOutlet weak var onTableViewItemCell: UITableView!
    
    // box (unit) object passed in from the Add Table View Controller
    var unitObject: NSObject?
    
    // name of box (unit) from Item View Controller
    var unitName: String?
    
    var idOfBoxUnit: NSNumber?
    
    var applicationDelegate: AppDelegate?
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            print("Delete closure called")
            self.deleteName(indexPath.row)
        }
        
        let editClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            print("Edit closure called")
            self.showEditNameAlert(atIndex: indexPath.row)
        }
        /*
         let pictureClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
         print("Picture closure called")
         }
         */
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: deleteClosure)
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit", handler: editClosure)
        //let pictureAction = UITableViewRowAction(style: .Normal, title: "Picture", handler: pictureClosure)
        
        return [deleteAction, editAction]//, pictureAction]
    }
    
    func editUnit(name : String, andIndex theIndex : Int)
    {
        
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest(entityName: "Item")
        
        let predicate = NSPredicate(format: "unit.unitID == %@", idOfBoxUnit! )
        fetchRequest.predicate = predicate
        
        // set time for unit because unit was edited
        let todaysDate = NSDate()
        unitObject?.setValue(todaysDate, forKey: "dateModified")
        scheduleLocalnotification()
        print("date updated EDIT: \(todaysDate)")
        
        do
        {
            let fetchResult = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let theResult = fetchResult{
                
                let personToUpdate = theResult[theIndex] as NSManagedObject
                
                let oldName = personToUpdate.valueForKey("name") as? String
                
                print ("count: \(itemNames.count)")
                
                print("Old name: \(oldName)")
                
                personToUpdate.setValue(name, forKey:"name")
                
                print("New name: \(name)")
                
                do{
                    try managedContext.save()
                }
                catch{
                    print("There is some error.")
                }
                
                if itemNames.contains(personToUpdate){
                    itemNames.replaceRange(theIndex...theIndex, with: [personToUpdate])
                    self.onTableViewItemCell.reloadData()
                }
            }
        }
        catch
        {
            print("Some error in fetching queries.")
        }
        
        fetchAllItems()
        
    }
    
    func showEditNameAlert(atIndex theIndex : Int)
    {
        let person     = itemNames[theIndex]
        let nameToEdit = person.valueForKey("name") as? String
        
        let alert = UIAlertController(title: "Update Item", message: "Edit an Item Name", preferredStyle: .Alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .Default){
            (action : UIAlertAction!) -> Void in
            
            let textField = alert.textFields![0] as UITextField!
            
            if nameToEdit != textField.text{
                self.editUnit(textField.text!, andIndex: theIndex)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default){
            (action : UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler{
            (textField : UITextField!) -> Void in
            textField.text = nameToEdit
        }
        
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func deleteName(atIndex : Int)
    {
        
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let objectToRemove = itemNames[atIndex] as NSManagedObject
        
        managedContext.deleteObject(objectToRemove)
        
        // set time for unit because unit was edited
        let todaysDate = NSDate()
        unitObject?.setValue(todaysDate, forKey: "dateModified")
        scheduleLocalnotification()
        print("date updated DELETE: \(todaysDate)")
        
        
        do{
            try managedContext.save()
        }
        catch{
            print("There is some error while updating CoreData.")
        }
        
        itemNames.removeAtIndex(atIndex)
        
        self.onTableViewItemCell.reloadData()
        
    }


    @IBAction func onButtonAddItem(sender: AnyObject) {
        let alert = UIAlertController(title: "New Item", message: "Add a new item", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default){
            (action : UIAlertAction!) -> Void in
            let textField = alert.textFields![0] as UITextField!
            self.saveName(textField.text!)
            self.onTableViewItemCell.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default){
            (action : UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler
            {
                (textField : UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveName(name: String){
        
        let appDelegate    = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity         = NSEntityDescription.entityForName("Item", inManagedObjectContext: managedContext)
        
        let item       = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        
        // use date as unique id
        let date : Double = NSDate().timeIntervalSince1970
        item.setValue(date, forKey: "itemID")
        
        // set relationsip to unit
        item.setValue(unitObject, forKey: "unit")
        
        // set time for unit because unit was edited
        let todaysDate = NSDate()
        unitObject?.setValue(todaysDate, forKey: "dateModified")
        scheduleLocalnotification()
        print("date updated SAVE: \(todaysDate)")

        item.setValue(name, forKey: "name")
        
        do
        {
            try managedContext.save()
        }
        catch
        {
            print("There is some error.")
        }
        
        itemNames.append(item)
        
        fetchAllItems()
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //tableView.backgroundColor = UIColor.init(colorLiteralRed: 0.498, green: 0.706, blue: 0.596, alpha: 1)
        
        title = unitName
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        fetchAllItems()
    }
    
    func fetchAllItems(){
        
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        //let appDelegate = applicationDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest(entityName: "Item")
        //let doubleid = idOfLocation! as Double
        //print ("double id: \(doubleid)")
        
        print("idOfLocation \(idOfBoxUnit)")
        
        // fetch only what is for this particular id
        let locationIdPredicate = NSPredicate(format: "%K == %@", "unit.unitID" , idOfBoxUnit!)
        fetchRequest.predicate = locationIdPredicate
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            let fetchedResult = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult{
                itemNames = results
                print("All the boxes: \(itemNames)") // fault
                for box in results{
                    
                    print (" _")
                    let name = box.valueForKey( "name")
                    print("Item name: \(name)")
                    
                    let idlocation = box.valueForKey("unit") as? BoxUnit
                    let idloc = idlocation?.unitID
                    print ("idbox: \(idloc)")
                    
                    /*
                     if (idloc == idOfLocation){
                     boxNames.append(box)
                     }
                     */
                }
                
            }
            else{
                print("Could not fetch result")
            }
        }
        catch{
            print("There is an error fetching all the boxes.")
        }
        
        self.onTableViewItemCell.reloadData()
        
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
        return itemNames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath)

        tableView.separatorInset = UIEdgeInsetsZero
        
        //cell.accessoryType = .DisclosureIndicator
        cell.backgroundColor = UIColor.clearColor()
        let room = itemNames[indexPath.row]
        cell.textLabel!.text = room.valueForKey("name") as? String
        let cellname = room.valueForKey("name") as? String
        print("cell draw: \(cellname)")

        return cell
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)
        
        if parent == nil{
            print("Back Button pressed.")
            itemNames.removeAll()
        }
        
    }
    
    func deleteOldNotification(){
        let app:UIApplication = UIApplication.sharedApplication()
        for oneEvent in app.scheduledLocalNotifications! {
            let notification = oneEvent as UILocalNotification
            let userInfoCurrent = notification.userInfo! as! [String:NSNumber]
            let uid = userInfoCurrent["w00t"]! as NSNumber
            if uid == idOfBoxUnit {
                //Cancelling local notification
                app.cancelLocalNotification(notification)
                break;
            }
        }
    }
    
    func scheduleLocalnotification() {
        
        deleteOldNotification()
        
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return }
        
        if settings.types == .None {
            let ac = UIAlertController(title: "Can't schedule notification", message: "Please turn on notifications for this app under the notifications menu.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 30)
        let message: String
        if let unitNameText = unitName {
            message = "You have not used any items in the \(unitNameText) box for 6 months!"
            notification.alertBody = message
        }
        notification.alertAction = "be awesome and dontate the items now!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["w00t": idOfBoxUnit!]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
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
