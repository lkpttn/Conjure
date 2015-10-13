//
//  PurchaseBanner.swift
//  Conjure
//
//  Created by Luke Patton on 10/12/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class PurchaseBanner: UIView {
    
    // Frames and variables
    var textLabel = UILabel(frame: CGRect(x: 92, y: 10, width: 250, height: 44))
    var buyButton = UIButton(frame: CGRect(x: 16, y: 10, width: 60, height: 44))
    
    let deviceWidth = UIScreen.mainScreen().bounds.width
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = UIColor.lightGrayColor().CGColor
        bottomBorder.frame = CGRect(x: 0, y: self.bounds.height, width: deviceWidth, height: 1)
        
        textLabel.font = UIFont(name: "SourceSansPro-Regular", size: 14)
        textLabel.lineBreakMode = .ByWordWrapping
        textLabel.numberOfLines = 0
        textLabel.text = "By purchasing Conjure, you unlock all features and support my card addiction."
        // textLabel.text = "Purchase the full version of Conjure for unlimited deck slots, history and the ability to save settings"
        
        let cornerRadius : CGFloat = 5.0
        buyButton.titleLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 16)
        buyButton.setTitle("$0.99", forState: UIControlState.Normal)
        buyButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        buyButton.backgroundColor = UIColor.clearColor()
        buyButton.layer.borderWidth = 1.0
        buyButton.layer.borderColor = UIColor.blueColor().CGColor
        buyButton.layer.cornerRadius = cornerRadius
        buyButton.tag = 104
        
        addSubview(textLabel)
        addSubview(buyButton)
        self.layer.addSublayer(bottomBorder)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
