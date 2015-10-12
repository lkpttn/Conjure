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

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var concedeSwitch: UISwitch!
    @IBOutlet weak var playerOneNameField: UITextField!
    @IBOutlet weak var playerTwoNameField: UITextField!
    
    @IBOutlet weak var startingLifeTotalLabel: UILabel!
    @IBOutlet weak var numberOfGamesLabel: UILabel!
    @IBOutlet weak var timeLimitLabel: UILabel!
    
    var bannerView: UIView?
    
    var numberOfGames: Int = 1
    var numberofGamesOptions: NSArray = [1,3,5]
    
    var timeLimit: Double = 3000.0
    var timeLimitOptions: NSArray = [600.0,1500.0,3000.0]
    
    // Holder variables
    var selectedTheme = ""
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
        
        saveButton.enabled = false
        showBanner()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        hideBanner()
    }
    
    func loadAllSettings() {
        // Selected theme
        selectedTheme = settings.stringForKey("selectedTheme") ?? "Beleren"
        print("The theme is \(selectedTheme)")
        
        // Player names
        playerOneNameField.text = settings.stringForKey("playerOneName") ?? "Me"
        playerTwoNameField.text = settings.stringForKey("playerTwoName") ?? "Opponent"
        
        // Format Defaults
        numberOfGames = settings.integerForKey("numberOfGames")
        print("The number of games is \(numberOfGames)")
        numberCase(numberOfGames)

        timeLimit = settings.doubleForKey("timeLimit")
        print("The time limit is \(timeLimit)")
        timeCase(timeLimit)
        
        tempLifeTotal = settings.integerForKey("lifeTotal") ?? 20
        if tempLifeTotal == 0 {
            tempLifeTotal = 20
        }
        print("The starting life total is is \(tempLifeTotal)")
        startingLifeTotalLabel.text = String(tempLifeTotal)
        
        if settings.boolForKey("tapAndHoldToConcede") == true {
            concedeSwitch.setOn(true, animated: true)
        }
        else if settings.boolForKey("tapAndHoldToConcede") == false {
            concedeSwitch.setOn(false, animated: true)
        }
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
            numberOfGamesLabel.text = "Best of 3"
        }
        
    }
    
    func timeCase(double: Double) {
        switch double {
        case 600.0:
            timeLimitLabel.text = "10 Minutes"
        case 1500.0:
            timeLimitLabel.text = "25 Minutes"
        case 3000.0:
            timeLimitLabel.text = "50 Minutes"
        default:
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
    }
    
    func didPurchase() {
        saveButton.enabled = true
    }
    
    func showBanner() {
        // Change table view inset
        self.tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        let barHeight = self.navigationController!.navigationBar.bounds.height+20
        let screenWidth = UIScreen.mainScreen().bounds.width
        bannerView = PurchaseBanner(frame: CGRect(x: 0, y:barHeight, width: screenWidth, height: 70))
        self.navigationController?.view.addSubview(bannerView!)
        
    }
    
    func hideBanner() {
        // Change table view inset
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bannerView!.removeFromSuperview()
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
        if segue.identifier != nil {
            self.tableView.deselectRowAtIndexPath((self.tableView.indexPathForSelectedRow)!, animated: true)
        }
        
        if segue.identifier == "showMatchType" {
            print("Choosing match type")
            let destination = segue.destinationViewController as! SettingsDetailTableViewController
            destination.detailType = 1
            destination.numberOfGames = numberOfGames
            
            destination.cellData = numberofGamesOptions
        }
        else if segue.identifier == "showLifeTotal" {
            print("Choosing life total")
            let destination = segue.destinationViewController as! SettingsDetailTableViewController
            destination.detailType = 0
            
            destination.cellData = [20,40,50]
        }
        else if segue.identifier == "showTimeLimit" {
            print("Choosing time limit")
            let destination = segue.destinationViewController as! SettingsDetailTableViewController
            destination.detailType = 2
            destination.timeLimit = timeLimit
            
            destination.cellData = timeLimitOptions
        }
    }
    
    
    // MARK: - Switches and buttons
    @IBAction func concedeSwitch(sender: UISwitch) {
        if concedeSwitch.on  == true {
            print(concedeSwitch.on)
            // settings.setBool(true, forKey: "tapAndHoldToConcede")
        }
        else if concedeSwitch.on == false {
            print(concedeSwitch.on)
            // settings.setBool(false, forKey: "tapAndHoldToConcede")
        }
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        print("I need to refresh the main view")
    }
    
}


