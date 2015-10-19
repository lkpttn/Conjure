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
        let labelHalfWidth = (deviceWidth/2)-24
        
        // Free features
        freeFeaturesLabel.frame = CGRect(x: 16, y: 306, width: labelWidth, height: 16)
        freeFeatureOne.frame = CGRect(x: 16, y: 326, width: labelWidth, height: 16)
        freeFeatureTwo.frame = CGRect(x: 16, y: 347, width: labelWidth, height: 16)
        
        featuresLabel.frame = CGRect(x: 16, y: 406, width: labelWidth, height: 16)
        featureOne.frame = CGRect(x: 16, y: 426, width: labelWidth, height: 16)
        featureTwo.frame = CGRect(x: 16, y: 447, width: labelHalfWidth, height: 16)
        featureThree.frame = CGRect(x: labelHalfWidth+24, y: 447, width: labelHalfWidth, height: 16)
        
        buyButton.frame = CGRect(x: 16, y: 500, width: labelWidth, height: 44)
        
        // Paid features
        freeFeaturesLabel.font = UIFont(name: "SourceSansPro-Regular", size: 13)
        freeFeaturesLabel.textColor = UIColor.lightGrayColor()
        freeFeaturesLabel.textAlignment = .Center
        freeFeaturesLabel.text = "FREE FEATURES"
        
        freeFeatureOne.font = UIFont(name: "SourceSansPro-Regular", size: 14)
        freeFeatureOne.textAlignment = .Center
        freeFeatureOne.text = "Win and loss tracking for a single deck"
        
        freeFeatureTwo.font = UIFont(name: "SourceSansPro-Regular", size: 14)
        freeFeatureTwo.textAlignment = .Center
        freeFeatureTwo.text = "Save up to four matches"
        
        featuresLabel.font = UIFont(name: "SourceSansPro-Regular", size: 13)
        featuresLabel.textColor = UIColor.lightGrayColor()
        featuresLabel.textAlignment = .Center
        featuresLabel.text = "FULL VERSION FEATURES"
        
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

        self.view.addSubview(freeFeaturesLabel)
        self.view.addSubview(freeFeatureOne)
        self.view.addSubview(freeFeatureTwo)
        
        self.view.addSubview(featuresLabel)
        self.view.addSubview(featureOne)
        self.view.addSubview(featureTwo)
        self.view.addSubview(featureThree)
        
        self.view.addSubview(buyButton)
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
