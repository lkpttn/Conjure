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

    @IBOutlet weak var headerView: UIView!
    
    var series: Series!
    var gamenumber = 1
    
    override func viewWillAppear(animated: Bool) {
        styleNavBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let series = series {
            deckNameLabel.text = series.deck.deckName
            winLossLabel.text = "\(series.wins)-\(series.losses)"
        }
        
        turnTable.delegate = self
        turnTable.dataSource = self
        self.turnTable.reloadData()
        
        setupSegmentControl()
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
    
    // MARK: Segment control
    func setupSegmentControl() {
        // Start the segment control fresh, add a segment for each game.
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
            gamesSegmentControl.removeFromSuperview()
        }
    }

    
    // MARK: Table stuff
    // How many rows are in the table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return series.games[gamenumber-1].turns.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TurnCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TurnCell
        
        // Make a turn variable to store the indexPath
        // Each cell has a different index, so it's matching up cells with parts of the array
        
        // What is resetting the IndexPath when the lifecount hits 0?
        // It was execiuting all the game code before reseting the table.
        // This means it was looking for turns in the new game instead of at the end of the current game.
        let turn = series.games[gamenumber-1].turns[indexPath.row]
        print(turn.turnPlayerOneChange)
        cell.playerOneChange.text = turn.turnPlayerOneChange
        cell.playerTwoChange.text = turn.turnPlayerTwoChange
        
        // Change the color based on the String prefix, + or - or 0
        let playerOneString = String(turn.turnPlayerOneChange)
        if playerOneString.hasPrefix("+") {
            cell.playerOneChange.textColor = UIColor.greenColor()
        }
        else {
            cell.playerOneChange.textColor = UIColor.redColor()
        }
        
        let playerTwoString = String(turn.turnPlayerTwoChange)
        if playerTwoString.hasPrefix("+") {
            cell.playerTwoChange.textColor = UIColor.greenColor()
        }
        else {
            cell.playerTwoChange.textColor = UIColor.redColor()
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
        case 5:
            gamenumber = 6
        case 6:
            gamenumber = 7
        default:
            gamenumber = 1
        }
        
        turnTable.reloadData()
    }
}
