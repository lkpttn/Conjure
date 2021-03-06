//
//  ThemeTableViewController.swift
//  Conjure
//
//  Created by Luke Patton on 9/28/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

protocol ThemeTableViewControllerDelegate {
    func updatePreview()
}

class ThemeTableViewController: UITableViewController {
    
    var delegate: ThemeViewController! = nil
    // Delegation methods
    func updatePreview() {
        delegate?.updatePreview()
        delegate?.selectedTheme = selectedTheme
        delegate?.tempTheme = tempTheme
    }
    
    var parentView = ThemeViewController?()
    var selectedThemeRow: NSIndexPath? = nil
    var firstSelection = true
    var defaults = NSUserDefaults.standardUserDefaults()
    
    var cellData = ["Beleren", "Aggro", "Nissa", "Aeons Torn", "Scalding", "Scapeshift", "Living End", "Golden"]
    var selectedTheme = ""
    var tempTheme: String?
    var cellArray = NSMutableArray()
    
    // Giant color library
    // Beleren
    let darkBlueColor = UIColor(red: 22/255.0, green: 48/255.0, blue: 63/255.0, alpha: 1.0)
    let lightBlueColor = UIColor(red: 8/255.0, green: 129/255.0, blue: 220/255.0, alpha: 1.0)
    
    // Aggro
    let brightRedColor = UIColor(red: 245/255.0, green: 54/255.0, blue: 49/255.0, alpha: 1.0)
    let darkRedColor = UIColor(red: 208/255.0, green: 2/255.0, blue: 27/255.0, alpha: 1.0)
    
    // Nissa
    let darkGreenColor = UIColor(red: 49/255.0, green: 159/255.0, blue: 58/255.0, alpha: 1.0)
    let lightGreenColor = UIColor(red: 60/255.0, green: 220/255.0, blue: 8/255.0, alpha: 1.0)
    
    // Aeons Torn
    let darkPurpleColor = UIColor(red: 48/255.0, green: 25/255.0, blue: 90/255.0, alpha: 1.0)
    let lightPurpleColor = UIColor(red: 162/255.0, green: 6/255.0, blue: 138/255.0, alpha: 1.0)
    
    // Scalding
    let mutedBlueColor = UIColor(red: 39/255.0, green: 124/255.0, blue: 142/255.0, alpha: 1.0)
    let mutedRedColor = UIColor(red: 214/255.0, green: 54/255.0, blue: 49/255.0, alpha: 1.0)
    
    // Scapeshift
    let dreamyBlueColor = UIColor(red: 157/255.0, green: 207/255.0, blue: 208/255.0, alpha: 1.0)
    let dreamyPurpleColor = UIColor(red: 129/255.0, green: 133/255.0, blue: 170/255.0, alpha: 1.0)
    
