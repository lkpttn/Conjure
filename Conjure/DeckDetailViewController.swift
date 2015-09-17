//
//  DeckDetailViewController.swift
//  Conjure
//
//  Created by Luke Patton on 7/18/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class DeckDetailViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var deckNameField: UITextField!
    @IBOutlet weak var deckSelectButton: UIButton!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var winPercentageLabel: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    
    var deck: Deck?
    var deckDictionary = [String: Deck]()
    var oldDeckName = ""
    
    override func viewWillAppear(animated: Bool) {
        styleNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deckNameField.delegate = self

        if let deck = deck {
            // If there is a deck passed to the ViewController, assign the variables.
            oldDeckName = deck.deckName
            deckNameField.text = deck.deckName
            winsLabel.text = String(deck.wins)
            lossesLabel.text = String(deck.losses)
            
            if deck.wins != 0 && deck.losses != 0 {
                let games:Float = Float(deck.wins) + Float(deck.losses)
                let winPercent:Float = roundf((Float(deck.wins)/games)*100)
                let winInt = Int(winPercent)
                winPercentageLabel.text = "\(winInt)%"
            }
        }
        else {
            self.deck = Deck(deckName: "No deck name")
            deck!.newDeck = true
            deckNameField.becomeFirstResponder()
        }
        
        checkValidName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard when user hits Return
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        deckSelectButton.enabled = false
    }
    
    func checkValidName() {
        // Disable save if the meal name is empty
        let text = deckNameField.text ?? ""
        deckSelectButton.enabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidName()
        deck!.deckName = deckNameField.text!
        
        // Change the deckDictionary key for this deck, it will be different than the deckName
        deckDictionary[(deck?.deckName)!] = deckDictionary[oldDeckName]
        deckDictionary.removeValueForKey(oldDeckName)
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
    
    // MARK: Button actions
    @IBAction func deckSelection(sender: UIButton) {
        if deck?.newDeck == true {
            deckDictionary[(deck?.deckName)!] = deck
        }
        self.performSegueWithIdentifier("unwindToLeadView", sender: self)
    }
    
    @IBAction func deckDelete(sender: UIButton) {
        self.performSegueWithIdentifier("unwindToDeckTableView", sender: self)
    }
}
