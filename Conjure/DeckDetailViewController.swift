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
    @IBOutlet weak var winPercentageLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    var deck: Deck?
    var deckDictionary = [String: Deck]()
    var oldDeckName = ""
    var noteString: String = ""
    
    override func viewWillAppear(animated: Bool) {
        styleNavBar()
        notesTextView.text = deck?.notes
        saveDecks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deckNameField.delegate = self

        if let deck = deck {
            // If there is a deck passed to the ViewController, assign the variables.
            oldDeckName = deck.deckName
            deckNameField.text = deck.deckName
            winsLabel.text = "\(deck.wins)-\(deck.losses)-\(deck.ties)"
            notesTextView.text = deck.notes
            notesTextView.textContainer.lineFragmentPadding = 0;
            
            if deck.wins != 0 || deck.losses != 0 {
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
        
        // Fix text inset
        notesTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
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
    
    func saveDecks() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(deckDictionary, toFile: Deck.ArchiveURL.path!)
        print("Saved the decks")
        if !isSuccessfulSave {
            print("Failure!")
        }
    }
    
    func styleNavBar() {
        let navBar = self.navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar?.shadowImage = UIImage()
        navBar?.translucent = true
        navBar!.barTintColor = UIColor.clearColor()
    }
    
    // MARK: Button actions
    @IBAction func deckSelection(sender: UIButton) {
        if deck?.newDeck == true {
            deckDictionary[(deck?.deckName)!] = deck
        }
        if deckNameField.isFirstResponder() == true {
            checkValidName()
            deckNameField.resignFirstResponder()
        }
        self.performSegueWithIdentifier("unwindToLeadView", sender: self)
    }
    
    @IBAction func deckDelete(sender: UIButton) {
        self.performSegueWithIdentifier("unwindToDeckTableView", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController
        if segue.identifier == "deckNotes" {
            print("Moving to notes")
            let svc = segue.destinationViewController as! NotesViewController
            svc.noteString = deck?.notes ?? ""
            svc.parent = "deckDetail"
        }

    }
}
