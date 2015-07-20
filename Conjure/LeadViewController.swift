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
    @IBOutlet weak var pickerLabel: UILabel!
    @IBOutlet weak var pickerButton: UIButton!
    @IBOutlet weak var deckLabel: UILabel!
    
    // a variable that is a empty array of Meal objects
    var seriesArray = [Series]()
    var deckArray = [Deck]()
    
    var currentDeck: Deck?
    var numberOfGames = 1
    
    // test
    var optionsPicker: UIPickerView!
    var testOptions = [1,3,5,7]
    
    
    // MARK: Initialization
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        optionsPicker = UIPickerView()
        
        optionsPicker.dataSource = self
        optionsPicker.delegate = self
        
        numberOfGamesField.inputView = optionsPicker
        numberOfGamesField.text = String(testOptions[0])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startSeries" {
            print("Starting a new series")
            // Downcasting the destination view controller as a MealViewController
            let svc = segue.destinationViewController as! GameViewController
            
            // Set up the series to be passed to the GameViewController
            svc.series = Series(deck: currentDeck!, numberOfGames: numberOfGames, timeLimit: 2500)
        }
        else if segue.identifier == "showHistory" {
            // topViewController lets us get data from the top view controller in the stack, which now is LeadViewController
            let nav = segue.destinationViewController as! UINavigationController
            let destination = nav.topViewController as! HistoryTableViewController
            destination.seriesArray = seriesArray
        }
        else if segue.identifier == "showDecks" {
            // topViewController lets us get data from the top view controller in the stack, which now is LeadViewController
            let nav = segue.destinationViewController as! UINavigationController
            let destination = nav.topViewController as! DeckTableViewController
            destination.deckArray = deckArray
        }

        else {
            print("Nope")
        }
    }
    
    // MARK: PickerView stuff
    // Number of options
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // The options array determines how many elements are in the picker
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return testOptions.count
    }
    
    // idk
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(testOptions[row])
    }
    
    // set the string to reflect the choice
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        numberOfGamesField.text = String(testOptions[row])
        numberOfGames = testOptions[row]
        self.view.endEditing(true)
    }
    
    // MARK: Unwind actions
    @IBAction func unwindToLeadView(sender: UIStoryboardSegue) {
        // If the sourceViewController was GameViewController, add the new series into the array.
        if let source = sender.sourceViewController as? GameViewController, series = source.series {
            // Do stuff with the new series here. Save maybe?
            seriesArray.insert(series, atIndex: 0)
            print(seriesArray.count)
        }
        if let source = sender.sourceViewController as? DeckDetailViewController, deck = source.deck {
            // Do stuff with the new series here. Save maybe?
            self.currentDeck = deck
            deckLabel.text = deck.deckName
            
            if deck.newDeck == true {
                deckArray.insert(deck, atIndex: 0)
                deck.newDeck = false
            }
        }
    }

} // END
