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
    var counter = UILabel(frame: CGRect(x: 0, y: 40, width: 100, height: 90))
    var playerName = UILabel(frame: CGRect(x: 0, y: 5, width: 100, height: 40))
    
    let deviceWidth = UIScreen.mainScreen().bounds.width

    
    // MARK: Initlization
    
    // First init. LifeCounter needs different frames, so we ask for one during intialization.
    override init(frame: CGRect) {
        // I think this just sets the frame to the frame.
        super.init(frame: frame)
        
        let frameWidth = self.bounds.width
        print(self.bounds.width)
        
        let counterFrame = CGRect(x: 0, y: 40, width: frameWidth, height: 90)
        counter.frame = counterFrame
        
        let nameFrame = CGRect(x: 0, y: 5, width: self.bounds.width, height: 40)
        playerName.frame = nameFrame
        
        addLifeCounter()
    }
    
    // We aren't calling this view in Interface Builder, so this doesn't execute. It's just neccesary for all UIView subclasses.
    required init(coder aDecoder: NSCoder) {
        // Calls the super class (UIView) initializer
        super.init(coder: aDecoder)
    }
    
    
    func addLifeCounter() {
    
        // Styles life counter label
        counter.textAlignment = .Center
        counter.textColor = UIColor.whiteColor()
        counter.font = UIFont(name: "SourceSansPro-Bold", size: 90)
        counter.text = String(lifeTotal)
        
        // Styles playerName label
        playerName.text = "Player Name"
        playerName.textAlignment = .Center
        playerName.textColor = .whiteColor()
        playerName.font = UIFont(name: "SourceSansPro-Regular", size: 13)
        
        
        // Button
        let minusButton = UIButton(frame: CGRect(x: (bounds.width/4), y: 130, width: 40, height: 40))
        let plusButton = UIButton(frame: CGRect(x: (bounds.width/4)+48, y: 130, width: 40, height: 40))
        
        let minusImage = UIImage(named: "Minus")
        minusButton.setImage(minusImage, forState: .Normal)
        
        let plusImage = UIImage(named: "Plus")
        plusButton.setImage(plusImage, forState: .Normal)
        
        // Button action
        minusButton.addTarget(self, action: "minusLife:", forControlEvents: .TouchDown)
        plusButton.addTarget(self, action: "plusLife:", forControlEvents: .TouchDown)
        
        // Testing colors.
//        counter.backgroundColor = .redColor()
//        playerName.backgroundColor = .blueColor()
//        minusButton.backgroundColor = .greenColor()
//        plusButton.backgroundColor = .yellowColor()
        
        addSubview(playerName)
        addSubview(counter)
        addSubview(minusButton)
        addSubview(plusButton)
    }
    
    
    // MARK: Button actions
    func minusLife(minusButton: UIButton) {
        if lifeTotal != 0 {
            lifeTotal -= 1
            counter.text = String(lifeTotal)
        }
    }
    
    func plusLife(plusButton: UIButton) {
            lifeTotal += 1
            counter.text = String(lifeTotal)
    }

} // END
