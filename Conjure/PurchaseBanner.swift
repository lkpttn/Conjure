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
    var textLabel = UILabel(frame: CGRect(x: 10, y: 50, width: 200, height: 60))
    var buyButton = UIButton(frame: CGRect(x: 10, y: 10, width: 50, height: 30))
    
    let deviceWidth = UIScreen.mainScreen().bounds.width
    
    override init(frame: CGRect) {
        
        // I think this just sets the frame to the frame.
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        textLabel.text = "Testing"
        buyButton.backgroundColor = .redColor()
        buyButton.tag = 104
        
        addSubview(textLabel)
        addSubview(buyButton)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
