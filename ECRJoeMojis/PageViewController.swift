//
//  PageViewController.swift
//  ECRJoeMojis
//
//  Created by webwerks1 on 8/23/16.
//  Copyright © 2016 ECRJoeMojis. All rights reserved.
//


import UIKit

class PageViewController: UIPageViewController {
    
    let  pageHeader = ["", "STEP 1", "STEP 2", "STEP 3", "STEP 4"]
    
    let pageDescription = ["", "From Settings > General > Keyboard > Keyboards > Add New Keyboard", "Add \"ECRMojis\" from THIRD-PARTY KEYBOARDS", "Select \"ECRMojis\" keyboard and turn ON \"Allow Full Access\"", "From iMessage select the globe icon to switch to the \"ECRMojis\" keyboard"]

    let pageImages = ["step_0", "step_1", "step_2", "step_3", "step_4"]
    
    let pageFooter = ["", "", "", "The step is required to copy and paste emoji into your keyboard. The keyboard is not designed to store what you type or transmit it to anyone.", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.dataSource = self
        
        if let walkthoughVC = self.viewControllerAtIndex(0)  {
            setViewControllers([walkthoughVC], direction: .forward, animated: true, completion: nil)
        }

//        let backgroundImage = UIImageView(frame: CGRect(origin: view.bounds.origin, size: view.bounds.size))
//        backgroundImage.image = UIImage(named: "background")
//        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func viewControllerAtIndex(_ index: Int) -> WalkthoughViewController? {
        
        if index == NSNotFound || index < 0 || index >= pageHeader.count {
            return nil
        }
        
        if let walkthoughVC = storyboard?.instantiateViewController(withIdentifier: "WalkthoughViewController") as? WalkthoughViewController {
            
            walkthoughVC.pageHeader = pageHeader[index]
            walkthoughVC.pageDescription   = pageDescription[index]
            walkthoughVC.pageFooter = pageFooter[index]
            walkthoughVC.pageImage = pageImages[index]
            walkthoughVC.index = index
            
            return walkthoughVC
        }
        return nil
    }
}

extension PageViewController : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let index = (viewController as! WalkthoughViewController).index + 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let index = (viewController as! WalkthoughViewController).index - 1
        return self.viewControllerAtIndex(index)
    }
}
