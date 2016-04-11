//
//  AddLocationViewController.swift
//  DumpThatJunkCoreData
//
//  Created by Mark CABIAO on 3/6/16.
//  Copyright © 2016 Mark CABIAO. All rights reserved.
//

import UIKit
import CoreData

class AddLocationViewController: UIViewController {
    
    var names = [String]()
    var locationNames = [NSManagedObject]()

    @IBOutlet weak var onTableViewCell: UITableView!
    
    @IBAction func onButtonAddLocation(sender: AnyObject) {
        let alert = UIAlertController(title: "New Location", message: "Add a new location", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default){
                (action : UIAlertAction!) -> Void in
                let textField = alert.textFields![0] as UITextField!
                self.saveName(textField.text!)
                self.onTableViewCell.reloadData()
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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Location List"
        onTableViewCell.registerClass(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func saveName(name: String)
    {
        let appDelegate    = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity         = NSEntityDescription.entityForName("Location", inManagedObjectContext: managedContext)
        
        let location       = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        location.setValue(name, forKey: "name")
        
        do
        {
            try managedContext.save()
        }
        catch
        {
            print("There is some error saving a location.")
        }
        
        locationNames.append(location)
    }

}

extension AddLocationViewController : UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return locationNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let theCell = tableView.dequeueReusableCellWithIdentifier("locationCell") as UITableViewCell!
        
        tableView.separatorInset = UIEdgeInsetsZero
        
        let room = locationNames[indexPath.row]
        theCell.textLabel!.text = room.valueForKey("name") as? String
        
        return theCell
    }
}

