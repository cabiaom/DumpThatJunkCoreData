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
    
    var boxes = [String]()
    var boxNames = [NSManagedObject]()
    
    // location object passed in from Add Table View Controller
    var locationObject: NSManagedObject?
    
    var idOfLocation: Double?
    
    // name of location from Add Table View Controller
    var locationName: String?
    
    // name of box sending to Item Table View Controller
    var unitToItemObject: NSObject?
    
    var segueToItemName: String?

    @IBOutlet weak var onTableViewBoxCell: UITableView!
    
    
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
        
        
        let appDelegate    = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity         = NSEntityDescription.entityForName("Unit", inManagedObjectContext: managedContext)
        
        // create Unit
        let unit       = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        // popluate Unit
        unit.setValue(name, forKey: "name")
        
        do
        {
            try managedContext.save()
        }
        catch
        {
            print("There is some error saving a unit.")
        }
        
        // create relation of Unit to Location
        /*
        let fetchRequest = NSFetchRequest(entityName: "Location")
        let predicate = NSPredicate(format: "%K MATCHES %@", "locationID", idOfLocation!)
        fetchRequest.predicate = predicate
        
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let theResult = result{
                let locationToRelate = theResult[0] as NSManagedObject
                locationToRelate.setValue(NSSet(object: unit), forKey: "units")
            }
            
            do{
                try managedContext.save()
            }
            catch{
                print("There is an error relating a unit to a location.")
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        */
        
        
        
        //unitToItemObject = unit
        boxNames.append(unit)
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //locationNameLabel.text = locationName
        
        //if locationName = nil{
        //    title = // get from view controller that it was coming from
        //}
        
        
        
        
        //print("boxtableview: ")
        // title
        print("\(idOfLocation)")
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        fetchAllBoxes()
    }
    
    func fetchAllBoxes(){
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest(entityName: "Unit")
        
        do{
            let fetchedResult = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult{
                boxNames = results
            }
            else{
                print("Could not fetch result")
            }
        }
        catch{
            print("There is an error saving the Unit name.")
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
        
        // box name
        let room = boxNames[indexPath.row]
        cell.textLabel!.text = room.valueForKey("name") as? String
        
        
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        segueToItemName = currentCell.textLabel?.text
        print(segueToItemName)
        
        performSegueWithIdentifier("AddItemSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItemSegue"{
            let boxVC = segue.destinationViewController as? ItemTableViewController
            
            boxVC?.unitObject = unitToItemObject
            boxVC?.unitName = segueToItemName
            print(segueToItemName)
            print(boxVC?.unitName)
            
        }
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
