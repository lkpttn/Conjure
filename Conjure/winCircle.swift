//
//  winCircle.swift
//  Conjure
//
//  Created by Luke Patton on 7/11/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class winCircle: UIView {
    
    var defaults = NSUserDefaults.standardUserDefaults()
    var fillColor = UIColor()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Override the drawing code to make the view a yellow rectangle.
    override func drawRect(rect: CGRect) {
        // Create a bezier path that is limited to an oval.
        let selectedTheme = defaults.stringForKey("selectedTheme")
        changeTheme(selectedTheme!)
        
        let path = UIBezierPath(ovalInRect: rect)
        fillColor.setFill()
        path.fill()
    }
    
    func changeTheme(selectedTheme: String) {
        switch selectedTheme {
        case "Beleren":
            fillColor = UIColor.yellowColor()
        case "Aggro":
            fillColor = UIColor.whiteColor()
        case "Nissa":
            fillColor = UIColor.yellowColor()
        case "Aeons Torn":
            fillColor = UIColor.purpleColor()
        case "Scalding":
            fillColor = UIColor.whiteColor()
        case "Scapeshift":
            fillColor = UIColor.whiteColor()
        case "Living End":
            fillColor = UIColor.whiteColor()
        case "Golden":
            fillColor = UIColor.whiteColor()
        default:
            fillColor = UIColor.yellowColor()
        }
    }

}
