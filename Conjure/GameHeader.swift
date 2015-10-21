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

    
    let seriesLabel = UILabel(frame: CGRectMake(4, 21, UIScreen.mainScreen().bounds.width, 40))
    let gameTimer = UILabel(frame: CGRectMake(20, 21, 150, 40))
    let settingsButton = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width-80, 26, 70, 30))
    
    // MARK: Initlization
    required init() {
        super.init(frame: topFrame)

        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    func setupSubviews() {
        let deviceWidth = UIScreen.mainScreen().bounds.width
        
        self.backgroundColor = UIColor(red: 22/255.0, green: 48/255.0, blue: 63/255.0, alpha: 1)
        
        // Line
        let midLine = UIView()
        midLine.backgroundColor = .whiteColor()
        midLine.frame = CGRect(x: (deviceWidth/2)+3.5, y: 70, width: 1, height: 144)
        addSubview(midLine)
        
        // Timer
        gameTimer.text = "--:--"
        gameTimer.textColor = .whiteColor()
        gameTimer.font = UIFont(name: "SourceSansPro-Regular", size: 13)
        addSubview(gameTimer)
        
        // Series Label
        seriesLabel.textAlignment = .Center
        seriesLabel.text = "Casual"
        seriesLabel.textColor = .whiteColor()
        seriesLabel.font = UIFont(name: "SourceSansPro-Regular", size: 13)
        addSubview(seriesLabel)
        
        // Settings button
        settingsButton.layer.borderWidth = 1.0
        settingsButton.layer.borderColor = UIColor.whiteColor().CGColor
        settingsButton.layer.cornerRadius = 3.0
        settingsButton.setTitle("Settings", forState: .Normal)
        settingsButton.tintColor = .whiteColor()
        settingsButton.titleLabel!.font = UIFont(name: "SourceSansPro-Regular", size: 13)
        addSubview(settingsButton)
        
        
        // Counters
        addSubview(playerOneCounter)
        playerOneCounter.playerName.text = "Me"
        
        addSubview(playerTwoCounter)
        playerTwoCounter.playerName.text = "OPPONENT"
    }
    
    func addWinCircle(frame: CGRect) {
        let circle = winCircle(frame: frame)
        addSubview(circle)
    }
}
