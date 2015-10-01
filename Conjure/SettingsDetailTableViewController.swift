//
//  SettingsDetailTableViewController.swift
//  Conjure
//
//  Created by Big Macberry on 8/27/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class SettingsDetailTableViewController: UITableViewController {
    
    var detailType = 0
    var cellData: NSArray = []
    var lastSelectedRow: NSIndexPath? = nil
    
    var lifeTotal = 0
    var numberOfGames = 0
    var timeLimit: Double = 0.0
    
    var numberOfGamesString: NSString = ""
    var timeLimitString: NSString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print(timeLimit)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "settingCell")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        if (self.isMovingFromParentViewController()) {
            let parent = navigationController?.topViewController as! SettingsTableViewController
            
            if detailType == 0 && lifeTotal != 0 {
                parent.tempLifeTotal = lifeTotal
                parent.startingLifeTotalLabel.text = String(lifeTotal)
            }
            else if detailType == 1 && numberOfGames != 0 {
                parent.numberOfGames = numberOfGames
                parent.numberOfGamesLabel.text = numberOfGamesString as String
            }
            else if detailType == 2 && timeLimit != 0 {
                print("Time limit = \(timeLimit)")
                print("Time Limit String = \(timeLimitString)")
                parent.timeLimit = timeLimit
                parent.timeLimitLabel.text = timeLimitString as String
            }
        }
    }


    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if detailType == 0 {
            return "Starting Life Total"
        }
        else if detailType == 1 {
            return "Match Type"
        }
        else {
            return "Time Limit"
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 21)
        
        if detailType == 0 {
            cell.textLabel?.text = String(cellData[indexPath.row])
        }
        else if detailType == 1 {
            let int = cellData[indexPath.row] as! Int
            switch int {
            case 1:
                cell.textLabel!.text = "Single Game"
            case 3:
                cell.textLabel!.text = "Best of 3"
            case 5:
                cell.textLabel!.text = "Best of 5"
            default:
                cell.textLabel!.text = "Single Game"
            }
        }
        else if detailType == 2 {
            let number = cellData[indexPath.row] as! Double
            switch number {
            case 600.0:
                cell.textLabel!.text = "10 Minutes"
            case 1500.0:
                cell.textLabel!.text = "25 Minutes"
            case 3000.0:
                cell.textLabel!.text = "50 Minutes"
            default:
                cell.textLabel!.text = "50 Minutes"
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if let last = lastSelectedRow {
            let oldSelectedCell = tableView.cellForRowAtIndexPath(last)
            oldSelectedCell?.accessoryType = .None
        }
        
        lastSelectedRow = indexPath
        if detailType == 0 {
            lifeTotal = Int(cellData[indexPath.row] as! NSNumber)
        }
        else if detailType == 1 {
            numberOfGames = Int(cellData[indexPath.row] as! NSNumber)
            switch numberOfGames {
            case 1:
                numberOfGamesString = "Single Game"
            case 3:
                numberOfGamesString = "Best of 3"
            case 5:
                numberOfGamesString = "Best of 5"
            default:
                numberOfGamesString = "Single Game"
            }
        }
        else if detailType == 2 {
            timeLimit = Double(cellData[indexPath.row] as! NSNumber)
            switch timeLimit {
            case 600.0:
                timeLimitString = "10 Minutes"
            case 1500.0:
                timeLimitString = "25 Minutes"
            case 3000.0:
                timeLimitString = "50 Minutes"
            default:
                timeLimitString = "50 Minutes"
            }
        }
        
        cell!.accessoryType = .Checkmark
    }
}
