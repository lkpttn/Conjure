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
    var selectedTheme = ""
    var tempTheme: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up themePreview GameHeader
        themePreview.seriesLabel.text = "Theme Preview"
        themePreview.settingsButton.removeFromSuperview()
        themePreview.gameTimer.removeFromSuperview()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()) {
            let parent = navigationController?.topViewController as! SettingsTableViewController
            parent.selectedTheme = selectedTheme
            parent.tempTheme = tempTheme
        }
    }

    
    // MARK: Getting access to child view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "themeTableEmbed" {
            themeController = segue.destinationViewController as? ThemeTableViewController
            themeController!.delegate = self
            themeController?.tempTheme = self.tempTheme
        }
    }
    
    // MARK: Delegate methods
    func updatePreview() {
        let windows = UIApplication.sharedApplication().windows
        for window in windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
    }
    
    @IBAction func useTheme(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

}
