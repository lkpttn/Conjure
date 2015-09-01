//
//  SettingsTableViewController.swift
//  Conjure
//
//  Created by Luke Patton on 8/27/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {
    
    let settings = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var playerOneNameField: UITextField!
    @IBOutlet weak var playerTwoNameField: UITextField!
    
    @IBOutlet weak var startingLifeTotalLabel: UILabel!
    @IBOutlet weak var numberOfGamesLabel: UILabel!
    @IBOutlet weak var timeLimitLabel: UILabel!
    
    var numberOfGames: Int = 3
    var numberofGamesOptions: NSArray = [1,3,5]
    
    var timeLimit: Double = 3000.0
    var timeLimitOptions: NSArray = [600.0,1500.0,3000.0]
    
    // Holder variables
    var tempPlayerOneName = "Me"
    var tempPlayerTwoName = "Opponent"
    var tempLifeTotal = 20
    var lifeTotalIndexPath = NSIndexPath()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.styleNavBar()
        self.loadAllSettings()
        
        playerOneNameField.delegate = self
        playerTwoNameField.delegate = self
        
        print("tempLifeTotal = \(tempLifeTotal)")
    }
    
    func loadAllSettings() {
        // Player names
        playerOneNameField.text = settings.stringForKey("playerOneName") ?? "Me"
        playerTwoNameField.text = settings.stringForKey("playerTwoName") ?? "Opponent"
        
        // Format Defaults
        numberOfGames = settings.integerForKey("numberOfGames")
        numberCase(numberOfGames)

        timeLimit = settings.doubleForKey("timeLimit")
        timeCase(timeLimit)
        
        tempLifeTotal = settings.integerForKey("lifeTotal") ?? 20
        startingLifeTotalLabel.text = String(settings.integerForKey("lifeTotal"))
    }
    
    func numberCase(int: Int) {
        switch int {
        case 1:
            numberOfGamesLabel.text = "Single Game"
        case 3:
            numberOfGamesLabel.text = "Best of 3"
        case 5:
            numberOfGamesLabel.text = "Best of 5"
        default:
            numberOfGamesLabel.text = "Single Game"
        }
        
    }
    
    func timeCase(double: Double) {
        switch double {
        case 600:
            timeLimitLabel.text = "10 Minutes"
        case 1500:
            timeLimitLabel.text = "25 Minutes"
        case 3000:
            timeLimitLabel.text = "50 Minutes"
        default:
            timeLimit = 3000
            timeLimitLabel.text = "50 Minutes"
        }
        
    }
    
    // Sets the font for the section headings
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView,
        forSection section: Int) {
            let header = view as! UITableViewHeaderFooterView
            // header.textLabel!.textColor = UIColor.greenColor()
            header.textLabel!.font = UIFont(name: "SourceSansPro-Regular", size: 13)
    }
    
    func styleNavBar() {
        let navBar = self.navigationController?.navigationBar
        navBar?.translucent = false
        navBar!.barTintColor = UIColor(red: 22/255.0, green: 48/255.0, blue: 63/255.0, alpha: 1)
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard when user hits Return
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == playerOneNameField {
            tempPlayerOneName = textField.text!
        }
        else if textField == playerTwoNameField {
            tempPlayerTwoName = textField.text!
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMatchType" {
            print("Choosing match type")
            let destination = segue.destinationViewController as! SettingsDetailTableViewController
            destination.detailType = 1
            
            destination.cellData = numberofGamesOptions
        }
        else if segue.identifier == "showLifeTotal" {
            print("Choosing life total")
            let destination = segue.destinationViewController as! SettingsDetailTableViewController
            destination.detailType = 0
            
            destination.cellData = [20,40,50]
            destination.lifeTotal = tempLifeTotal
        }
        else if segue.identifier == "showTimeLimit" {
            print("Choosing time limit")
            let destination = segue.destinationViewController as! SettingsDetailTableViewController
            destination.detailType = 2
            
            destination.cellData = timeLimitOptions
            destination.timeLimit = timeLimit
        }
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
