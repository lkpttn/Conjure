//
//  LeadViewController.swift
//  Conjure
//
//  Created by Luke Patton on 7/12/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class LeadViewController: UIViewController {
    
    @IBOutlet weak var gameHeader: GameHeader!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startSeries" {
            print("Starting a new series")
            // Downcasting the destination view controller as a MealViewController
            let svc = segue.destinationViewController as! GameViewController
            svc.series = Series(numberOfGames: 3, timeLimit: 2500)
        }
        else {
            print("Nope")
        }
    }


}
