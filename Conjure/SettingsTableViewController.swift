//
//  SettingsTableViewController.swift
//  Conjure
//
//  Created by Luke Patton on 8/27/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit
import StoreKit

class SettingsTableViewController: UITableViewController, UITextFieldDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    let settings = NSUserDefaults.standardUserDefaults()
    
    // In-app purchase stuff
    var productArray: Array<SKProduct!> = []
    var transactionInProgress = false
    var buyButton: UIButton?

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var concedeSwitch: UISwitch!
    @IBOutlet weak var playerOneNameField: UITextField!
    @IBOutlet weak var playerTwoNameField: UITextField!
    @IBOutlet weak var startingLifeTotalLabel: UILabel!
    @IBOutlet weak var numberOfGamesLabel: UILabel!
    @IBOutlet weak var timeLimitLabel: UILabel!
    @IBOutlet weak var restorePurchaseCell: UITableViewCell!
    
    var bannerView: UIView?
    var purchaseTest = false
    
    var numberOfGames: Int = 1
    var numberofGamesOptions: NSArray = [1,3,5]
    
    var timeLimit: Double = 3000.0
    var timeLimitOptions: NSArray = [600.0,1500.0,3000.0]
    
    // Holder variables
    var selectedTheme = ""
    var tempTheme: String?
    var tempPlayerOneName = "Me"
    var tempPlayerTwoName = "Opponent"
    var tempLifeTotal = 20
    var lifeTotalIndexPath = NSIndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        self.styleNavBar()
        self.loadAllSettings()
        

        
        playerOneNameField.delegate = self
        playerTwoNameField.delegate = self
        
        let restoreTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "restorePurchases:")
        restorePurchaseCell.addGestureRecognizer(restoreTapGestureRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        purchaseTest = settings.boolForKey("didPurchase")
        checkPurchase()
        if purchaseTest == false  {
            requestProductInfo()
        }
        
        // Become an observer of the transaction
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)

    }
    
    override func viewDidAppear(animated: Bool) {
        print("The temp theme = \(tempTheme)")
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
            numberOfGamesLabel.text = "Single Game"
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
            header.textLabel!.font = UIFont(name: "SourceSansPro-Regular", size: 13)
    }
    
    // Sets the font for the section footers
    override func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        footer.textLabel!.font = UIFont(name: "SourceSansPro-Regular", size: 13)
        footer.textLabel?.textAlignment = .Center
    }
    
    func styleNavBar() {
        let navBar = self.navigationController?.navigationBar
        navBar?.translucent = false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // Gets the list of products
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productID = NSSet(object: "com.friendofpixels.ConjureUnlock")
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            print(productsRequest)
            
            productsRequest.delegate = self
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            productsRequest.start()
            
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    // Holds the response from the server with the products
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        if response.products.count != 0 && purchaseTest == false {
            print("There is a product!")
            for product in response.products {
                productArray.append(product as SKProduct)
                buyButton?.enabled = true
                buyButton?.addTarget(self, action: "purchase:", forControlEvents: UIControlEvents.TouchDown)
                buyButton?.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
                buyButton?.layer.borderColor = UIColor.blueColor().CGColor
                buyButton?.setTitle("Unlock all features for $0.99", forState: UIControlState.Normal)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }
        else {
            print("There are no products.")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func purchase(sender: UIButton) {
        let payment = SKPayment(product: self.productArray[0] as SKProduct)
        // Adds the payment to the queue
        SKPaymentQueue.defaultQueue().addPayment(payment)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.transactionInProgress = true
    }
    
    // Monitors the payment in the background
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("Received Payment Transaction Response from Apple")
        
        for transaction in transactions as [SKPaymentTransaction] {
            switch transaction.transactionState {
            case SKPaymentTransactionState.Purchased, SKPaymentTransactionState.Restored:
                print("Transaction completed successfully.")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                transactionInProgress = false
                purchaseTest = true
                settings.setBool(true, forKey: "didPurchase")
                self.checkPurchase()
                
            case SKPaymentTransactionState.Failed:
                print("Transaction Failed")
                print(transaction.error)
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                transactionInProgress = false
                
                let alert = UIAlertController(title: "Your purchase failed!", message: "Check your account info and your internet connection then try again.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok, thanks", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }
    
    func checkPurchase() {
        if purchaseTest == false {
            showBanner()
            saveButton.enabled = false
        } else if purchaseTest == true {
            saveButton.enabled = true
            hideBanner()
        }
    }
    
    func showBanner() {
        // Change table view inset
        self.tableView.contentInset = UIEdgeInsets(top: 236, left: 0, bottom: 0, right: 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 236, left: 0, bottom: 0, right: 0)
        
        let barHeight = self.navigationController!.navigationBar.bounds.height+20
        let screenWidth = UIScreen.mainScreen().bounds.width
        bannerView = PurchaseBanner(frame: CGRect(x: 0, y:barHeight, width: screenWidth, height: 236))
        
        buyButton = bannerView?.viewWithTag(104) as? UIButton
        buyButton!.enabled = false
        buyButton!.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        buyButton!.layer.borderColor = UIColor.grayColor().CGColor
        
        self.navigationController?.view.addSubview(bannerView!)
    }
    
    func hideBanner() {
        // Change table view inset
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bannerView?.removeFromSuperview()
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
        if segue.identifier == "showThemes" {
            print("Choosing theme")
            let destination = segue.destinationViewController as! ThemeViewController
            destination.tempTheme = tempTheme
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
    func purchaseApp(sender: UIButton) {
        if purchaseTest == false {
            purchaseTest = true
        } else if purchaseTest == true {
            purchaseTest = false
        }
        print(purchaseTest)
        checkPurchase()
    }
    
    func restorePurchases(sender: UIGestureRecognizer) {
        if settings.boolForKey("didPurchase") == false {
            if (SKPaymentQueue.canMakePayments()) {
                SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            }
        }
        else {
            let alert = UIAlertController(title: "You've already purchased everything.", message: "All features are already unlocked for you, go enjoy them!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok, thanks", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func concedeSwitch(sender: UISwitch) {
        if concedeSwitch.on  == true {
            print(concedeSwitch.on)
            settings.setBool(true, forKey: "tapAndHoldToConcede")
        }
        else if concedeSwitch.on == false {
            print(concedeSwitch.on)
            settings.setBool(false, forKey: "tapAndHoldToConcede")
        }
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}


