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
    
    
    let redColor = UIColor(red: 208/255.0, green: 2/255.0, blue: 27/255.0, alpha: 1)
    let greenColor = UIColor(red: 92/255.0, green: 176/255.0, blue: 0, alpha: 1)
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.styleNavBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // var orderedDictionary = OrderedDictionary()
        
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
            print(day)
            
            // if dateDictionary doesn't have a "Friday" key, make one and add an element to the array with value "Friday"
            if(dateDictionary[day] == nil) {
                dateDictionary[day] = []
                dateArray.append(day)
            }
            
            // Add the series to the "Friday" key value pair
            dateDictionary[day]?.append(series)
        }
    }

    func styleNavBar() {
        let navBar = self.navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar?.shadowImage = UIImage()
        navBar?.translucent = true
        navBar!.barTintColor = UIColor.clearColor()
        
        let headerColor = UIColor(red: 22/255.0, green: 48/255.0, blue: 63/255.0, alpha: 1)
        headerView.backgroundColor = headerColor
    }
    
    // MARK: Table methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return dateDictionary.count
        return dateArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // let date : String = Array(dateDictionary.keys)[section]
        let date = dateArray[section]
        return dateDictionary[date]!.count;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // let date : String = Array(dateDictionary.keys)[section]
        let date = dateArray[section]
        return date
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // let date : String = Array(dateDictionary.keys)[indexPath.section]
        let date = dateArray[indexPath.section]
        let seriesOnDate = dateDictionary[date]!
        let series = seriesOnDate[indexPath.row]
        
        let cellIdentifier = "SeriesCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SeriesCell
        // Configure the cell...
        // let series = seriesArray[indexPath.row]
        cell.deckNameLabel.text = String(series.deck.deckName)
        
        if series.wins > series.losses {
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
    // Save or load the series whenever there's an update
    func saveSeries() {
        // An archiver object that saves the meal array to the ArchivePath we defined in Series
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
                
                // selected series is set to the series at that indexPath
                let date : String = Array(dateDictionary.keys)[indexPath.section]
                let seriesOnDate = dateDictionary[date]!
                let series = seriesOnDate[indexPath.row]
                let selectedSeries = series
                
                // the new view controller (A GameDetailViewController) is passed the series information
                destination.series = selectedSeries
            }
        }
        else {
            print("Nope")
        }
    }
}
