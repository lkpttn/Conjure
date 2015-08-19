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
    
    @IBOutlet weak var pickerLabel: UILabel!
    @IBOutlet weak var pickerButton: UIButton!
    
    @IBOutlet weak var deckLabel: UILabel!
    @IBOutlet weak var deckWinLossLabel: UILabel!
    
    @IBOutlet weak var startSeriesButton: UIButton!
    
    @IBOutlet weak var deckNameHistoryLabel: UILabel!
    @IBOutlet weak var deckRecordHistoryLabel: UILabel!
    
    
    var seriesArray = [Series]()
    var deckDictionary = [String: Deck]()
    
    var currentDeck: Deck?
    var numberOfGames = 1
    var timeLimit: Double = 0.0
    
    let redColor = UIColor(red: 208/255.0, green: 2/255.0, blue: 27/255.0, alpha: 1)
    let greenColor = UIColor(red: 92/255.0, green: 176/255.0, blue: 0, alpha: 1)
    
    // Picker Lists
    var numberOfGamesPicker: UIPickerView!
    var numberofGamesOptions = [1,3,5]
    
    var timeLimitPicker: UIPickerView!
    var timeLimitOptions = [600.0,1500.0,3000.0]
    
    var gamesComponent = 0
    var timesComponent = 1
    
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
            print("Series help!")
        }
        
        // Load saved decks
        if let savedDecks = loadDecks() {
            // For loop iteration?
            deckDictionary = savedDecks
        }
        else {
            print("Deck help!")
        }
        
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
        numberOfGamesPicker.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
        numberOfGamesPicker.dataSource = self
        numberOfGamesPicker.delegate = self
        
        numberOfGamesField.inputView = numberOfGamesPicker
        numberOfGamesField.text = "Single Game"
        numberOfGamesField.tintColor = .whiteColor()
        
        timeLimitPicker = UIPickerView()
        timeLimitPicker.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
        timeLimitPicker.dataSource = self
        timeLimitPicker.delegate = self
        
        timeLimitTextField.inputView = timeLimitPicker
        timeLimitTextField.text = "25 minutes"
        timeLimitTextField.tintColor = .whiteColor()
        
        numberOfGamesPicker.tag = 0
        timeLimitPicker.tag = 1
    }
    
    @IBAction func numberOfGamesbutton(sender: UIButton) {
        numberOfGamesField.becomeFirstResponder()
    }
    
    @IBAction func timeLimitButton(sender: UIButton) {
        timeLimitTextField.becomeFirstResponder()
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
            let tempTitle = "\(timeLimitOptions[row]/60) minutes"
            return tempTitle
        }
        
        return "Error"
    }
    
    // set the string to reflect the choice
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 0) {
            let tempNumber = numberofGamesOptions[row]
            
            switch tempNumber {
            case 1:
                numberOfGamesField.text = "Single Game"
            case 3:
                numberOfGamesField.text = "Best of 3"
            case 5:
                numberOfGamesField.text = "Best of 5"
            default:
                numberOfGamesField.text = "Single Game"
            }
            
            numberOfGames = numberofGamesOptions[row]
            self.view.endEditing(true)
        }
        else if (pickerView.tag == 1) {
            let tempNumber = timeLimitOptions[row]
            
            switch tempNumber {
            case 600:
                timeLimitTextField.text = "10 Minutes"
            case 1500:
                timeLimitTextField.text = "25 Minutes"
            case 3000:
                timeLimitTextField.text = "50 Minutes"
            default:
                timeLimitTextField.text = "50 Minutes"
            }
            
            timeLimit = timeLimitOptions[row]
            self.view.endEditing(true)
        }
        
    }
    
    // MARK: NSCoding
    // Save or load the series whenever there's an update
    func saveSeries() {
        // An archiver object that saves the meal array to the ArchivePath we defined in Series
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
        // An archiver object that saves the meal array to the ArchivePath we defined in Series
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
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startSeries" {
            print("Starting a new series")
            // Downcasting the destination view controller as a MealViewController
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
    }

} // END
