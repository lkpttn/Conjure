//
//  ViewController.swift
//  Conjure
//
//  Created by Luke Patton on 7/6/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var gameHeader: GameHeader!
    @IBOutlet weak var turnTable: UITableView!
    @IBOutlet weak var gameButton: UIButton!
    
    // Setting up a fake series
    let testSeries = Series(numberOfGames: 5, timeLimit: 2500)
    var gamenumber = 0
    var turnNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // This does not update the view! all of this happens after the views are drawn.
        // If effects the variables, but doesn't kick off a draw cycle.
        
        // Start the first game
        startGame(gamenumber, series: testSeries)
        
        turnTable.delegate = self
        turnTable.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table stuff
    // How many rows are in the table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of turns in array: \(testSeries.games[gamenumber-1].turns.count)")
        return testSeries.games[gamenumber-1].turns.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TurnCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TurnCell
        print(indexPath)
        
        // Make a turn variable to store the indexPath
        // Each cell has a different index, so it's matching up cells with parts of the array
        
        // What is resetting the IndexPath when the lifecount hits 0?
        let turn = testSeries.games[gamenumber-1].turns[indexPath.row]
        
        cell.turnNumber.text = String(turn.turnNumber)
        cell.playerOneTurnLife.text = String(turn.turnPlayerOneLife)
        cell.playerTwoTurnLife.text = String(turn.turnPlayerTwoLife)
        
        return cell

    }
    
    
    // MARK: Game functions
    func startGame(vargamenumber: Int, series: Series) {
        gamenumber += 1
        
        // Create a new game instance with an increased base number
        let game = Game(baseLifeTotal: 20, gameNumber: gamenumber)
        
        // Add the new game into the game array in the series object
        series.games += [game]
        
        // Reset the gameHeader LifeCounters, back to the base life total.
        gameHeader.playerOneCounter.lifeTotal = game.baseLifeTotal
        gameHeader.playerOneCounter.counter.text = String(game.baseLifeTotal)
        
        gameHeader.playerTwoCounter.lifeTotal = game.baseLifeTotal
        gameHeader.playerTwoCounter.counter.text = String(game.baseLifeTotal)
        
        // Reset the turnTable
        self.turnTable.reloadData()
        
        // Programmatically remove all targets, change the button style and add back the turn.
        gameButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
        
        gameButton.setTitle("End Turn", forState: .Normal)
        gameButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        
        gameButton.addTarget(self, action: "nextTurn:", forControlEvents: .TouchDown)
        
        
    }
    
    func checkWinners() {
        let playerOne = gameHeader.playerOneCounter
        let playerTwo = gameHeader.playerTwoCounter
        
        self.turnTable.reloadData()
        
        if playerOne.lifeTotal == 0 {
            // The other player wins. Increment the losses, gamenumber 
            // and check to see if the series is over.
            print("Player Two wins")
            testSeries.losses += 1
            
            // Add the win circle
            doWinCirleLogic(testSeries.wins, losses: testSeries.losses)
            
            // Increment the gamenumber
            // gamenumber += 1
            
            // Check to see if the series is over.
            checkSeries()
        }
        else if playerTwo.lifeTotal == 0 {
            // The player wins. Increment the wins, gamenumber
            // and check to see if the series is over.
            print("Player One wins")
            testSeries.wins += 1
            
            // Add the win circle
            doWinCirleLogic(testSeries.wins, losses: testSeries.losses)
            
            // gamenumber += 1
            
            checkSeries()
        }
        else {
        }
    }
    
    
    func checkSeries() {
        // This code can be way better.
        
        if testSeries.wins == testSeries.winConditon {
            // End series and cleanup
            print("Player One wins")
            print("\(testSeries.wins)-\(testSeries.losses)")
            
            // Set button to say "Start next series". Needs a state change
            
            print(testSeries.games)
        }
        else if testSeries.losses == testSeries.winConditon {
            // End series and cleanup
            print("Player Two wins")
            print("\(testSeries.wins)-\(testSeries.losses)")
            print(testSeries.games)
        }
        else {
            // Change the button
            gameButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            
            gameButton.setTitle("Next Game", forState: .Normal)
            gameButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            
            gameButton.addTarget(self, action: "nextGame:", forControlEvents: .TouchDown)

        }
    }
    
    
    func doWinCirleLogic(wins: Int, losses: Int) {
        var circleFrame = CGRectZero
        let circleWidth = 9
        
        // Need to add cases for best of five, seven
        // Lots of weird logic bugginess
        if losses == 1  && wins == 1 || losses == 1 && wins == 0 {
            circleFrame = CGRect(x: 220, y: 30, width: circleWidth, height: circleWidth)
        }
        else if losses == 2 {
            circleFrame = CGRect(x: 240, y: 30, width: circleWidth, height: circleWidth)
        }
        else if wins == 1 {
            circleFrame = CGRect(x: 150, y: 30, width: circleWidth, height: circleWidth)
        }
        else if wins == 2 {
            circleFrame = CGRect(x: 130, y: 30, width: circleWidth, height: circleWidth)
        }
        
        gameHeader.addWinCircle(circleFrame)
    }
    
    
    // MARK: Button things
    func nextTurn(sender: UIButton!) {
        // These actions do create new draw cycles
        let playerOneLife = gameHeader.playerOneCounter.lifeTotal
        let playerTwoLife = gameHeader.playerTwoCounter.lifeTotal
        
        // Create a new turn, add the turn number and save life totals
        let turn = Turn(turnNumber: turnNumber, turnPlayerOneLife: playerOneLife, turnPlayerTwoLife: playerTwoLife)
        
        // Add the new turn into the Turn array of the current game
        testSeries.games[gamenumber-1].turns += [turn]
        print("Just commited game \(gamenumber), turn \(turn.turnNumber)")
        
        
        // Did anyone win?
        checkWinners()
        
        // Increment the turn number
        turnNumber += 1
    }
    
    func nextGame(sender: UIButton!) {
        // Create a new game instance and set turn number to 1
        startGame(gamenumber, series: testSeries)
        turnNumber = 1
    }
    
    
} // END

