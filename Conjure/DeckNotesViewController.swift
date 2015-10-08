//
//  DeckNotesViewController.swift
//  Conjure
//
//  Created by Luke Patton on 10/5/15.
//  Copyright © 2015 Luke Patton. All rights reserved.
//

import UIKit

class DeckNotesViewController: UIViewController {
    
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var noteString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start with the keyboard
        notesTextView.text = noteString
        notesTextView.becomeFirstResponder()
        
        // Toolbar stuff
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.blueColor()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker:")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelPicker:")
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        notesTextView.inputAccessoryView = toolBar
        
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        if (self.isMovingFromParentViewController()) {
            let parent = navigationController?.topViewController as! DeckDetailViewController
            parent.deck?.notes = noteString
        }
    }

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            bottomConstraint.constant = keyboardSize.size.height + 20
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 0
    }
    
    func donePicker(sender: UIBarButtonItem) {
        notesTextView.resignFirstResponder()
        noteString = notesTextView.text
    }
    
    func cancelPicker(sender: UIBarButtonItem) {
        notesTextView.resignFirstResponder()
    }

}

