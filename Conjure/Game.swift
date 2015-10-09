//
//  Game.swift
//  Conjure
//
//  Created by Luke Patton on 7/9/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class Game: NSObject, NSCoding {
    // MARK: Properties
    var baseLifeTotal: Int
    var gameNumber: Int
    var turns = [Turn]()
    var playerOneLife: Int
    var playerTwoLife: Int
    
    
    // MARK: Initialization
    init(baseLifeTotal: Int, gameNumber: Int) {
        self.baseLifeTotal = baseLifeTotal
        self.gameNumber = gameNumber
        
        playerOneLife = baseLifeTotal
        playerTwoLife = baseLifeTotal
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(baseLifeTotal, forKey: "baseLifeTotal")
        aCoder.encodeInteger(gameNumber, forKey: "gameNumber")
        aCoder.encodeObject(turns, forKey: "turns")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let baseLifeTotal = aDecoder.decodeIntegerForKey("baseLifeTotal")
        let gameNumber = aDecoder.decodeIntegerForKey("gameNumber")
        let turns = aDecoder.decodeObjectForKey("turns") as? NSArray
        
        self.init(baseLifeTotal: baseLifeTotal, gameNumber: gameNumber)
        self.playerOneLife = baseLifeTotal
        self.playerTwoLife = baseLifeTotal
        // Need to delete the older game before I can start up again
        self.turns = turns as! [Turn]
    }
    
} // END

class Turn: NSObject, NSCoding {
    // Mark: Turn properties
    var turnNumber: Int
    var turnPlayerOneLife: Int
    var turnPlayerTwoLife: Int
    
    var turnPlayerOneChange: String
    var turnPlayerTwoChange: String
    
    init(turnNumber: Int, turnPlayerOneLife: Int, turnPlayerTwoLife: Int, turnPlayerOneChange: String, turnPlayerTwoChange: String) {
        self.turnNumber = turnNumber
        self.turnPlayerOneLife = turnPlayerOneLife
        self.turnPlayerTwoLife = turnPlayerTwoLife
        self.turnPlayerOneChange = turnPlayerOneChange
        self.turnPlayerTwoChange = turnPlayerTwoChange
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(turnNumber, forKey: "turnNumber")
        aCoder.encodeInteger(turnPlayerOneLife, forKey: "turnPlayerOneLife")
        aCoder.encodeInteger(turnPlayerTwoLife, forKey: "turnPlayerTwoLife")
        aCoder.encodeObject(turnPlayerOneChange, forKey: "turnPlayerOneChange")
        aCoder.encodeObject(turnPlayerTwoChange, forKey: "turnPlayerTwoChange")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let turnNumber = aDecoder.decodeIntegerForKey("turnNumber")
        let turnPlayerOneLife = aDecoder.decodeIntegerForKey("turnPlayerOneLife")
        let turnPlayerTwoLife = aDecoder.decodeIntegerForKey("turnPlayerTwoLife")
        let turnPlayerOneChange = aDecoder.decodeObjectForKey("turnPlayerOneChange") as! String
        let turnPlayerTwoChange = aDecoder.decodeObjectForKey("turnPlayerTwoChange") as! String
        
        self.init(turnNumber: turnNumber, turnPlayerOneLife: turnPlayerOneLife, turnPlayerTwoLife: turnPlayerTwoLife, turnPlayerOneChange: turnPlayerOneChange, turnPlayerTwoChange: turnPlayerTwoChange)
    }
} // END