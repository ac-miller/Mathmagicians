//
//  InstructionsPagesController.swift
//  Description: UI set up to display game instructions
//
//  Copyright © 2019  Mathmagicians. All rights reserved.
//

import UIKit

class InstructionsPagesController : UIPageViewController {
    
    //declared lazy to only load views as needed
    lazy var pageCollection : [UIViewController] = {
        return [
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Instruct1"),
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Instruct2"),
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Instruct3"),
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Instruct4")
        ]
    }()

    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        //have to use if let because first argument is an optional
        if let initialPage = pageCollection.first
        {
            setViewControllers([initialPage], direction: .forward, animated: true, completion: nil)
        }
        
        showDots()
    }
    
    func showDots() {
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.backgroundColor = UIColor.darkGray
    }
    
    
    
}

extension InstructionsPagesController : UIPageViewControllerDataSource {
    

    
    //sets the previous view controller in the page view controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        //gets the index of the current page inside of the collection
        guard let pageIndex = pageCollection.firstIndex(of: viewController)
            else {
                return nil
        }
        
        let previousIndex = pageIndex - 1
        
        guard previousIndex >= 0
            else {
                //if the previous index is -1, then don't wrap around to the last page
                return nil
        }
        
        return pageCollection[previousIndex]
    }
    
    //sets the next view controller in the page view controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        //gets the index of the current page inside of the collection
        guard let pageIndex = pageCollection.firstIndex(of: viewController)
            else {
                return nil
        }
        
        let nextIndex = pageIndex + 1
        
        guard nextIndex < pageCollection.count
            else {
                //if reached end, back to the beginning
                return pageCollection[0]
        }
        
        return pageCollection[nextIndex]
        
    }
    
    
}

extension InstructionsPagesController : UIPageViewControllerDelegate {
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageCollection.count
    }
}


