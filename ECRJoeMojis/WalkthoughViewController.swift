//
//  ViewController.swift
//  ECRJoeMojis
//
//  Created by webwerks1 on 8/23/16.
//  Copyright © 2016 ECRJoeMojis. All rights reserved.
//


import UIKit
import ImageIO

class WalkthoughViewController: UIViewController {

    @IBOutlet weak var pageHeaderTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightContstraint: NSLayoutConstraint!
    @IBOutlet weak var pageHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageDescriptionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var getStartedHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControlConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblPageHeader: UILabel!
    @IBOutlet weak var lblPageSubHeader: UILabel!
    @IBOutlet weak var lblPageDescription: UILabel!
    @IBOutlet weak var imgWalkthough: UIImageView!
    @IBOutlet weak var lblPageFooter: UILabel!
    @IBOutlet weak var pageCountController: UIPageControl!
    @IBOutlet weak var btnGetStarted: UIButton!
    
    var index = 0,
    pageHeader =  "",
    pageSubHeader = "",
    pageDescription = "",
    pageImage = "",
    pageFooter =  ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblPageHeader.text = pageHeader
        lblPageDescription.text = pageDescription
        lblPageFooter.text = pageFooter
        imgWalkthough.image = UIImage(named: pageImage)
        pageCountController.currentPage = index

        if UIScreen.mainScreen().bounds.height <= 480 {
            imageHeightContstraint.constant = 140
            pageControlConstraint.constant = 15
            getStartedHeightConstraint.constant = 40
            pageDescriptionHeightConstraint.constant = 35
            pageHeaderHeightConstraint.constant = 15
        }
        if UIScreen.mainScreen().bounds.width >= 768 {
            imageHeightContstraint.constant = 500
            pageControlConstraint.constant = 40
            getStartedHeightConstraint.constant = 60
            pageDescriptionHeightConstraint.constant = 45
            pageHeaderHeightConstraint.constant = 60
            pageHeaderTopConstraint.constant = 50
        }

        //Show GetStarted button on last page
        if index == 4 {
            btnGetStarted.layer.cornerRadius = 5
            btnGetStarted.hidden = false
        } else {
            btnGetStarted.hidden = true
        }
    }
    @IBAction func btnGetStarted(sender: AnyObject) {
        if let settingsURL = NSURL(string: "prefs:root=General&path=Keyboard/KEYBOARDS") {
            UIApplication.sharedApplication().openURL(settingsURL)
        }
    }
}



