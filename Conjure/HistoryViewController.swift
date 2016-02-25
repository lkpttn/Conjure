//
//  HistoryViewController.swift
//  Conjure
//
//  Created by Luke Patton on 7/31/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var seriesTable: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    var seriesArray = [Series]()
    var dateArray = [String]()
    var dateDictionary = [String: [Series]]()
    
    let settings = NSUserDefaults.standardUserDefaults()
    
    
    let redColor = UIColor(red: 208/255.0, green: 2/255.0, blue: 27/255.0, alpha: 1)
    let greenColor = UIColor(red: 92/255.0, green: 176/255.0, blue: 0, alpha: 1)
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.styleNavBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        seriesTable.delegate = self
        seriesTable.dataSource = self
        seriesTable.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        let dayFormatter = NSDateFormatter()
        dayFormatter.dateFormat = "MMM d, y"
        
        // For every series in the master array
        for series in seriesArray {
            // Grab the NSDate on each series
            // Format the NSDate as a date string "Friday"
            let day = dayFormatter.stringFromDate(series.date)
            
            // if dateDictionary doesn't have a "Friday" key, make one and add an element to the array with value "Friday"
            if(dateDictionary[day] == nil) {
                dateDictionary[day] = []
                dateArray.append(day)
            }
            
            // Add the series to the "Friday" key value pair
            dateDictionary[day]?.append(series)
        }
        
        let didPurchase = settings.boolForKey("didPurchase")
        if didPurchase == false && seriesArray.count == 4 {
            let alert = UIAlertController(title: "You can only store four matches in the free version", message: "You can delete previous matches or purchase the full version of the app to save new matches.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok, got it.", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    func styleNavBar() {
        let navBar = self.navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar?.shadowImage = UIImage()
        navBar?.translucent = true
        navBar!.barTintColor = UIColor.clearColor()
    }
    
    // MARK: Table methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dateArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = dateArray[section]
        return dateDictionary[date]!.count;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = dateArray[section]
        return date
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let date = dateArray[indexPath.section]
        let seriesOnDate = dateDictionary[date]!
        let series = seriesOnDate[indexPath.row]
        
        let cellIdentifier = "SeriesCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SeriesCell
        
        // Configure the cell...
        cell.deckNameLabel.text = String(series.deck.deckName)
        
        if series.tie == true {
            cell.winLossLabel.textColor = UIColor.lightGrayColor()
            cell.winLossLabel.text = "T \(series.wins)-\(series.losses)"
        }
        else if series.wins > series.losses {
            cell.winLossLabel.textColor = greenColor
            cell.winLossLabel.text = "W \(series.wins)-\(series.losses)"
        }
        else if series.losses > series.wins {
            cell.winLossLabel.textColor = redColor
            cell.winLossLabel.text = "L \(series.wins)-\(series.losses)"
        }
        
        return cell
    }
    
    // MARK: NSCoding
    func saveSeries() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(seriesArray, toFile: Series.ArchiveURL.path!)
        print("Saved this series")
        if !isSuccessfulSave {
            print("Failure!")
        }
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            seriesArray.removeAtIndex(indexPath.row)
            
            let date = dateArray[indexPath.section]
            dateDictionary[date]!.removeAtIndex(indexPath.row)
            
            saveSeries()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showGameDetail" {
            print("Getting information from the cell")
            // Downcasting the destination view controller as a GameDetailViewController
            let destination = segue.destinationViewController as! GameDetailViewController
            
            // Get the cell that generated the segue
            if let selectedSeriesCell = sender as? SeriesCell {
                // Find the index path for the cell that sent the segue
                let indexPath = seriesTable.indexPathForCell(selectedSeriesCell)!
                
                let date = dateArray[indexPath.section]
                let seriesOnDate = dateDictionary[date]!
                let series = seriesOnDate[indexPath.row]
                let selectedSeries = series
                
                // the new view controller (A GameDetailViewController) is passed the series information
                destination.series = selectedSeries
                destination.seriesArray = seriesArray
            }
        }
        else {
            print("Nope")
        }
    }
}
