//
//  SearchViewController.swift
//  DumpThatJunkCoreData
//
//  Created by Mark CABIAO on 4/14/16.
//  Copyright © 2016 Mark CABIAO. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var names = [String]()
    var objects = [NSManagedObject]()
    var locationNames = [NSManagedObject]()
    
    var searchActive : Bool = false
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.backgroundColor = UIColor.init(colorLiteralRed: 0.922, green: 0.71, blue: 0.545, alpha: 1)
        
        fetchAllLocations()
        
    }
    
    func fetchAllLocations(){
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest(entityName: "Item")
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            let fetchedResult = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult{
                locationNames = results
                
                for object in locationNames{
                    objects.append(object)
                    names.append((object.valueForKey("name") as? String)!)
                }
                
            }
            else{
                print("Could not fetch result")
            }
        }
        catch{
            print("There is some error.")
        }
        
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // change to - location names
        filtered = names.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return locationNames.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell;
        
        //if cell == nil{
            let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        //}
        
        cell.backgroundColor = UIColor.clearColor()
        
        let appDelegate    = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest(entityName: "Item")
        
       //cell.accessoryType = .DisclosureIndicator
        
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row]
            let key = filtered[indexPath.row]
            let predicate = NSPredicate(format: "%K == %@", "name", key)
            fetchRequest.predicate = predicate
            
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            do
            {
                let fetchResult = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
                
                for theResult in fetchResult!{
                    let name = theResult.valueForKey("name") as? String
                    print("Name found: \(name)")
                    let box = theResult.valueForKey("unit") as? BoxUnit
                    let boxName = box?.name
                    
                    let location = (box?.location)! as Location
                    let locationName = location.name
                    
                    
                    
                    print("\(boxName)")
                    cell.detailTextLabel?.numberOfLines = 0
                    cell.detailTextLabel?.text = "LOCATION:  "+locationName! + ",  BOX: " + boxName!
                    
                }
            }
            catch
            {
                print("Some error in fetching queries.")
            }
            
            
        } else {
            cell.textLabel?.text = names[indexPath.row]
            /*
            let room = locationNames[indexPath.row]
            let nameInCell = room.valueForKey("name") as? String
            cell.textLabel?.text = nameInCell
            names.append(nameInCell!)
             */
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(searchActive != true){
            let selectedName = names[indexPath.row]
            filtered.append(selectedName)
            
            if(filtered.count == 0){
                searchActive = false;
            } else {
                searchActive = true;
            }
 
            self.tableView.reloadData()
        } //else {
        //    cell.textLabel?.text = names[indexPath.row]
    }

}
