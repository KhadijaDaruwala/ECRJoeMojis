//
//  KeyboardViewController.swift
//  ECRJoeMojis Keyboard
//
//  Created by webwerks1 on 8/23/16.
//  Copyright © 2016 ECRJoeMojis. All rights reserved.
//

import UIKit

let colorText = UIColor.whiteColor()
let colorButtonBackground = UIColor(red: 0.9451, green: 0.5529, blue: 0.2588, alpha: 1.0)
let colorKeyboardBackground = UIColor(red: 0.9294, green: 0.2745, blue: 0.1412, alpha: 1.0)

let pasteMessage = "Now paste the image into the text field by tapping inside  and then selecting \"Paste\""

class emojiButton: UIButton  {
    override func awakeFromNib() {
        
        self.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20.0)
        self.setTitleColor(colorText, forState: .Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        self.backgroundColor = colorButtonBackground
        
        self.addTarget(self, action: #selector(self.holdDown(_:)), forControlEvents: .TouchDown)
        self.addTarget(self, action: #selector(self.holdRelease(_:)), forControlEvents: .TouchUpInside)
    }
    func holdDown(button: UIButton) {
        button.backgroundColor = colorKeyboardBackground
    }
    
    func holdRelease(button: UIButton) {
        button.backgroundColor = colorButtonBackground
    }
}

class sepcialButton: UIButton  {
    override func awakeFromNib() {
        
        self.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18.0)
        self.setTitleColor(colorText, forState: .Normal)
        
        self.backgroundColor = colorButtonBackground
        self.addTarget(self, action: #selector(self.holdDown(_:)), forControlEvents: .TouchDown)
        self.addTarget(self, action: #selector(self.holdRelease(_:)), forControlEvents: .TouchUpInside)
    }
    
    func holdDown(button: UIButton) {
        button.backgroundColor = colorKeyboardBackground
    }
    
    func holdRelease(button: UIButton) {
        button.backgroundColor = colorButtonBackground
    }
}

class KeyBoardView : UIView , UIInputViewAudioFeedback {
    var enableInputClicksWhenVisible: Bool {
        return true
    }
}

class KeyboardViewController: UIInputViewController, ECRJEmojiKeyboardDelegate {
    
    //Outlets
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet weak var btnShift: emojiButton!
    @IBOutlet weak var btnShiftSpecial: sepcialButton!
    @IBOutlet weak var rowNumber: UIStackView!
    @IBOutlet weak var rowChar1: UIStackView!
    @IBOutlet weak var rowSpecial1: UIStackView!
    @IBOutlet weak var rowSpecial2: UIStackView!
    @IBOutlet weak var rowChar2: UIStackView!
    @IBOutlet weak var rowQWERT: UIStackView!
    @IBOutlet weak var rowASDF: UIStackView!
    @IBOutlet weak var rowZXC: UIStackView!
    @IBOutlet weak var deleteKeyPressed: sepcialButton!
    
    var shifted = false
    var autoShifted = false
    var textDocument: UITextDocumentProxy!
    var emojiKeyboardView: EmojiKeyboardView!
    var keyboardView: UIView!
    var heightConstraint: NSLayoutConstraint!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textDocument = self.textDocumentProxy
//
//        var longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
//        self.deleteKeyPressed.addGestureRecognizer(longPress)
    }
    
//    func longPress(gesture: UILongPressGestureRecognizer) {
//        if gesture.state == .Ended {
//            print("Long Press")
//            self.textDocumentProxy.deleteBackward()
//
//        }
//    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let nib = UINib(nibName: "EmojiKeyboardView", bundle: nil)
        let objects = nib.instantiateWithOwner(self, options: nil)
        emojiKeyboardView = objects.first as! EmojiKeyboardView
        emojiKeyboardView.delegate = self
        view = emojiKeyboardView
    }
    
    func setShift(value:Bool) {
        btnShift?.selected = value
        btnShift?.tintColor = value ? UIColor(red:0.15, green:0.23, blue:0.31, alpha:1.00) : UIColor.whiteColor()
        shifted = value
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        if !textDocument.hasText() {
            autoShifted = true
            //btnShift.setImage(UIImage(named: "Caps Lock Off Filled"), forState: .Normal)
            setShift(true)
        }
    }
    @IBAction func keyPressed(button: UIButton) {
        
        UIDevice.currentDevice().playInputClick()
        let title = button.titleForState(.Normal)
        
        if shifted {
            btnShift.setImage(UIImage(named: "Caps Lock On Filled"), forState: .Normal)
            
            textDocument.insertText(title!.uppercaseString)
            
        } else {
            btnShift.setImage(UIImage(named: "Caps Lock Off Filled"), forState: .Normal)
            textDocument.insertText(title!.lowercaseString)
        }
        
        if autoShifted {
            autoShifted = false
            btnShift.setImage(UIImage(named: "Caps Lock On Filled"), forState: .Normal)
            setShift(autoShifted)
        }
    }
    
    @IBAction func capseKeyPressed(button: UIButton) {
        
        if button.titleLabel?.text == "#+=" {
            rowSpecial1.hidden = false
            rowSpecial2.hidden = false
            
            rowNumber.hidden = true
            rowChar1.hidden = true
            
            button.setTitle("123", forState: .Normal)
            
        } else if button.titleLabel?.text == "123" {
            rowSpecial1.hidden = true
            rowSpecial2.hidden = true
            
            rowNumber.hidden = false
            rowChar1.hidden = false
            
            button.setTitle("#+=", forState: .Normal)
            
        }else {
            rowSpecial1.hidden = true
            rowSpecial2.hidden = true
            
            if shifted {
                btnShift.setImage(UIImage(named: "Caps Lock Off Filled"), forState: .Normal)
                setShift(false)
                
            } else {
                btnShift.setImage(UIImage(named: "Caps Lock On Filled"), forState: .Normal)
                setShift(true)
            }
        }
    }
    
    @IBAction func deleteKeyPressed(button: UIButton) {
        self.textDocumentProxy.deleteBackward()
    }
    
    @IBAction func numberKeyPressed(button: UIButton) {
        
        if button.titleLabel?.text == "  123  " {
            
            button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 16.0)
            
            showRowQZA(true)
            showRowNum(false)
            
            //Change Shift key to #+=
            btnShiftSpecial.setTitle("#+=", forState: .Normal)
            btnShiftSpecial.setImage(nil, forState: .Normal)
            
            button.setTitle("  ABC  ", forState: .Normal)
        } else if button.titleLabel?.text == "  ABC  " {
            
            button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18.0)
            
            rowSpecial1.hidden = true
            rowSpecial2.hidden = true
            
            showRowQZA(false)
            showRowNum(true)
            
            button.setTitle("  123  ", forState: .Normal)
        }
    }
    
    @IBAction func keyChangeToEmojiKeyboardPressed(sender: AnyObject) {
        view = emojiKeyboardView
    }
    
    func showRowNum(value: Bool) {
        rowNumber.hidden = value
        rowChar1.hidden = value
        rowChar2.hidden = value
    }
    
    func showRowQZA(value: Bool) {
        rowQWERT.hidden = value
        rowZXC.hidden = value
        rowASDF.hidden = value
    }
    
    @IBAction func spaceKeyPressed(button: UIButton) {
        self.textDocumentProxy.insertText(" ")
    }
    
    @IBAction func returnKeyPressed(button: UIButton) {
        self.textDocumentProxy.insertText("\n")
    }
    
    func btnNextKeyboardPressed() {
        self.advanceToNextInputMode()
    }
    
    func btnAlphaNumericKeyboardPressed() {
        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib.instantiateWithOwner(self, options: nil)
        keyboardView = objects.first as! UIView
        view = keyboardView
        view.backgroundColor = colorKeyboardBackground
    }
    
    func btnDeletePressed() {
        self.textDocumentProxy.deleteBackward()
    }
    
    func btnSharePressed() {
        self.textDocumentProxy.insertText("Check out this cool new ECRJoeMojis app! It has emojis for the Moses Mabhida Stadium, the Drakensberg mountain range, sharks and Mandela - bit.ly/ECRJoeMojis")
    }
    
}

