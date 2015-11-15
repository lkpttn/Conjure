//
//  DeckViewController.swift
//  Conjure
//
//  Created by Luke Patton on 7/31/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class DeckViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var deckTable: UITableView!
    
    var settings = NSUserDefaults.standardUserDefaults()
    var bannerView: UIView?
    var purchased = false
    
    var deckDictionary = [String: Deck]()
    var deckArray = [Deck]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.styleNavBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        purchased = settings.boolForKey("didPurchase")

        // Turn the deckDictionary into a deckarray
        for (deckName, deck) in deckDictionary {
            print(deckName)
            deckArray.append(deck)
        }
        
        if purchased == false {
            // Add banner, limit decks
            print("Buy the app!")
        }
        
        deckTable.delegate = self
        deckTable.dataSource = self
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deckArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SeriesCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SeriesCell
        // Configure the cell...
        let deck = deckArray[indexPath.row]
        cell.deckNameLabel.text = String(deck.deckName)
        cell.winLossLabel.text = "\(deck.wins)-\(deck.losses)-\(deck.ties)"
        
        return cell
    }
   
    // Other functions
    func styleNavBar() {
        let navBar = self.navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar?.shadowImage = UIImage()
        navBar?.translucent = true
        navBar!.barTintColor = UIColor.clearColor()
    }
    
    // MARK: Button actions
    @IBAction func newDeckButton(sender: UIButton) {
        if purchased == false && deckArray.count == 1 {
            let alert = UIAlertController(title: "Only one deck is allowed in the free version", message: "Please purchase the full version for unlimited deck tracking.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Maybe I Will!", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            performSegueWithIdentifier("addNewDeck", sender: self)
        }

    }
    
    
    // MARK: Segue actions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDeckDetail" {
            // Downcasting the destination view controller as a DeckDetailViewController
            let destination = segue.destinationViewController as! DeckDetailViewController
            
            // Get the cell that generated the segue
            if let selectedSeriesCell = sender as? SeriesCell {
                // Find the index path for the cell that sent the segue
                let indexPath = deckTable.indexPathForCell(selectedSeriesCell)!
                // selected series is set to the series at that indexPath
                let selectedDeck = deckArray[indexPath.row]
                print(selectedDeck.deckName)
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
        if let selectedIndexPath = deckTable.indexPathForSelectedRow {
            // Delete from dictionary and array
            deckDictionary.removeValueForKey((source?.deck?.deckName)!)
            deckArray.removeAtIndex(selectedIndexPath.row)
            deckTable.deleteRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .Fade)
        }
    }

}
