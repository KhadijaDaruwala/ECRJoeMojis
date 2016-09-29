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
    @IBOutlet weak var pageFooterHeightConstraint: NSLayoutConstraint!
    
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
        
        if UIScreen.main.bounds.height <= 536 {
//            if UIScreen.main.bounds.height <= 480 {
//                imageHeightContstraint.constant = 50
//                pageControlConstraint.constant = 10
//                getStartedHeightConstraint.constant = 30
//                pageDescriptionHeightConstraint.constant = 15
//                pageHeaderHeightConstraint.constant = 35
//                lblPageDescription.font = UIFont(name: "Helvetica Neue", size: 13)
//                lblPageFooter.font = UIFont(name: "Helvetica Neue", size: 11)
//            }
//            else{
                pageDescriptionHeightConstraint.constant = 60
                imageHeightContstraint.constant = 140
                pageControlConstraint.constant = 20
                getStartedHeightConstraint.constant = 45
                
                pageHeaderHeightConstraint.constant = 15
                pageFooterHeightConstraint.constant = 60
                lblPageDescription.font = UIFont(name: "Helvetica Neue", size: 16)
          //  }
            
        }
        if UIScreen.main.bounds.width >= 768 {
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
            btnGetStarted.isHidden = false
        } else {
            btnGetStarted.isHidden = true
        }
    }
    @IBAction func btnGetStarted(_ sender: AnyObject) {
        
        if #available(iOS 10.0, *) {
            // use the feature only available in iOS 10.0
            //  UIApplication.shared.open(url, options: [:], completionHandler: nil)
            showAlertDialog("To  enjoy the ECRJoeMojis keyboard, please go to the Settings application.", viewController: self)
        } else {
            if let settingsURL = URL(string: "prefs:root=General&path=Keyboard/KEYBOARDS") {
                UIApplication.shared.openURL(settingsURL)
            }
        }
    }
    
    func showAlertDialog(_ strMsg: String, viewController: UIViewController){
        let alert = UIAlertController(title: "ECRJoeMojis" , message: strMsg , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        viewController.present(alert, animated: true , completion: nil)
    }
}



