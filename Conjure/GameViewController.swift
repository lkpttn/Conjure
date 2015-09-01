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
    
    let settings = NSUserDefaults.standardUserDefaults()
    
    var series: Series!
    var timeLimit: Double!
    var gamenumber = 0
    var turnNumber = 0
    var rows = 0
    
    // Timers
    var matchTimer = NSTimer()
    let timeInterval:NSTimeInterval = 1.0 //smaller interval
    var timeCount:NSTimeInterval = 0 // counter for the timer

    
    // Colors
    let redColor = UIColor(red: 208/255.0, green: 2/255.0, blue: 27/255.0, alpha: 1)
    let greenColor = UIColor(red: 92/255.0, green: 176/255.0, blue: 0, alpha: 1)
    let lightBlueColor = UIColor(red: 8/255.0, green: 129/255.0, blue: 220/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // This does not update the view! all of this happens after the views are drawn.
        // If effects the variables, but doesn't kick off a draw cycle.
        
        // Keep the phone from going to sleep
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        // Start the first game
        startGame(gamenumber, series: series)
        
        turnTable.delegate = self
        turnTable.dataSource = self
        
        setupTimers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTimers() {
        // Timers
        timeCount = timeLimit // counter for the timer

        // Start the timer
        if !matchTimer.valid {
            gameHeader.gameTimer.text = timeString(timeCount)
            matchTimer = NSTimer.scheduledTimerWithTimeInterval(
                timeInterval,
                target: self,
                selector: "matchTimeUp:",
                userInfo: nil,
                repeats: true)
        }
    }
    
    func matchTimeUp(matchTimer:NSTimer){
        timeCount = timeCount - timeInterval
        let timerLabel = gameHeader.gameTimer
        
        if timeCount <= 0 {  //test for target time reached.
            timerLabel.text = "Time expired"
            matchTimer.invalidate()
        } else { //update the time on the clock if not reached
            timerLabel.text = timeString(timeCount)
        }
    }
    
    func timeString(time:NSTimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i",minutes,seconds)
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
    
    
    // MARK: Game functions
    func startGame(vargamenumber: Int, series: Series) {
        // Set the series label
        changeSeriesLabel(series.numberOfGames)
        
        gamenumber += 1
        print("Starting game number \(gamenumber)")
        
        // Create a new game instance with an increased base number
        let game = Game(baseLifeTotal: settings.integerForKey("lifeTotal"), gameNumber: gamenumber)
        
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
        gameButton.backgroundColor = lightBlueColor
        
        gameButton.addTarget(self, action: "nextTurn:", forControlEvents: .TouchDown)
        
        
    }
    
    func checkWinners() {
        let playerOne = gameHeader.playerOneCounter
        let playerTwo = gameHeader.playerTwoCounter
        
        self.turnTable.reloadData()
        
        let indexPath = NSIndexPath(forItem: turnNumber-1, inSection: 0)
        turnTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        
        if playerOne.lifeTotal == 0 {
            // The other player wins. Increment the losses, gamenumber 
            // and check to see if the series is over.
            print("Player Two wins")
            series.losses += 1
            
            // Add the win circle
            doWinCirleLogic(series.wins, losses: series.losses)
            
            // Check to see if the series is over.
            checkSeries()
        }
        else if playerTwo.lifeTotal == 0 {
            // The player wins. Increment the wins, gamenumber
            // and check to see if the series is over.
            print("Player One wins")
            series.wins += 1
            
            // Add the win circle
            doWinCirleLogic(series.wins, losses: series.losses)
            
            checkSeries()
        }
        else {
        }
    }
    
    
    func checkSeries() {
        // This code can be way better.
        
        if series.wins == series.winConditon || series.losses == series.winConditon {
            // End series and cleanup
            print("\(series.wins)-\(series.losses)")
            
            gameButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            
            gameButton.setTitle("End Series", forState: .Normal)
            gameButton.backgroundColor = greenColor
            gameButton.addTarget(self, action: "endSeries:", forControlEvents: .TouchDown)
        }
        else {
            // Change the button
            gameButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            
            gameButton.setTitle("Next Game", forState: .Normal)
            gameButton.backgroundColor = redColor
            gameButton.addTarget(self, action: "nextGame:", forControlEvents: .TouchDown)
        }
    }
    
    
    func doWinCirleLogic(wins: Int, losses: Int) {
        var circleFrame = CGRectZero
        let circleWidth = 8
        let circleY = 42
        let circleX = Int(UIScreen.mainScreen().bounds.width/2)
        
        // Need to add cases for best of five, seven
        // Lots of weird logic bugginess
        if losses == 1 && wins == 0 {
            circleFrame = CGRect(x: circleX+30, y: circleY, width: circleWidth, height: circleWidth)
        }
        else if losses == 2 {
            circleFrame = CGRect(x: circleX+45, y: circleY, width: circleWidth, height: circleWidth)
        }
        else if wins == 1 {
            circleFrame = CGRect(x: circleX-30, y: circleY, width: circleWidth, height: circleWidth)
        }
        else if wins == 2 {
            circleFrame = CGRect(x: circleX-45, y: circleY, width: circleWidth, height: circleWidth)
        }
        
        gameHeader.addWinCircle(circleFrame)
    }
    
    func changeSeriesLabel(numberofgames: Int) {
        switch numberofgames {
        case 1:
            gameHeader.seriesLabel.text = "Single"
        case 3:
            gameHeader.seriesLabel.text = "Bo3"
        case 5:
            gameHeader.seriesLabel.text = "Bo5"
        default:
            gameHeader.seriesLabel.text = "Casual"
        }
    }
    
    // Can these be consolidated into one function?
    func calcPlayerOneChange(turn: Turn) -> String {
        var lastTurnPlayerOneLife = 20
        
        if turnNumber == 1 {
            lastTurnPlayerOneLife = 20
        }
        else {
            // Turn number is ahead of the index, so to get last turn, we need -2 instead of -1
            lastTurnPlayerOneLife = series.games[gamenumber-1].turns[turnNumber-2].turnPlayerOneLife
        }
        
        let turnPlayerOneLife = turn.turnPlayerOneLife
        let playerOneChange = (lastTurnPlayerOneLife - turnPlayerOneLife) * -1
        turn.turnPlayerOneChange = String(playerOneChange)
        
        if playerOneChange == 0 {
            return ""
        }
        else if playerOneChange >= 1 {
            return "+\(playerOneChange)"
        } else {
            return String(playerOneChange)
        }

    }
    
    func calcPlayerTwoChange(turn: Turn) -> String {
        var lastTurnPlayerTwoLife = 20
        
        if turnNumber == 1 {
            lastTurnPlayerTwoLife = 20
        }
        else {
            // Turn number is ahead of the index, so to get last turn, we need -2 instead of -1
            lastTurnPlayerTwoLife = series.games[gamenumber-1].turns[turnNumber-2].turnPlayerTwoLife
        }
    
        let turnPlayerTwoLife = turn.turnPlayerTwoLife
        let playerTwoChange = (lastTurnPlayerTwoLife - turnPlayerTwoLife) * -1
        turn.turnPlayerTwoChange = String(playerTwoChange)
        
        if playerTwoChange == 0 {
            return ""
        }
        else if playerTwoChange <= -1{
            return String(playerTwoChange)
        }
        else if playerTwoChange >= 1 {
            return "+\(playerTwoChange)"
        } else {
            return String(playerTwoChange)
        }
    }

    
    // MARK: Button things
    func nextTurn(sender: UIButton!) {
        // Increment the turn number
        turnNumber += 1
        
        // These actions do create new draw cycles
        let playerOneLife = gameHeader.playerOneCounter.lifeTotal
        let playerTwoLife = gameHeader.playerTwoCounter.lifeTotal
        
        // Create a new turn, add the turn number and save life totals
        let turn = Turn(turnNumber: turnNumber, turnPlayerOneLife: playerOneLife, turnPlayerTwoLife: playerTwoLife)
        
        // Add the new turn into the Turn array of the current game
        series.games[gamenumber-1].turns += [turn]
        print("Just commited game \(gamenumber), turn \(turn.turnNumber)")
        
        // Calculate turn change
        turn.turnPlayerOneChange = calcPlayerOneChange(turn)
        turn.turnPlayerTwoChange = calcPlayerTwoChange(turn)
        
        // Did anyone win?
        checkWinners()
    }
    
    func nextGame(sender: UIButton!) {
        // Create a new game instance and set turn number to 1
        startGame(gamenumber, series: series)
        turnNumber = 0
        rows = 0
    }
    
    func endSeries(sender: UIButton!) {
        // Programmatically preform the segue specified in LeadViewController
        self.performSegueWithIdentifier("unwindToLeadView", sender: self)
    }
    
    // MARK: Reset
    @IBAction func resetButton(sender: UIButton) {
        series.games.removeLast()
        gamenumber -= 1
        turnNumber = 0
        startGame(gamenumber, series: series)
    }
    
} // END

