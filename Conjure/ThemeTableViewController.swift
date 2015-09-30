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
    }
    
    var parentView = ThemeViewController?()
    var defaults = NSUserDefaults.standardUserDefaults()
    
    var cellData = ["Beleren", "Aggro", "Nissa", "Aeons Torn", "Scalding", "Scapeshift", "Living End", "Golden"]
    var selectedTheme = ""
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "settingCell")

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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
        cell.textLabel?.text = cellData[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        selectedTheme = cellData[indexPath.row]
        changeTheme(selectedTheme)
        
        
        cell!.accessoryType = .Checkmark
    }
    
    // MARK: Theme drawing
    func changeTheme(selectedTheme: String) {
        print("Changing the theme to \(selectedTheme)")
        defaults.setObject(selectedTheme, forKey: "selectedTheme")
        
        switch selectedTheme {
            case "Beleren":
                GameHeader.appearance().backgroundColor = darkBlueColor
                BigButton.appearance().backgroundColor = lightBlueColor
                BigButton.appearance().setTitleColor(.whiteColor(), forState: .Normal)
                UINavigationBar.appearance().barTintColor = darkBlueColor
            case "Aggro":
                GameHeader.appearance().backgroundColor = brightRedColor
                BigButton.appearance().backgroundColor = darkRedColor
                BigButton.appearance().setTitleColor(.whiteColor(), forState: .Normal)
                UINavigationBar.appearance().barTintColor = brightRedColor
            case "Nissa":
                UINavigationBar.appearance().barTintColor = darkGreenColor
                GameHeader.appearance().backgroundColor = darkGreenColor
                BigButton.appearance().backgroundColor = lightGreenColor
                BigButton.appearance().setTitleColor(.whiteColor(), forState: .Normal)
            case "Aeons Torn":
                GameHeader.appearance().backgroundColor = UIColor.blueColor()
            case "Scalding":
                GameHeader.appearance().backgroundColor = UIColor.blueColor()
            case "Scapeshift":
                GameHeader.appearance().backgroundColor = UIColor.blueColor()
            case "Living End":
                GameHeader.appearance().backgroundColor = UIColor.blueColor()
            case "Golden":
                GameHeader.appearance().backgroundColor = UIColor.blueColor()
            default:
                GameHeader.appearance().backgroundColor = UIColor.blueColor()
        }

        updatePreview()
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
