//
//  ThemeViewController.swift
//  Conjure
//
//  Created by Luke Patton on 9/28/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class ThemeViewController: UIViewController, ThemeTableViewControllerDelegate {
    
    @IBOutlet weak var themePreview: GameHeader!
    
    var themeController: ThemeTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up themePreview GameHeader
        themePreview.seriesLabel.text = "Theme Preview"
        themePreview.settingsButton.removeFromSuperview()
        themePreview.gameTimer.removeFromSuperview()
        
    }
    
    // MARK: Getting access to child view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "themeTableEmbed" {
            print("themeTableEmbed works")
            themeController = segue.destinationViewController as? ThemeTableViewController
            themeController!.delegate = self
        }
    }
    
    // MARK: Delegate methods
    func updatePreview() {
        print("Delegate is working")
        themePreview.reloadInputViews()
        let windows = UIApplication.sharedApplication().windows
        for window in windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
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
