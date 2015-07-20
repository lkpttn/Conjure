//
//  Deck.swift
//  Conjure
//
//  Created by Luke Patton on 7/14/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class Deck {
    
    // MARK: Properties
    var deckName: String
    var wins = 0
    var losses = 0
    var newDeck = false
    
    // MARK: Initialization
    init(deckName: String) {
        self.deckName = deckName
    }
}
