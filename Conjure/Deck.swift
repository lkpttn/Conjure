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
    var notes = ""
    var wins = 0
    var losses = 0
    var ties = 0
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
        aCoder.encodeObject(notes, forKey: "notes")
        aCoder.encodeInteger(wins, forKey: "wins")
        aCoder.encodeInteger(losses, forKey: "losses")
        aCoder.encodeInteger(ties, forKey: "ties")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let deckName = aDecoder.decodeObjectForKey("deckName") as? String
        let notes = aDecoder.decodeObjectForKey("notes") as? String ?? ""
        let wins = aDecoder.decodeIntegerForKey("wins")
        let losses = aDecoder.decodeIntegerForKey("losses")
        let ties = aDecoder.decodeIntegerForKey("ties")
        
        self.init(deckName: deckName!)
        self.notes = notes
        self.wins = wins
        self.losses = losses
        self.ties = ties
    }
}
