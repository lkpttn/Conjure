//
//  GameDetailViewController.swift
//  Conjure
//
//  Created by Luke Patton on 7/16/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var turnTable: UITableView!
    @IBOutlet weak var deckNameLabel: UILabel!
    @IBOutlet weak var winLossLabel: UILabel!
    @IBOutlet weak var gamesSegmentControl: UISegmentedControl!
    @IBOutlet weak var notesTextView: UITextView!
    
    var series: Series!
    var gamenumber = 1
    
    // Colors
    let redColor = UIColor(red: 208/255.0, green: 2/255.0, blue: 27/255.0, alpha: 1)
    let greenColor = UIColor(red: 92/255.0, green: 176/255.0, blue: 0, alpha: 1)
    let lightBlueColor = UIColor(red: 8/255.0, green: 129/255.0, blue: 220/255.0, alpha: 1.0)
    let darkBlueColor = UIColor(red: 22/255.0, green: 48/255.0, blue: 63/255.0, alpha: 1)
    
    override func viewWillAppear(animated: Bool) {
        styleNavBar()
        notesTextView.text = series.notes ?? ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let series = series {
            deckNameLabel.text = series.deck.deckName
            winLossLabel.text = "\(series.wins)-\(series.losses)"
            notesTextView.text = series.notes ?? ""
            
            if series.tie == true {
                winLossLabel.text = "T \(series.wins)-\(series.losses)"
            }
            else if series.wins > series.losses {
                winLossLabel.text = "W \(series.wins)-\(series.losses)"
            }
            else if series.losses > series.wins {
                winLossLabel.text = "L \(series.wins)-\(series.losses)"
            }
        }
        
        turnTable.delegate = self
        turnTable.dataSource = self
        self.turnTable.reloadData()
        
        notesTextView.textContainer.lineFragmentPadding = 0;
        
        setupSegmentControl()
    }
    
    func styleNavBar() {
        let navBar = self.navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar?.shadowImage = UIImage()
        navBar?.translucent = true
        navBar!.barTintColor = UIColor.clearColor()
    }
    
    // MARK: Segment control
    func setupSegmentControl() {
        // Start the segment control fresh, add a segment for each game.
        var tableY: CGFloat = -315
        
        gamesSegmentControl.removeAllSegments()
        for game in series.games {
            var i = series.games.count
            gamesSegmentControl.insertSegmentWithTitle("Game \(game.gameNumber)", atIndex: i, animated: false)
            i -= 1
        }
        
        gamesSegmentControl.selectedSegmentIndex = 0
        gamesSegmentControl.addTarget(self, action: "changeGame:", forControlEvents: .ValueChanged)
        
        // If there's only one game, remove the segmented control.
        if gamesSegmentControl.numberOfSegments == 1 {
            tableY = -266
            gamesSegmentControl.removeFromSuperview()
        }
        
        let verticalContstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: turnTable, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: tableY)
        self.view.addConstraint(verticalContstraint)
    }

    
    // MARK: Table stuff
    // How many rows are in the table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return series.games[gamenumber-1].turns.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TurnCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TurnCell
        
        let turn = series.games[gamenumber-1].turns[indexPath.row]
        cell.playerOneChange.text = turn.turnPlayerOneChange
        cell.playerTwoChange.text = turn.turnPlayerTwoChange
        
        // Change the color based on the String prefix, + or - or 0
        let playerOneString = String(turn.turnPlayerOneChange)
        if playerOneString.hasPrefix("+") {
            cell.playerOneChange.textColor = greenColor
        }
        else {
            cell.playerOneChange.textColor = redColor
        }
        
        let playerTwoString = String(turn.turnPlayerTwoChange)
        if playerTwoString.hasPrefix("+") {
            cell.playerTwoChange.textColor = greenColor
        }
        else {
            cell.playerTwoChange.textColor = redColor
        }
        
        // Add cell elements
        cell.turnNumber.text = String(turn.turnNumber)
        cell.playerOneTurnLife.text = String(turn.turnPlayerOneLife)
        cell.playerTwoTurnLife.text = String(turn.turnPlayerTwoLife)
        cell.playerOneChange.text = playerOneString
        cell.playerTwoChange.text = playerTwoString
        
        return cell
    }
    
    // MARK: Actions
    @IBAction func changeGame(sender: UIButton) {
        let selectedSegment = gamesSegmentControl.selectedSegmentIndex
        switch selectedSegment {
        case 0:
            gamenumber = 1
        case 1:
            gamenumber = 2
        case 2:
            gamenumber = 3
        case 3:
            gamenumber = 4
        case 4:
            gamenumber = 5
        default:
            gamenumber = 1
        }
        
        turnTable.reloadData()
    }
    
    // MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController
        if segue.identifier == "matchNotes" {
            print("Moving to notes")
            let svc = segue.destinationViewController as! DeckNotesViewController
            svc.noteString = series?.notes ?? ""
            svc.parent = "matchDetail"
        }
        
    }
}
