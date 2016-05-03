//
//  BoxTableViewController.swift
//  DumpThatJunkCoreData
//
//  Created by Mark CABIAO on 3/14/16.
//  Copyright © 2016 Mark CABIAO. All rights reserved.
//

import UIKit
import CoreData

class BoxTableViewController: UITableViewController {
    
    var context: NSManagedObjectContext!
    
    var applicationDelegate: AppDelegate?
    
    var boxes = [String]()
    var boxNames = [NSManagedObject]()
    
    // location object passed in from Add Table View Controller
    var locationObject: NSManagedObject?
    // location id passed in from Add Table View Controller
    var idOfLocation: NSNumber?
    // name of location from Add Table View Controller
    var locationName: String?
    
    // name of box sending to Item Table View Controller
    var unitToItemObject: NSObject?
    var boxUnitName: String?
    var idOfBoxUnit: NSNumber?
    
    var segueToItemName: String?

    @IBOutlet weak var onTableViewBoxCell: UITableView!
    
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
        let fetchRequest   = NSFetchRequest(entityName: "BoxUnit")
        
        let predicate = NSPredicate(format: "location.locationID == %@", idOfLocation! )
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do
        {
            let fetchResult = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let theResult = fetchResult{
                
                let personToUpdate = theResult[theIndex] as NSManagedObject
                
                let oldName = personToUpdate.valueForKey("name") as? String
                
                print ("count: \(boxNames.count)")
                
                print("Old name: \(oldName)")
                
                personToUpdate.setValue(name, forKey:"name")
                
                print("New name: \(name)")
                
                do{
                    try managedContext.save()
                }
                catch{
                    print("There is some error.")
                }
                
                if boxNames.contains(personToUpdate){
                    boxNames.replaceRange(theIndex...theIndex, with: [personToUpdate])
                    self.onTableViewBoxCell.reloadData()
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
        let person     = boxNames[theIndex]
        let nameToEdit = person.valueForKey("name") as? String
        
        let alert = UIAlertController(title: "Update Unit", message: "Edit a Unit Name", preferredStyle: .Alert)
        
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
    
    
    @IBAction func onButtonAddBox(sender: AnyObject) {
        
        let alert = UIAlertController(title: "New Unit", message: "Add a new unit", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default){
            (action : UIAlertAction!) -> Void in
            let textField = alert.textFields![0] as UITextField!
            self.saveName(textField.text!)
            self.onTableViewBoxCell.reloadData()
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
    
    func saveName(name: String){
        
        
        //let boxappDelegate    = UIApplication.sharedApplication().delegate as? AppDelegate
        let boxappDelegate = applicationDelegate
        let boxmanagedContext = boxappDelegate!.managedObjectContext
        let boxentity         = NSEntityDescription.entityForName("BoxUnit", inManagedObjectContext: boxmanagedContext)
        
        // create Unit
        let unit       = NSManagedObject(entity: boxentity!, insertIntoManagedObjectContext: boxmanagedContext)
        
        // popluate Unit
        //boxentity.setValue(name, forKey: "name")
        
        unit.setValue(name, forKey: "name")
        
        // use date as unique id
        let date : Double = NSDate().timeIntervalSince1970
        unit.setValue(date, forKey: "unitID")
        
        // relate to location object
        unit.setValue(locationObject, forKey: "location")
        
        do{
            try boxmanagedContext.save()
        }catch{
            print ("error with saving a unit")
        }
        
        boxNames.append(unit)
    }

    override func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)
        
        if parent == nil{
            print("Back Button pressed.")
            boxNames.removeAll()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = locationName
        
        print("Enter Box view with ID: \(idOfLocation)")
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        fetchAllBoxes()
    }
    
    func fetchAllBoxes(){
        
        //let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = applicationDelegate
        
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest   = NSFetchRequest(entityName: "BoxUnit")
        //let doubleid = idOfLocation! as Double
        //print ("double id: \(doubleid)")
        
        print("idOfLocation \(idOfLocation)")
        
        // fetch only what is for this particular id
        let locationIdPredicate = NSPredicate(format: "%K == %@", "location.locationID" , idOfLocation!)
        fetchRequest.predicate = locationIdPredicate
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            let fetchedResult = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult{
                boxNames = results
                print("All the boxes: \(boxNames)") // fault
                for box in results{
                    
                    print (" _")
                    let name = box.valueForKey( "name")
                    print("box name: \(name)")
                    
                    let idlocation = box.valueForKey("Location") as? Location
                    let idloc = idlocation?.locationID
                    print ("idlocation: \(idloc)")
                    
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
        
        self.onTableViewBoxCell.reloadData()
        
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
        return boxNames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("boxCell", forIndexPath: indexPath)

        tableView.separatorInset = UIEdgeInsetsZero
        
        cell.accessoryType = .DisclosureIndicator
        
        // box name
        let room = boxNames[indexPath.row]
        cell.textLabel!.text = room.valueForKey("name") as? String

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest(entityName: "BoxUnit")
        
        // fetch only what is for this particular id
        let locationIdPredicate = NSPredicate(format: "%K == %@", "location.locationID" , idOfLocation!)
        fetchRequest.predicate = locationIdPredicate
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do
        {
            let fetchResult = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let theResult = fetchResult{
                unitToItemObject = theResult[indexPath.row] as NSManagedObject
                idOfBoxUnit = unitToItemObject?.valueForKey("unitID") as? NSNumber
                boxUnitName = unitToItemObject?.valueForKey("name") as? String
                print("did select: \(idOfBoxUnit)")
                print("did select: \(boxUnitName)")
            }
        }
        catch
        {
            print("Some error in fetching queries.")
        }
        
        performSegueWithIdentifier("AddItemSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItemSegue"{
            let itemVC = segue.destinationViewController as? ItemTableViewController
            
            itemVC?.unitObject = unitToItemObject
            itemVC?.unitName = boxUnitName
            itemVC?.idOfBoxUnit = idOfBoxUnit
            print(segueToItemName)
            print(itemVC?.unitName)
            
        }
    }
}
