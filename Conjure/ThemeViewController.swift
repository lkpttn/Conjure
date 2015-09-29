//
//  ThemeViewController.swift
//  Conjure
//
//  Created by Luke Patton on 9/28/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class ThemeViewController: UIViewController {
    
    @IBOutlet weak var themeTable: UITableView!
    
    var themeController: ThemeTableViewController?
    var themeView: UIView?
    var cellData = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Getting access to child view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueName = segue.identifier
        if segueName == "showThemes" {
            themeController = segue.destinationViewController as? ThemeTableViewController
            themeView = themeController!.view
        }
    }

    // MARK: Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = String(cellData[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell!.accessoryType = .Checkmark
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
