//
//  SmallPurchaseBanner.swift
//  Conjure
//
//  Created by Luke Patton on 10/17/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class SmallPurchaseBanner: UIView {

    // Frames and variables
    var textLabel = UILabel(frame: CGRect(x: 92, y: 10, width: 250, height: 44))
    var buyButton = UIButton(frame: CGRect(x: 16, y: 144, width: 250, height: 44))
    
    let deviceWidth = UIScreen.mainScreen().bounds.width
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        // COMPLEX MATH
        // width - outside edges - button width - inside margin
        let labelWidth = deviceWidth-32
        
        textLabel.frame = CGRect(x: 86, y: 16, width: labelWidth-86, height: 44)
        buyButton.frame = CGRect(x: 16, y: 16, width: 70, height: 44)
        
        let topBorder = CALayer()
        topBorder.backgroundColor = UIColor.lightGrayColor().CGColor
        topBorder.frame = CGRect(x: 0, y: self.bounds.height-80, width: deviceWidth, height: 1)
        
        textLabel.font = UIFont(name: "SourceSansPro-Regular", size: 14)
        textLabel.lineBreakMode = .ByWordWrapping
        textLabel.numberOfLines = 0
        textLabel.text = "Purchase Conjure to unlock all features, like unlimited deck slots and match history."
        
        let cornerRadius : CGFloat = 5.0
        let buttonBG = UIImage(named: "ButtonBG")
        buyButton.titleLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 16)
        buyButton.setTitle("Buy", forState: UIControlState.Normal)
        buyButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        buyButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        buyButton.setBackgroundImage(buttonBG, forState: UIControlState.Highlighted)
        buyButton.backgroundColor = UIColor.clearColor()
        buyButton.layer.borderWidth = 1.0
        buyButton.layer.borderColor = UIColor.blueColor().CGColor
        buyButton.layer.cornerRadius = cornerRadius
        buyButton.tag = 104
        
    
        addSubview(textLabel)
        addSubview(buyButton)
        self.layer.addSublayer(topBorder)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
