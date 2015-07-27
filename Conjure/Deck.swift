//
//  Deck.swift
//  Conjure
//
//  Created by Luke Patton on 7/14/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class Deck: NSObject, NSCoding {
    
    // MARK: Properties
    var deckName: String
    var wins = 0
    var losses = 0
    var newDeck = false
    
    // MARK: Archiving Paths
    // This chooses where we will save Series data in the filesystem
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("decks")

    
    // MARK: Initialization
    init(deckName: String) {
        self.deckName = deckName
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(deckName, forKey: "deckName")
        aCoder.encodeInteger(wins, forKey: "wins")
        aCoder.encodeInteger(losses, forKey: "losses")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let deckName = aDecoder.decodeObjectForKey("deckName") as? String
        let wins = aDecoder.decodeIntegerForKey("wins")
        let losses = aDecoder.decodeIntegerForKey("losses")
        
        self.init(deckName: deckName!)
        self.wins = wins
        self.losses = losses
    }
}
