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
    var featuresLabel = UILabel(frame: CGRect(x: 92, y: 60, width: 250, height: 16))
    
    var featureOne = UILabel(frame: CGRect(x: 92, y: 86, width: 250, height: 16))
    var featureTwo = UILabel(frame: CGRect(x: 16, y: 106, width: 250, height: 16))
    var featureThree = UILabel(frame: CGRect(x: 124, y: 106, width: 250, height: 16))
    
    var buyButton = UIButton(frame: CGRect(x: 16, y: 144, width: 250, height: 44))
    
    let deviceWidth = UIScreen.mainScreen().bounds.width
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        // COMPLEX MATH
        // width - outside edges - button width - inside margin
        let labelWidth = deviceWidth-32
        let labelHalfWidth = (deviceWidth/2)-24
        
        textLabel.frame = CGRect(x: 16, y: 10, width: labelWidth, height: 44)
        featuresLabel.frame = CGRect(x: 16, y: 66, width: labelWidth, height: 16)
        featureOne.frame = CGRect(x: 16, y: 86, width: labelWidth, height: 16)
        featureTwo.frame = CGRect(x: 16, y: 112, width: labelHalfWidth, height: 16)
        featureThree.frame = CGRect(x: labelHalfWidth+24, y: 112, width: labelHalfWidth, height: 16)
        
        buyButton.frame = CGRect(x: 16, y: 144, width: labelWidth, height: 44)
        
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = UIColor.lightGrayColor().CGColor
        bottomBorder.frame = CGRect(x: 0, y: self.bounds.height, width: deviceWidth, height: 1)
        
        textLabel.font = UIFont(name: "SourceSansPro-Regular", size: 14)
        textLabel.textAlignment = .Center
        textLabel.lineBreakMode = .ByWordWrapping
        textLabel.numberOfLines = 0
        textLabel.text = "If you purchase Conjure,  you’ll support it’s future development and my card addiction."
        
        featuresLabel.font = UIFont(name: "SourceSansPro-Regular", size: 13)
        featuresLabel.textColor = UIColor.lightGrayColor()
        featuresLabel.textAlignment = .Center
        featuresLabel.text = "UNLOCK THESE FEATURES"
        
        featureOne.font = UIFont(name: "SourceSansPro-Regular", size: 14)
        featureOne.textAlignment = .Center
        featureOne.text = "Unlimited deck slots and match history"
        
        featureTwo.font = UIFont(name: "SourceSansPro-Regular", size: 14)
        featureTwo.textAlignment = .Center
        featureTwo.text = "Saving format defaults"
        
        featureThree.font = UIFont(name: "SourceSansPro-Regular", size: 14)
        featureThree.textAlignment = .Center
        featureThree.text = "9 additional themes"
        
        let cornerRadius : CGFloat = 5.0
        buyButton.titleLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 16)
        buyButton.setTitle("Unlock all features for $0.99", forState: UIControlState.Normal)
        buyButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        buyButton.backgroundColor = UIColor.clearColor()
        buyButton.layer.borderWidth = 1.0
        buyButton.layer.borderColor = UIColor.blueColor().CGColor
        buyButton.layer.cornerRadius = cornerRadius
        buyButton.tag = 104
        
        addSubview(textLabel)
        addSubview(featuresLabel)
        addSubview(featureOne)
        addSubview(featureTwo)
        addSubview(featureThree)
        addSubview(buyButton)
        self.layer.addSublayer(bottomBorder)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
