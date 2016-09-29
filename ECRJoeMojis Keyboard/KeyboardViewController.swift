//
//  KeyboardViewController.swift
//  ECRJoeMojis Keyboard
//
//  Created by webwerks1 on 8/23/16.
//  Copyright © 2016 ECRJoeMojis. All rights reserved.
//

import UIKit

let colorText = UIColor.white
let colorButtonBackground = UIColor(red: 0.9451, green: 0.5529, blue: 0.2588, alpha: 1.0)
let colorKeyboardBackground = UIColor(red: 0.9294, green: 0.2745, blue: 0.1412, alpha: 1.0)

let pasteMessage = "Now paste the image into the text field by tapping inside  and then selecting \"Paste\""

class emojiButton: UIButton  {
    override func awakeFromNib() {
        
        self.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20.0)
        self.setTitleColor(colorText, for: UIControlState())
        self.setTitleColor(UIColor.white, for: .highlighted)
        self.backgroundColor = colorButtonBackground
        
        self.addTarget(self, action: #selector(self.holdDown(_:)), for: .touchDown)
        self.addTarget(self, action: #selector(self.holdRelease(_:)), for: .touchUpInside)
    }
    func holdDown(_ button: UIButton) {
        button.backgroundColor = colorKeyboardBackground
    }
    
    func holdRelease(_ button: UIButton) {
        button.backgroundColor = colorButtonBackground
    }
}

class sepcialButton: UIButton  {
    override func awakeFromNib() {
        
        self.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18.0)
        self.setTitleColor(colorText, for: UIControlState())
        
        self.backgroundColor = colorButtonBackground
        self.addTarget(self, action: #selector(self.holdDown(_:)), for: .touchDown)
        self.addTarget(self, action: #selector(self.holdRelease(_:)), for: .touchUpInside)
    }
    
    func holdDown(_ button: UIButton) {
        button.backgroundColor = colorKeyboardBackground
    }
    
    func holdRelease(_ button: UIButton) {
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nib = UINib(nibName: "EmojiKeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
        emojiKeyboardView = objects.first as! EmojiKeyboardView
        emojiKeyboardView.delegate = self
        view = emojiKeyboardView
    }
    
    func setShift(_ value:Bool) {
        btnShift?.isSelected = value
        btnShift?.tintColor = value ? UIColor(red:0.15, green:0.23, blue:0.31, alpha:1.00) : UIColor.white
        shifted = value
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        if !textDocument.hasText {
            autoShifted = true
            //btnShift.setImage(UIImage(named: "Caps Lock Off Filled"), forState: .Normal)
            setShift(true)
        }
    }
    @IBAction func keyPressed(_ button: UIButton) {
        
        UIDevice.current.playInputClick()
        let title = button.title(for: UIControlState())
        
        if shifted {
            btnShift.setImage(UIImage(named: "Caps Lock On Filled"), for: UIControlState())
            
            textDocument.insertText(title!.uppercased())
            
        } else {
            btnShift.setImage(UIImage(named: "Caps Lock Off Filled"), for: UIControlState())
            textDocument.insertText(title!.lowercased())
        }
        
        if autoShifted {
            autoShifted = false
            btnShift.setImage(UIImage(named: "Caps Lock On Filled"), for: UIControlState())
            setShift(autoShifted)
        }
    }
    
    @IBAction func capseKeyPressed(_ button: UIButton) {
        
        if button.titleLabel?.text == "#+=" {
            rowSpecial1.isHidden = false
            rowSpecial2.isHidden = false
            
            rowNumber.isHidden = true
            rowChar1.isHidden = true
            
            button.setTitle("123", for: UIControlState())
            
        } else if button.titleLabel?.text == "123" {
            rowSpecial1.isHidden = true
            rowSpecial2.isHidden = true
            
            rowNumber.isHidden = false
            rowChar1.isHidden = false
            
            button.setTitle("#+=", for: UIControlState())
            
        }else {
            rowSpecial1.isHidden = true
            rowSpecial2.isHidden = true
            
            if shifted {
                btnShift.setImage(UIImage(named: "Caps Lock Off Filled"), for: UIControlState())
                setShift(false)
                
            } else {
                btnShift.setImage(UIImage(named: "Caps Lock On Filled"), for: UIControlState())
                setShift(true)
            }
        }
    }
    
    @IBAction func deleteKeyPressed(_ button: UIButton) {
        self.textDocumentProxy.deleteBackward()
    }
    
    @IBAction func numberKeyPressed(_ button: UIButton) {
        
        if button.titleLabel?.text == "  123  " {
            
            button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 16.0)
            
            showRowQZA(true)
            showRowNum(false)
            
            //Change Shift key to #+=
            btnShiftSpecial.setTitle("#+=", for: UIControlState())
            btnShiftSpecial.setImage(nil, for: UIControlState())
            
            button.setTitle("  ABC  ", for: UIControlState())
        } else if button.titleLabel?.text == "  ABC  " {
            
            button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18.0)
            
            rowSpecial1.isHidden = true
            rowSpecial2.isHidden = true
            
            showRowQZA(false)
            showRowNum(true)
            
            button.setTitle("  123  ", for: UIControlState())
        }
    }
    
    @IBAction func keyChangeToEmojiKeyboardPressed(_ sender: AnyObject) {
        view = emojiKeyboardView
    }
    
    func showRowNum(_ value: Bool) {
        rowNumber.isHidden = value
        rowChar1.isHidden = value
        rowChar2.isHidden = value
    }
    
    func showRowQZA(_ value: Bool) {
        rowQWERT.isHidden = value
        rowZXC.isHidden = value
        rowASDF.isHidden = value
    }
    
    @IBAction func spaceKeyPressed(_ button: UIButton) {
        self.textDocumentProxy.insertText(" ")
    }
    
    @IBAction func returnKeyPressed(_ button: UIButton) {
        self.textDocumentProxy.insertText("\n")
    }
    
    func btnNextKeyboardPressed() {
        self.advanceToNextInputMode()
    }
    
    func btnAlphaNumericKeyboardPressed() {
        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
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

