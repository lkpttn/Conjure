//
//  IntroViewController.swift
//  Conjure
//
//  Created by Luke Patton on 10/18/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    let deviceWidth = UIScreen.mainScreen().bounds.width
    
    var freeFeaturesLabel = UILabel(frame: CGRect(x: 92, y: 286, width: 250, height: 16))
    var freeFeatureOne = UILabel(frame: CGRect(x: 92, y: 286, width: 250, height: 16))
    var freeFeatureTwo = UILabel(frame: CGRect(x: 16, y: 306, width: 250, height: 16))
    
    var featuresLabel = UILabel(frame: CGRect(x: 92, y: 286, width: 250, height: 16))
    var featureOne = UILabel(frame: CGRect(x: 92, y: 286, width: 250, height: 16))
    var featureTwo = UILabel(frame: CGRect(x: 16, y: 306, width: 250, height: 16))
    var featureThree = UILabel(frame: CGRect(x: 124, y: 306, width: 250, height: 16))
    
    var buyButton = UIButton(frame: CGRect(x: 16, y: 144, width: 250, height: 44))

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLabels()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLabels() {
        let labelWidth = deviceWidth-32
        
        buyButton.frame = CGRect(x: 16, y: 500, width: labelWidth, height: 44)
        
        let cornerRadius : CGFloat = 5.0
        let buttonBG = UIImage(named: "ButtonBG")
        buyButton.titleLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 16)
        buyButton.setTitle("Great, I got it", forState: UIControlState.Normal)
        buyButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        buyButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        buyButton.setBackgroundImage(buttonBG, forState: UIControlState.Highlighted)
        buyButton.backgroundColor = UIColor.clearColor()
        buyButton.layer.borderWidth = 1.0
        buyButton.layer.borderColor = UIColor.blueColor().CGColor
        buyButton.layer.cornerRadius = cornerRadius
        buyButton.tag = 104
        
        buyButton.addTarget(self, action: "gotIt:", forControlEvents: .TouchDown)
        
        self.view.addSubview(buyButton)
        
        let bottomConstraint = NSLayoutConstraint(item: buyButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 8)
        self.view.addConstraint(bottomConstraint)

    }
    
    func gotIt(sender: UIButton!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