    // Living End
    let blackColor = UIColor.blackColor()
    let greyColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0)
    
    // Golden
    let goldColor = UIColor(red: 208/255.0, green: 195/255.0, blue: 67/255.0, alpha: 1.0)
    let lightGoldColor = UIColor(red: 235/255.0, green: 223/255.0, blue: 108/255.0, alpha: 1.0)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "settingCell")
        
        self.clearsSelectionOnViewWillAppear = false
        // We need to keep track of a temporary theme that someone can choose before saving
        if tempTheme != nil {
            selectedTheme = tempTheme!
        }
        if defaults.stringForKey("selectedTheme") == "" {
            selectedTheme = "Beleren"
        }
        if defaults.stringForKey("selectedTheme") != "" && tempTheme == nil {
            selectedTheme = defaults.stringForKey("selectedTheme")!
        }

        print("The selected theme is \(selectedTheme)")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView,
        forSection section: Int) {
            let header = view as! UITableViewHeaderFooterView
            header.textLabel!.font = UIFont(name: "SourceSansPro-Regular", size: 13)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 21)
        cell.textLabel?.text = cellData[indexPath.row]
        cell.selectionStyle = .None
        
        if cell.textLabel!.text == selectedTheme {
            cell.accessoryType = .Checkmark
            selectedThemeRow = indexPath
            print(cell.textLabel?.text)
        }
        else {
            cell.accessoryType = .None
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.accessoryType = .Checkmark
        
        if firstSelection == true && selectedThemeRow != cell {
            tableView.cellForRowAtIndexPath(selectedThemeRow!)?.accessoryType = .None
            firstSelection = false
        }
        
        selectedTheme = cellData[indexPath.row]
        tempTheme = cellData[indexPath.row]
        changeTheme(selectedTheme)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .None
    }
    
    // MARK: Theme drawing
    func changeTheme(selectedTheme: String) {
        print("Changing the theme to \(selectedTheme)")
        
        switch selectedTheme {
            case "Beleren":
                GameHeader.appearance().backgroundColor = darkBlueColor
                HeaderView.appearance().backgroundColor = darkBlueColor
                BigButton.appearance().backgroundColor = lightBlueColor
                BigButton.appearance().setTitleColor(.whiteColor(), forState: .Normal)
                UINavigationBar.appearance().barTintColor = darkBlueColor
            case "Aggro":
                GameHeader.appearance().backgroundColor = brightRedColor
                HeaderView.appearance().backgroundColor = brightRedColor
                BigButton.appearance().backgroundColor = darkRedColor
                BigButton.appearance().setTitleColor(.whiteColor(), forState: .Normal)
                UINavigationBar.appearance().barTintColor = brightRedColor
            case "Nissa":
                GameHeader.appearance().backgroundColor = darkGreenColor
                HeaderView.appearance().backgroundColor = darkGreenColor
                BigButton.appearance().backgroundColor = lightGreenColor
                BigButton.appearance().setTitleColor(.whiteColor(), forState: .Normal)
                UINavigationBar.appearance().barTintColor = darkGreenColor
            case "Aeons Torn":
                GameHeader.appearance().backgroundColor = darkPurpleColor
                HeaderView.appearance().backgroundColor = darkPurpleColor
                BigButton.appearance().backgroundColor = lightPurpleColor
                BigButton.appearance().setTitleColor(.whiteColor(), forState: .Normal)
                UINavigationBar.appearance().barTintColor = darkPurpleColor
            case "Scalding":
                GameHeader.appearance().backgroundColor = mutedBlueColor
                HeaderView.appearance().backgroundColor = mutedBlueColor
                BigButton.appearance().backgroundColor = mutedRedColor
                BigButton.appearance().setTitleColor(.whiteColor(), forState: .Normal)
                UINavigationBar.appearance().barTintColor = mutedBlueColor
            case "Scapeshift":
                GameHeader.appearance().backgroundColor = dreamyBlueColor
                HeaderView.appearance().backgroundColor = dreamyBlueColor
                BigButton.appearance().backgroundColor = dreamyPurpleColor
                BigButton.appearance().setTitleColor(.whiteColor(), forState: .Normal)
                UINavigationBar.appearance().barTintColor = dreamyBlueColor
            case "Living End":
                GameHeader.appearance().backgroundColor = blackColor
                HeaderView.appearance().backgroundColor = blackColor
                BigButton.appearance().backgroundColor = greyColor
                BigButton.appearance().setTitleColor(.whiteColor(), forState: .Normal)
                UINavigationBar.appearance().barTintColor = blackColor
            case "Golden":
                GameHeader.appearance().backgroundColor = goldColor
                HeaderView.appearance().backgroundColor = goldColor
                BigButton.appearance().backgroundColor = lightGoldColor
                BigButton.appearance().setTitleColor(.whiteColor(), forState: .Normal)
                UINavigationBar.appearance().barTintColor = goldColor
            default:
                GameHeader.appearance().backgroundColor = darkBlueColor
                HeaderView.appearance().backgroundColor = darkBlueColor
                BigButton.appearance().backgroundColor = lightBlueColor
                BigButton.appearance().setTitleColor(.whiteColor(), forState: .Normal)
                UINavigationBar.appearance().barTintColor = darkBlueColor
        }

        updatePreview()
    }
}
