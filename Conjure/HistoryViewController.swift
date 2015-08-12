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
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.styleNavBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(seriesArray)
        
        seriesTable.delegate = self
        seriesTable.dataSource = self
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return seriesArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SeriesCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SeriesCell
        // Configure the cell...
        let series = seriesArray[indexPath.row]
        cell.deckNameLabel.text = String(series.deck.deckName)
        cell.winLossLabel.text = "\(series.wins)-\(series.losses)"
        
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
                let selectedSeries = seriesArray[indexPath.row]
                // the new view controller (A GameDetailViewController) is passed the series information
                destination.series = selectedSeries
            }
        }
        else {
            print("Nope")
        }
    }
}
