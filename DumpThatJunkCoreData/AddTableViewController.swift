//
//  AddTableViewController.swift
//  DumpThatJunkCoreData
//
//  Created by Mark CABIAO on 3/11/16.
//  Copyright © 2016 Mark CABIAO. All rights reserved.
//  Table views http://agstya.com/core-data-tutorial-in-swift-2-0/
//

import UIKit
import CoreData

class AddTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate{
    
    let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
    var context: NSManagedObjectContext!
    
    func junkFetchRequest() -> NSFetchRequest {
        
        let fetchRequest = NSFetchRequest(entityName: "Location")
        return fetchRequest
    }
    
    func controllerDidChangeContent(controller:
        NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    var names = [String]()
    var itemNames = [NSManagedObject]()
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        fetchAllLocations()
    }
    
    func fetchAllLocations(){
        
        //let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = delegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest   = NSFetchRequest(entityName: "Location")
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            let fetchedResult = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult{
                itemNames = results
            }
            else{
                print("Could not fetch result")
            }
        }
        catch{
            print("There is some error.")
        }
        
        
        self.onTableViewCell.reloadData()
    }
 
    
    var locationToUnitObject: NSManagedObject? // object passed to Box view
    
    var segueToBoxName: String? // name passed to Box view
    
    var idOfLocation: NSNumber? // location ID passed to Box view
    
    
    @IBOutlet weak var onTableViewCell: UITableView!
    
    @IBAction func onButtonAddLocation(sender: AnyObject) {
        let alert = UIAlertController(title: "New Location", message: "Add a new location", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default){
            (action : UIAlertAction!) -> Void in
            let textField = alert.textFields![0] as UITextField!
            self.saveLocation(textField.text!)
            self.onTableViewCell.reloadData()
            //self.onTableViewCell.bringSubviewToFront()
            //self.onTableViewCell.backgroundColor("transparent")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default){
            (action : UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler{
            (textField : UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
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
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // Intentionally blank. Required to use UITableViewRowActions
    }
    
    func deleteName(atIndex : Int)
    {
        
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let objectToRemove = itemNames[atIndex] as NSManagedObject
 
        managedContext.deleteObject(objectToRemove)
        
        do{
            try managedContext.save()
        }
        catch{
            print("There is some error while updating CoreData.")
        }
        
        itemNames.removeAtIndex(atIndex)
        
        self.onTableViewCell.reloadData()
        
    }
    
    func saveLocation(location: String)
    {
        
        let appDelegate    = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity         = NSEntityDescription.entityForName("Location", inManagedObjectContext: managedContext)
        let itemLocation       = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
 
 
        //let date = NSDate.init()
        
        itemLocation.setValue(location, forKey: "name")
        //itemLocation.setValue(date, forKey: "dateModified")
        
        // use date as unique id
         let date : Double = NSDate().timeIntervalSince1970
        itemLocation.setValue(date, forKey: "locationID")
        
        
        do{
            try managedContext.save()
        }
        catch{
            print("There is some error.")
        }
        
        //idOfLocation = date
        //locationToUnitObject = itemLocation
        itemNames.append(itemLocation)
        fetchAllLocations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //title = "Locations"
        //tableView.backgroundColor = UIColor.init(colorLiteralRed: 0.973, green: 0.945, blue: 0.827, alpha: 1)
        onTableViewCell.registerClass(UITableViewCell.self, forCellReuseIdentifier: "AddCell")
        //onTableViewCell.registerClass(UITableViewCell.self, forCellReuseIdentifier: "AddCell")
        configureView()
        
    }
    
    func configureView(){
        title = "Locations"
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
    
    /*
     
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 5
     }
     
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     // runs once for each row in nuberOfRowsInSection
     let cell = tableView.dequeueReusableCellWithIdentifier("AddCell", forIndexPath: indexPath)
     
     cell.textLabel?.text = "Hello Add"
     
     cell.imageView?.image = UIImage(named: "delivery-packaging-box")
     
     return cell
     }
     */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return itemNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let theCell = tableView.dequeueReusableCellWithIdentifier("AddCell", forIndexPath: indexPath) as UITableViewCell!
        
        //tableView.separatorInset = UIEdgeInsetsZero
        
        theCell.accessoryType = .DisclosureIndicator
        
        let room = itemNames[indexPath.row]
        theCell.textLabel!.text = room.valueForKey("name") as? String
        
        theCell.backgroundColor = UIColor.clearColor()
        
        //theCell.rowLabel.text = "\(indexPath.row)"
        //if theCell.buttonDelegate == nil {
        //    theCell.buttonDelegate = self
        //}
        
        return theCell
    }
    /*
    func cellTapped(cell: ButtonCell) {
        self.showAlertForRow(tableView.indexPathForCell(cell)!.row)
    }
    
    func showAlertForRow(row: Int) {
        let alert = UIAlertController(
            title: "BEHOLD",
            message: "Cell at row \(row) was tapped!",
            preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Gotcha!", style: UIAlertActionStyle.Default, handler: { (test) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(
            alert,
            animated: true,
            completion: nil)
    }
    */
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest(entityName: "Location")
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do
        {
            let fetchResult = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let theResult = fetchResult{
                locationToUnitObject = theResult[indexPath.row] as NSManagedObject
                idOfLocation = locationToUnitObject?.valueForKey("locationID") as? NSNumber
                segueToBoxName = locationToUnitObject?.valueForKey("name") as? String
                print("did select: \(idOfLocation)")
            }
        }
        catch
        {
            print("Some error in fetching queries.")
        }
        
        performSegueWithIdentifier("AddBoxSegue", sender: self)
    }
    
    func editLocation(name : String, andIndex theIndex : Int)
    {
        
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest(entityName: "Location")
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do
        {
            let fetchResult = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let theResult = fetchResult{
                let personToUpdate = theResult[theIndex] as NSManagedObject
                personToUpdate.setValue(name, forKey:"name")
                
                do{
                    try managedContext.save()
                }
                catch{
                    print("There is some error.")
                }
                
                if itemNames .contains(personToUpdate){
                    itemNames.replaceRange(theIndex...theIndex, with: [personToUpdate])
                    self.onTableViewCell.reloadData()
                }
            }
        }
        catch
        {
            print("Some error in fetching queries.")
        }
        
        fetchAllLocations()
        
    }
    
    func showEditNameAlert(atIndex theIndex : Int)
    {
        let person     = itemNames[theIndex]
        let nameToEdit = person.valueForKey("name") as? String
        
        let alert = UIAlertController(title: "Update Location", message: "Edit a Location Name", preferredStyle: .Alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .Default){
            (action : UIAlertAction!) -> Void in
            
            let textField = alert.textFields![0] as UITextField!
            
            if nameToEdit != textField.text{
                self.editLocation(textField.text!, andIndex: theIndex)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddBoxSegue"{
            
            let boxVC = segue.destinationViewController as? BoxTableViewController
            boxVC?.locationObject = locationToUnitObject
            boxVC?.applicationDelegate = delegate
            boxVC?.idOfLocation = idOfLocation
            boxVC?.locationName = segueToBoxName
            print(segueToBoxName)
            print(boxVC?.locationName)
            
        }
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        print("add segue to box view")
        //performSegueWithIdentifier("AddBoxSegue", sender: self)
        //doSomethingWithItem(indexPath.row)
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

