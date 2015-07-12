//
//  LifeCounter.swift
//  Conjure
//
//  Created by Luke Patton on 7/6/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class LifeCounter: UIView {

    // MARK: Propterties
    
    // Starting life total
    var lifeTotal = 20 {
        didSet {
            // Updates the layout whenever the lifeTotal is updated
            setNeedsLayout()
        }
    }
    
    // Creates the UI Labels
    // All created views need a defined frame for where they sit
    // Is this neccesary outside of the init? Is there a better way?
    var counter = UILabel(frame: CGRect(x: 0, y: 20, width: 100, height: 90))
    var playerName = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    var winner = ""

    
    
    // MARK: Initlization
    
    // First init. LifeCounter needs different frames, so we ask for one during intialization.
    override init(frame: CGRect) {
        // I think this just sets the frame to the frame.
        super.init(frame: frame)
        
        // This method adds and draws the Life Counter. Eventually will accept info about player names, life totals, etc
        addLifeCounter()
    }
    
    // We aren't calling this view in Interface Builder, so this doesn't execute. It's just neccesary for all UIView subclasses.
    required init(coder aDecoder: NSCoder) {
        // Calls the super class (UIView) initializer
        super.init(coder: aDecoder)
    }
    
    
    func addLifeCounter() {
        // Styles life counter label
        counter.textColor = UIColor.blackColor()
        counter.textAlignment = .Center
        counter.font = UIFont.boldSystemFontOfSize(72)
        counter.text = String(lifeTotal)
        
        // Styles playerName label
        playerName.text = "Player Name"
        playerName.textAlignment = .Center
        
        
        // Button
        let minusButton = UIButton(frame: CGRect(x: 5, y: 110, width: 40, height: 40))
        let plusButton = UIButton(frame: CGRect(x: 55, y: 110, width: 40, height: 40))
        
        minusButton.backgroundColor = UIColor.redColor()
        plusButton.backgroundColor = UIColor.blueColor()
        
        // Button action
        minusButton.addTarget(self, action: "minusLife:", forControlEvents: .TouchDown)
        plusButton.addTarget(self, action: "plusLife:", forControlEvents: .TouchDown)
        
        addSubview(playerName)
        addSubview(counter)
        addSubview(minusButton)
        addSubview(plusButton)
    }
    
    
    // MARK: Button actions
    func minusLife(minusButton: UIButton) {
        lifeTotal -= 1
        counter.text = String(lifeTotal)
    }
    
    func plusLife(plusButton: UIButton) {
        lifeTotal += 1
        counter.text = String(lifeTotal)
    }

} // END
