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
    
    var deck: Deck?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deckNameField.delegate = self

        if let deck = deck {
            // If there is a deck passed to the ViewController, assign the variables.
            deckNameField.text = deck.deckName
            winsLabel.text = String(deck.wins)
            lossesLabel.text = String(deck.losses)
            
            // Fix the division
            let winPercent = (deck.wins/deck.losses)*100
            winPercentageLabel.text = String(winPercent)
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
    }
    
    // MARK: Button actions
    @IBAction func deckSelection(sender: UIButton) {
        self.performSegueWithIdentifier("unwindToLeadView", sender: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
