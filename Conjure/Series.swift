//
//  Series.swift
//  Conjure
//
//  Created by Luke Patton on 7/9/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class Series: NSObject, NSCoding {
    
    // MARK: Properties
    var date = NSDate()
    var numberOfGames: Int
    // var timeLimit: Double
    var winConditon: Int
    var wins = 0
    var losses = 0
    var games = [Game]()
    var deck = Deck(deckName: "No deck selected")
    
    // MARK: Archiving Paths
    // This chooses where we will save Series data in the filesystem
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("series")
    
    init(deck: Deck, numberOfGames: Int) {
        // self.deck = deck
        self.numberOfGames = numberOfGames
        self.deck = deck
        
        // Logic block fo determining how many games you need to win
        switch numberOfGames {
        case 1:
            winConditon = 1
        case 3:
            winConditon = 2
        case 5:
            winConditon = 3
        case 7:
            winConditon = 5
        default:
            winConditon = 1
        }
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(games, forKey: "games")
        aCoder.encodeObject(deck, forKey: "deck")
        aCoder.encodeInteger(wins, forKey: "wins")
        aCoder.encodeInteger(losses, forKey: "losses")
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeInteger(numberOfGames, forKey: "numberOfGames")
        // aCoder.encodeDouble(timeLimit, forKey: "timeLimit")
    }
    
    // This initializer must be initialized on all subclasses
    // Convenience denotes this as a secondary initializer
    // ? marks it as a method that might fail.
    // This runs code if it initialized with objects to decode
    required convenience init?(coder aDecoder: NSCoder) {
        let games = aDecoder.decodeObjectForKey("games") as! NSArray
        let deck = aDecoder.decodeObjectForKey("deck") as! Deck
        // let deck = Deck(deckName: "Not saved deck")
        let wins = aDecoder.decodeIntegerForKey("wins")
        let losses = aDecoder.decodeIntegerForKey("losses")
        let numberOfGames = aDecoder.decodeIntegerForKey("numberOfGames")
        let date = aDecoder.decodeObjectForKey("date") as! NSDate
        // let timeLimit = aDecoder.decodeDoubleForKey("timeLimit")
        
        
        self.init(deck: deck, numberOfGames: numberOfGames)
        self.wins = wins
        self.losses = losses
        self.games = games as! [Game]
        self.date = date
    }

} // END
