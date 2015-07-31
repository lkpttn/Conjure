//
//  DeckTableViewController.swift
//  Conjure
//
//  Created by Luke Patton on 7/17/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class DeckTableViewController: UITableViewController {
    
    var deckDictionary = [String: Deck]()
    var deckArray = [Deck]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.styleNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Turn the deckDictionary into a deckarray
        for (deckName, deck) in deckDictionary {
            print(deckName)
            deckArray.append(deck)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deckArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SeriesCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SeriesCell
        // Configure the cell...
        let deck = deckArray[indexPath.row]
        cell.deckNameLabel.text = String(deck.deckName)
        cell.winLossLabel.text = "\(deck.wins)-\(deck.losses)"
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            deckArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func styleNavBar() {
        let navBar = self.navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar?.shadowImage = UIImage()
        navBar?.translucent = true
        navBar!.barTintColor = UIColor.clearColor()
    }
    
    // MARK: Segue actions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDeckDetail" {
            print("Getting information from the cell")
            // Downcasting the destination view controller as a DeckDetailViewController
            let destination = segue.destinationViewController as! DeckDetailViewController
            
            // Get the cell that generated the segue
            if let selectedSeriesCell = sender as? SeriesCell {
                // Find the index path for the cell that sent the segue
                let indexPath = tableView.indexPathForCell(selectedSeriesCell)!
                // selected series is set to the series at that indexPath
                let selectedDeck = deckArray[indexPath.row]
                // the new view controller (A DeckDetailViewController) is passed the series information
                destination.deck = selectedDeck
                destination.deckDictionary = deckDictionary
            }
        }
        else if segue.identifier == "addNewDeck" {
            print("Getting information from the cell")
            let destination = segue.destinationViewController as! DeckDetailViewController
            destination.deckDictionary = deckDictionary
        }
        else {
            print("Nope")
        }
    }
    
    @IBAction func unwindToDeckTableView(sender: UIStoryboardSegue) {
        let source = sender.sourceViewController as? DeckDetailViewController
        // Find the deck indexPath
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // Delete from dictionary and array
            deckDictionary.removeValueForKey((source?.deck?.deckName)!)
            deckArray.removeAtIndex(selectedIndexPath.row)
            tableView.deleteRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .Fade)
        }
    }
}
