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
    let settings = NSUserDefaults.standardUserDefaults()
    var minusTimer = NSTimer()
    var plusTimer = NSTimer()
    
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
    var counterButton = UIButton(frame: CGRect(x: 0, y: 40, width: 100, height: 90))
    var playerName = UILabel(frame: CGRect(x: 0, y: 5, width: 100, height: 40))
    
    let deviceWidth = UIScreen.mainScreen().bounds.width

    
    // MARK: Initlization
    
    // First init. LifeCounter needs different frames, so we ask for one during intialization.
    override init(frame: CGRect) {
        
        lifeTotal = settings.integerForKey("lifeTotal")
        if lifeTotal == 0 {
            lifeTotal = 20
        }
        
        // I think this just sets the frame to the frame.
        super.init(frame: frame)
        
        minusTimer = NSTimer(timeInterval: 0.3, target: self, selector: "minus", userInfo: nil, repeats: true)
        plusTimer = NSTimer(timeInterval: 0.3, target: self, selector: "plus", userInfo: nil, repeats: true)
        
        let frameWidth = self.bounds.width
        
        let counterFrame = CGRect(x: 0, y: 40, width: frameWidth, height: 90)
        counter.frame = counterFrame
        counterButton.frame = counterFrame
        
        let nameFrame = CGRect(x: 0, y: 5, width: self.bounds.width, height: 40)
        playerName.frame = nameFrame
        
        addLifeCounter()
    }
    
    // We aren't calling this view in Interface Builder, so this doesn't execute. It's just neccesary for all UIView subclasses.
    required init(coder aDecoder: NSCoder) {
        // Calls the super class (UIView) initializer
        super.init(coder: aDecoder)!
    }
    
    func addLifeCounter() {
    
        // Styles life counter label
        counter.textAlignment = .Center
        counter.textColor = UIColor.whiteColor()
        counter.font = UIFont(name: "SourceSansPro-Bold", size: 90)
        counter.text = String(lifeTotal)
        
        // Styles the invisible button
        counterButton.backgroundColor = UIColor.clearColor()
        
        // Styles playerName label
        playerName.text = "Player Name"
        playerName.textAlignment = .Center
        playerName.textColor = .whiteColor()
        playerName.font = UIFont(name: "SourceSansPro-Regular", size: 13)
        
        
        // Button
        let minusButton = UIButton(frame: CGRect(x: (bounds.width/2)-60, y: 125, width: 60, height: 60))
        let plusButton = UIButton(frame: CGRect(x: (bounds.width/2), y: 125, width: 60, height: 60))
        
        let minusImage = UIImage(named: "Minus")
        minusButton.setImage(minusImage, forState: .Normal)
        
        let plusImage = UIImage(named: "Plus")
        plusButton.setImage(plusImage, forState: .Normal)
        
        // Button action
        let minusTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "minusTapped:")
        let minusLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: "minusLongPressed:")
        minusButton.addGestureRecognizer(minusTapGestureRecognizer)
        minusButton.addGestureRecognizer(minusLongPressRecognizer)
        
        let plusTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "plusTapped:")
        let plusLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: "plusLongPressed:")
        plusButton.addGestureRecognizer(plusTapGestureRecognizer)
        plusButton.addGestureRecognizer(plusLongPressRecognizer)
        
        // Tap-and-hold to concede
        if settings.boolForKey("tapAndHoldToConcede") == true {
            let counterLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: "counterLongPressed:")
            counterButton.addGestureRecognizer(counterLongPressRecognizer)
        }
        
        addSubview(playerName)
        addSubview(counter)
        addSubview(counterButton)
        addSubview(minusButton)
        addSubview(plusButton)
    }
    
    
    // MARK: Button actions
    func minus() {
        if lifeTotal != 0 {
            lifeTotal -= 1
            counter.text = String(lifeTotal)
        }
    }
    
    func plus() {
        lifeTotal += 1
        counter.text = String(lifeTotal)
    }
    
    func minusTapped(sender: UITapGestureRecognizer) {
        minus()
    }
    
    func minusLongPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended {
            minusTimer.invalidate()
            print("Long press ended")
        }
        else if sender.state == UIGestureRecognizerState.Began {
            print("Long press began")
            if minusTimer.valid == false {
                minusTimer = NSTimer(timeInterval: 0.3, target: self, selector: "minus", userInfo: nil, repeats: true)
            }
            NSRunLoop.currentRunLoop().addTimer(minusTimer, forMode: NSRunLoopCommonModes)
        }
    }
    
    func plusTapped(sender: UITapGestureRecognizer) {
        plus()
    }
    
    func plusLongPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended {
            plusTimer.invalidate()
            print("Long press ended")
        }
        else if sender.state == UIGestureRecognizerState.Began {
            print("Long press began")
            if plusTimer.valid == false {
                plusTimer = NSTimer(timeInterval: 0.3, target: self, selector: "plus", userInfo: nil, repeats: true)
            }
            NSRunLoop.currentRunLoop().addTimer(plusTimer, forMode: NSRunLoopCommonModes)
        }
    }
    
    func counterLongPressed(sender: UILongPressGestureRecognizer) {
        print("Long press began")
        if sender.state == UIGestureRecognizerState.Began {
            lifeTotal = 0
            counter.adjustsFontSizeToFitWidth = true
            counter.text = "0"
        }
    }
    

} // END
