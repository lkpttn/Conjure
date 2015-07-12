//
//  Series.swift
//  Conjure
//
//  Created by Luke Patton on 7/9/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class Series {
    // MARK: Properties
    let date = NSDate()
    // let deck: Deck?
    let numberOfGames: Int
    let timeLimit: Int
    var winConditon: Int
    var wins = 0
    var losses = 0
    var games = [Game]()
    
    // Small variables
    var gameNumber = 1
    
    init(/* deck: Deck?, */ numberOfGames: Int, timeLimit: Int) {
        self.numberOfGames = numberOfGames
        self.timeLimit = timeLimit
        
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
    
} // END
