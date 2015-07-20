//
//  DeckTableViewController.swift
//  Conjure
//
//  Created by Luke Patton on 7/17/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class DeckTableViewController: UITableViewController {
    
    var deckArray = [Deck]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testDeck = Deck(deckName: "Test Deck")
        testDeck.wins = 16
        testDeck.losses = 4
        deckArray.append(testDeck)
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
        print(deck)
        cell.deckNameLabel.text = String(deck.deckName)
        cell.winLossLabel.text = "\(deck.wins)-\(deck.losses)"
        
        
        return cell

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
            }
        }
        else if segue.identifier == "addNewDeck" {
            print("Getting information from the cell")
            // Downcasting the destination view controller as a DeckDetailViewController
            // let destination = segue.destinationViewController as! DeckDetailViewController
        }
        else {
            print("Nope")
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
        // Return NO if you do not want the item to be re-orderable.
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
