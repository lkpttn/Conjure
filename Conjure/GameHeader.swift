//
//  GameHeader.swift
//  Conjure
//
//  Created by Luke Patton on 7/9/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class GameHeader: UIView {
    
    // MARK: Properties
    // This needs 4 pixels of x space to fit properly? Idk
    let topFrame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 236)
    var playerOneCounter = LifeCounter(frame: CGRect(x: 4, y: 50, width: (UIScreen.mainScreen().bounds.width/2), height: 200))
    var playerTwoCounter = LifeCounter(frame: CGRect(x: (UIScreen.mainScreen().bounds.width/2)+4, y: 50, width: (UIScreen.mainScreen().bounds.width)/2, height: 200))

    
    var seriesLabel = UILabel(frame: CGRectZero)
    let gameTimer = UILabel(frame: CGRectMake(20, 20, 150, 50))
    
    // MARK: Initlization
    required init() {
        super.init(frame: topFrame)

        setupSubviews()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    func setupSubviews() {
        let deviceWidth = UIScreen.mainScreen().bounds.width
        
        self.backgroundColor = UIColor(red: 22/255.0, green: 48/255.0, blue: 63/255.0, alpha: 1)
        
        // Line
        let midLine = UIView()
        midLine.backgroundColor = .whiteColor()
        print(UIScreen.mainScreen().bounds.width)
        midLine.frame = CGRect(x: (deviceWidth/2)+3.5, y: 70, width: 1, height: 144)
        addSubview(midLine)
        
        // Timer
        gameTimer.text = ""
        gameTimer.textColor = .whiteColor()
        gameTimer.font = UIFont(name: "SourceSansPro-Regular", size: 13)
        addSubview(gameTimer)
        
        
        // Counters
        addSubview(playerOneCounter)
        playerOneCounter.playerName.text = "ME"
        
        addSubview(playerTwoCounter)
        playerTwoCounter.playerName.text = "OPPONENT"
    }
    
    func addWinCircle(frame: CGRect) {
        let circle = winCircle(frame: frame)
        addSubview(circle)
    }
}
