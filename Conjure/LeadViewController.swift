//
//  LeadViewController.swift
//  Conjure
//
//  Created by Luke Patton on 7/12/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class LeadViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var gameHeader: GameHeader!
    
    @IBOutlet weak var numberOfGamesField: UITextField!
    @IBOutlet weak var numberOfGamesButton: UIButton!
    
    @IBOutlet weak var timeLimitButton: UIButton!
    @IBOutlet weak var timeLimitTextField: UITextField!
    
    @IBOutlet weak var deckLabel: UILabel!
    @IBOutlet weak var deckWinLossLabel: UILabel!
    
    @IBOutlet weak var startSeriesButton: UIButton!
    
    @IBOutlet weak var deckNameHistoryLabel: UILabel!
    @IBOutlet weak var deckRecordHistoryLabel: UILabel!
    
    
    var seriesArray = [Series]()
    var deckDictionary = [String: Deck]()
    
    var currentDeck: Deck?
    var numberOfGames = 3
    var timeLimit: Double = 3000.0
    var lifeTotal = 20
    
    let redColor = UIColor(red: 208/255.0, green: 2/255.0, blue: 27/255.0, alpha: 1)
    let greenColor = UIColor(red: 92/255.0, green: 176/255.0, blue: 0, alpha: 1)
    
    // Picker Lists
    var activeTextField: UITextField?
    var numberOfGamesPicker: UIPickerView!
    var numberofGamesOptions = [1,3,5]
    var timeLimitPicker: UIPickerView!
    var timeLimitOptions = [600.0,1500.0,3000.0]
    
    var tempNumberOfGames = 0
    var tempTimeLimit = 0.0
    
    var gamesComponent = 0
    var timesComponent = 1
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: Initialization
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        // Allows the screen to fall asleep.
        UIApplication.sharedApplication().idleTimerDisabled = false
        
        let lightBlueColor = UIColor(red: 8/255.0, green: 129/255.0, blue: 220/255.0, alpha: 1.0)
        startSeriesButton.backgroundColor = lightBlueColor
        
        // Load saved series
        if let savedSeries = loadSeries() {
            seriesArray += savedSeries
        }
        else {
            print("No saved series!")
        }
        
        // Load saved decks
        if let savedDecks = loadDecks() {
            // For loop iteration?
            deckDictionary = savedDecks
            print(deckDictionary)
            
            // Load the most recent current deck from user defaults
            if let name = defaults.stringForKey("currentDeckString") {
                currentDeck = deckDictionary[name]
                deckLabel.text = currentDeck?.deckName
                deckWinLossLabel.text = "W: \(currentDeck!.wins)    L: \(currentDeck!.losses)"
            }
        }
        else {
            print("No saved decks!")
        }
        
        // Setup settings button
        gameHeader.settingsButton.addTarget(self, action: "showSettings:", forControlEvents: .TouchUpInside)
        
        setForSettings()
        changeLabels()
        setupPicker()
    }
    
    func changeLabels() {
        if seriesArray.isEmpty == false {
            let lastSeries = seriesArray[0]
            deckNameHistoryLabel.text = lastSeries.deck.deckName
            
            if lastSeries.wins > lastSeries.losses {
                deckRecordHistoryLabel.textColor = greenColor
                deckRecordHistoryLabel.text = "W \(lastSeries.wins)-\(lastSeries.losses)"
            }
            else if lastSeries.losses > lastSeries.wins {
                deckRecordHistoryLabel.textColor = redColor
                deckRecordHistoryLabel.text = "L \(lastSeries.wins)-\(lastSeries.losses)"
            }

        }
    }
    
    // MARK: PickerView stuff
    func setupPicker() {
        numberOfGamesPicker = UIPickerView()
        numberOfGamesPicker.backgroundColor = UIColor.whiteColor()
        
        numberOfGamesPicker.dataSource = self
        numberOfGamesPicker.delegate = self
        
        numberOfGamesField.inputView = numberOfGamesPicker
        numberOfGamesField.tintColor = .whiteColor()
        
        timeLimitPicker = UIPickerView()
        timeLimitPicker.backgroundColor = UIColor.whiteColor()
        
        timeLimitPicker.dataSource = self
        timeLimitPicker.delegate = self
        
        timeLimitTextField.inputView = timeLimitPicker
        timeLimitTextField.tintColor = .whiteColor()
        
        numberOfGamesPicker.tag = 0
        timeLimitPicker.tag = 1
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.blueColor()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker:")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelPicker:")
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        numberOfGamesField.inputAccessoryView = toolBar
        timeLimitTextField.inputAccessoryView = toolBar
    }
    
    func donePicker(sender: UIBarButtonItem) {
        if tempNumberOfGames != 0 {
            numberOfGames = tempNumberOfGames
            numberCase(numberOfGames)
            tempNumberOfGames = 0
        }
        if tempTimeLimit != 0.0 {
            timeLimit = tempTimeLimit
            timeCase(timeLimit)
            tempTimeLimit = 0.0
        }
        activeTextField?.resignFirstResponder()
    }
    
    func cancelPicker(sender: UIBarButtonItem) {
        tempTimeLimit = 0.0
        tempNumberOfGames = 0
        activeTextField?.resignFirstResponder()
    }
    
    @IBAction func numberOfGamesbutton(sender: UIButton) {
        numberOfGamesField.becomeFirstResponder()
        activeTextField = numberOfGamesField
    }
    
    @IBAction func timeLimitButton(sender: UIButton) {
        timeLimitTextField.becomeFirstResponder()
        activeTextField = timeLimitTextField
    }
    
    // Number of options
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // The options array determines how many elements are in the picker
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if (pickerView.tag == 0) {
            return numberofGamesOptions.count
        }
        else if (pickerView.tag == 1) {
            return timeLimitOptions.count
        }
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0) {
            var tempTitle = "Best of \(numberofGamesOptions[row])"
            if numberofGamesOptions[row] == 1 {
                tempTitle = "Single Game"
            }
            return tempTitle
        }
        else if (pickerView.tag == 1) {
            let tempTitle = "\(Int(timeLimitOptions[row]/60)) minutes"
            return tempTitle
        }
        
        return "Error"
    }
    
    // set the string to reflect the choice
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 0) {
            tempNumberOfGames = numberofGamesOptions[row]
        }
        else if (pickerView.tag == 1) {
            tempTimeLimit = timeLimitOptions[row]
        }
    }

    func numberCase(int: Int) {
        switch int {
        case 1:
            numberOfGamesField.text = "Single Game"
        case 3:
            numberOfGamesField.text = "Best of 3"
        case 5:
            numberOfGamesField.text = "Best of 5"
        default:
            numberOfGamesField.text = "Best of 3"
        }
    }
    
    func timeCase(double: Double) {
        switch double {
        case 600:
            timeLimitTextField.text = "10 Minutes"
        case 1500:
            timeLimitTextField.text = "25 Minutes"
        case 3000:
            timeLimitTextField.text = "50 Minutes"
        default:
            timeLimit = 3000
            timeLimitTextField.text = "50 Minutes"
        }

    }
    
    // MARK: Save and settings
    func saveSeries() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(seriesArray, toFile: Series.ArchiveURL.path!)
        print("Saved the series")
        if !isSuccessfulSave {
            print("Failure!")
        }
    }
    
    func loadSeries() -> [Series]? {
        // finds the object at the ArchivePath and attempts to downcast it as an array of Series
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Series.ArchiveURL.path!) as? [Series]
    }
    
    func saveDecks() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(deckDictionary, toFile: Deck.ArchiveURL.path!)
        print("Saved the decks")
        if !isSuccessfulSave {
            print("Failure!")
        }
    }
    
    func loadDecks() -> [String: Deck]? {
        // finds the object at the ArchivePath and attempts to downcast it as an array of Decks
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Deck.ArchiveURL.path!) as? [String: Deck]
    }
    
    func setForSettings() {
        // Player names
        print(defaults.stringForKey("playerOneName"))
        gameHeader.playerOneCounter.playerName.text = defaults.stringForKey("playerOneName") ?? "Me"
        gameHeader.playerTwoCounter.playerName.text = defaults.stringForKey("playerTwoName") ?? "Opponent"
        
        // Format defaults
        numberOfGames = defaults.integerForKey("numberOfGames")
        numberCase(numberOfGames)
        
        timeLimit = defaults.doubleForKey("timeLimit")
        timeCase(timeLimit)
        
        print(defaults.integerForKey("lifeTotal"))
        lifeTotal = defaults.integerForKey("lifeTotal")
        if lifeTotal == 0 {
            lifeTotal = 20
        }
        gameHeader.playerOneCounter.lifeTotal = lifeTotal
        gameHeader.playerTwoCounter.lifeTotal = lifeTotal
    }
    
    
    // MARK: Navigation
    func showSettings(sender:UIButton!) {
        print("Button tapped")
        self.performSegueWithIdentifier("showSettings", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startSeries" {
            print("Starting a new series")
            let svc = segue.destinationViewController as! GameViewController
            
            // Set up the series to be passed to the GameViewController
            if currentDeck != nil {
                svc.series = Series(deck: currentDeck!, numberOfGames: numberOfGames)
                svc.timeLimit = timeLimit
            }
            else {
                let alert = UIAlertController(title: "No Deck Selected", message: "You need to select a deck to record a match.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        else if segue.identifier == "showHistory" {
            // topViewController lets us get data from the top view controller in the stack, which now is LeadViewController
            let nav = segue.destinationViewController as! UINavigationController
            let destination = nav.topViewController as! HistoryViewController
            destination.seriesArray = seriesArray
        }
        else if segue.identifier == "showDecks" {
            // topViewController lets us get data from the top view controller in the stack, which now is LeadViewController
            let nav = segue.destinationViewController as! UINavigationController
            let destination = nav.topViewController as! DeckViewController
            destination.deckDictionary = deckDictionary
        }
        else if segue.identifier == "showSettings" {
            let nav = segue.destinationViewController as! UINavigationController
            let destination = nav.topViewController as! SettingsTableViewController
            
            destination.tempPlayerOneName = defaults.stringForKey("playerOneName") ?? "Me"
            destination.tempPlayerTwoName = defaults.stringForKey("playerTwoName") ?? "Opponent"
        }
        else {
            print("Nope")
        }
    }
    
    // MARK: Unwind actions
    @IBAction func unwindToLeadView(sender: UIStoryboardSegue) {
        // If the sourceViewController was GameViewController, add the new series into the array.
        if let source = sender.sourceViewController as? GameViewController, series = source.series {
            // Do stuff with the new series here. Save maybe?
            seriesArray.insert(series, atIndex: 0)
            saveSeries()
            
            // Edit the deck as well.
            if series.wins > series.losses {
                deckDictionary[currentDeck!.deckName]?.wins += 1
            }
            else if series.losses > series.wins {
                deckDictionary[currentDeck!.deckName]?.losses += 1
            }
            
            deckWinLossLabel.text = "W: \(deckDictionary[currentDeck!.deckName]!.wins)    L: \(deckDictionary[currentDeck!.deckName]!.losses)"
            
            saveDecks()
            changeLabels()
        }
        if let source = sender.sourceViewController as? HistoryViewController {
            seriesArray = source.seriesArray
            changeLabels()
            saveSeries()
        }
        if let source = sender.sourceViewController as? DeckDetailViewController, deck = source.deck {
            // Do stuff with the new series here. Save maybe?
            self.currentDeck = deck
            deckLabel.text = deck.deckName
            
            // Store the current deck string/name in user defaults
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(deck.deckName, forKey: "currentDeckString")
    
            deckWinLossLabel.text = "W: \(deck.wins)    L: \(deck.losses)"
            
            // Set the passed in deckDictionary to the lead view
            deckDictionary = source.deckDictionary
            saveDecks()
            
            if deck.newDeck == true {
                deck.newDeck = false
            }
        }
        if let source = sender.sourceViewController as? DeckViewController {
            // Set the passed in deckDictionary to the lead view
            deckDictionary = source.deckDictionary
            saveDecks()
            print(deckDictionary)
        }
        if let source = sender.sourceViewController as? SettingsTableViewController {
            print("Trigger unwindToLeadView")
            
            defaults.setObject(source.tempPlayerOneName, forKey: "playerOneName")
            defaults.setObject(source.tempPlayerTwoName, forKey: "playerTwoName")
            
            defaults.setInteger(source.tempLifeTotal, forKey: "lifeTotal")
            gameHeader.playerOneCounter.counter.text = String(defaults.integerForKey("lifeTotal"))
            gameHeader.playerTwoCounter.counter.text = String(defaults.integerForKey("lifeTotal"))
            
            defaults.setInteger(source.numberOfGames, forKey: "numberOfGames")
            
            defaults.setDouble(source.timeLimit, forKey: "timeLimit")

            
            setForSettings()
            gameHeader.playerOneCounter.playerName.text?.uppercaseString
            gameHeader.playerTwoCounter.playerName.text?.uppercaseString
        }
    }

} // END
