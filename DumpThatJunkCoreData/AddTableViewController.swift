//
//  AddTableViewController.swift
//  DumpThatJunkCoreData
//
//  Created by Mark CABIAO on 3/11/16.
//  Copyright © 2016 Mark CABIAO. All rights reserved.
//

import UIKit
import CoreData

class AddTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ButtonCellDelegate {
    
    var names = [String]()
    var locationNames = [NSManagedObject]()
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        fetchAllLocations()
    }
    
    func fetchAllLocations(){
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest(entityName: "Location")
        
        do{
            let fetchedResult = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult{
                locationNames = results
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
    
    var locationToUnitObject: NSObject? // object passed to Box view
    
    var segueToBoxName: String? // name passed to Box view
    
    
    @IBOutlet weak var onTableViewCell: UITableView!
    
    @IBAction func onButtonAddLocation(sender: AnyObject) {
        let alert = UIAlertController(title: "New Location", message: "Add a new location", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default){
            (action : UIAlertAction!) -> Void in
            let textField = alert.textFields![0] as UITextField!
            self.saveName(textField.text!)
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
        
        let pictureClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            print("Picture closure called")
        }
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: deleteClosure)
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit", handler: editClosure)
        let pictureAction = UITableViewRowAction(style: .Normal, title: "Picture", handler: pictureClosure)
        
        return [deleteAction, editAction, pictureAction]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // Intentionally blank. Required to use UITableViewRowActions
    }
    
    func deleteName(atIndex : Int)
    {
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let objectToRemove = locationNames[atIndex] as NSManagedObject
        
        managedContext.deleteObject(objectToRemove)
        
        do{
            try managedContext.save()
        }
        catch{
            print("There is some error while updating CoreData.")
        }
        
        locationNames.removeAtIndex(atIndex)
        
        self.onTableViewCell.reloadData()
    }
    
    func saveName(name: String)
    {
        let appDelegate    = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity         = NSEntityDescription.entityForName("Location", inManagedObjectContext: managedContext)
        let location       = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        location.setValue(name, forKey: "name")
        
        do{
            try managedContext.save()
        }
        catch{
            print("There is some error.")
        }
        
        //locationToUnitObject = location
        locationNames.append(location)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        title = "Location List"
        onTableViewCell.registerClass(UITableViewCell.self, forCellReuseIdentifier: "AddCell")
        //onTableViewCell.registerClass(UITableViewCell.self, forCellReuseIdentifier: "AddCell")
        
        
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
        return locationNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let theCell = tableView.dequeueReusableCellWithIdentifier("AddCell", forIndexPath: indexPath) as UITableViewCell!
        
        //tableView.separatorInset = UIEdgeInsetsZero
        
        theCell.accessoryType = .DisclosureIndicator
        
        let room = locationNames[indexPath.row]
        theCell.textLabel!.text = room.valueForKey("name") as? String
        
        
        //theCell.rowLabel.text = "\(indexPath.row)"
        //if theCell.buttonDelegate == nil {
        //    theCell.buttonDelegate = self
        //}
        
        return theCell
    }
    
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
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("AddBoxSegue", sender: self)
    }
    
    func editName(name : String, andIndex theIndex : Int)
    {
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest(entityName: "Location")
        
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
                
                if locationNames .contains(personToUpdate){
                    locationNames.replaceRange(theIndex...theIndex, with: [personToUpdate])
                    self.onTableViewCell.reloadData()
                }
            }
        }
        catch
        {
            print("Some error in fetching queries.")
        }
    }
    
    func showEditNameAlert(atIndex theIndex : Int)
    {
        let person     = locationNames[theIndex]
        let nameToEdit = person.valueForKey("name") as? String
        
        let alert = UIAlertController(title: "Update Location", message: "Edit a Location Name", preferredStyle: .Alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .Default){
            (action : UIAlertAction!) -> Void in
            
            let textField = alert.textFields![0] as UITextField!
            
            if nameToEdit != textField.text{
                self.editName(textField.text!, andIndex: theIndex)
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
            
            // get the cell that was tapped - sender
            // get the index path for that cell
            // use the index path to get the locationName from the array
            
            //guard let cell = sender as? UITableViewCell,
            //    let indexPath = tableView.indexPathForCell(cell)
            //    else{
            //        return
            //}
            
            boxVC?.locationObject = locationToUnitObject
            
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

