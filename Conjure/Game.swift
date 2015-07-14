//
//  Game.swift
//  Conjure
//
//  Created by Luke Patton on 7/9/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class Game {
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
    
} // END

class Turn {
    // Mark: Turn properties
    var turnNumber: Int
    var turnPlayerOneLife: Int
    var turnPlayerTwoLife: Int
    
    var turnPlayerOneChange = ""
    var turnPlayerTwoChange = ""
    
    init(turnNumber: Int, turnPlayerOneLife: Int, turnPlayerTwoLife: Int) {
        self.turnNumber = turnNumber
        self.turnPlayerOneLife = turnPlayerOneLife
        self.turnPlayerTwoLife = turnPlayerTwoLife
    }
} // END