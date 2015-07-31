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
    let topFrame = CGRect(x: 0, y: 0, width: 750, height: 236)
    var playerOneCounter = LifeCounter(frame: CGRect(x: 40, y: 50, width: 163, height: 200))
    var playerTwoCounter = LifeCounter(frame: CGRect(x: 203, y: 50, width: 163, height: 200))
    
    var seriesLabel = UILabel(frame: CGRectZero)

    // The Frame
    // Based on iPhone 6 sizes, needs to adjust to autolayout
    // Frames do not have inheritance? Adjusting topFrame does not effect left and right side frames
    let leftSideFrame = CGRect(x: 40, y: 40, width: 163, height: 200)
    let rightSideFrame = CGRect(x: 203, y: 40, width: 163, height: 200)
    
    
    
    // MARK: Initlization
    // Views called programmatically use the default init command
    required init() {
        // Since we don't need different frame variable for this view, we can always just use topFrame
        super.init(frame: topFrame)
        
        // Do these do anything?
        playerOneCounter.frame = leftSideFrame
        playerOneCounter.backgroundColor = UIColor.redColor()
        playerTwoCounter.frame = rightSideFrame
        setupSubviews()
    }
    
    // Currently this view is being called in Interface Builder, and so it runs from this initializer.
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    func setupSubviews() {
        // Can we initialize lifeCounter's here? Right now they are explicitly declared.
        // let playerOneCounter = LifeCounter(frame: leftSideFrame)
        addSubview(playerOneCounter)
        playerOneCounter.backgroundColor = UIColor.clearColor()
        playerOneCounter.playerName.text = "Me"
        
        // let playerTwoCounter = LifeCounter(frame: rightSideFrame)
        addSubview(playerTwoCounter)
        playerTwoCounter.playerName.text = "Opponent"
        
        let seriesLabelFrame = CGRect(x: 0, y: 10, width: 360, height: 40)
        let seriesLabel = UILabel(frame: seriesLabelFrame)
        seriesLabel.textAlignment = .Center
        seriesLabel.text = ""
        seriesLabel.textColor = .whiteColor()
        addSubview(seriesLabel)
    }
    
    func addWinCircle(frame: CGRect) {
        let circle = winCircle(frame: frame)
        addSubview(circle)
    }
}
