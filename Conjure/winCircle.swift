//
//  winCircle.swift
//  Conjure
//
//  Created by Luke Patton on 7/11/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class winCircle: UIView {
    
    // MARK: Properties
    // let rect: CGRect
    
    
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
        let path = UIBezierPath(ovalInRect: rect)
        UIColor.yellowColor().setFill()
        path.fill()
    }

}
