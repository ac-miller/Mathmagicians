//
//  InstructionsPagesController.swift
//  Mathmagicians
//
//  Created by Aaron Miller on 11/3/19.
//  Copyright © 2019 Jesse Chan. All rights reserved.
//

import UIKit

class InstructionsPagesController : UIPageViewController {
    
    fileprivate lazy var pageCollection : [UIViewController] = {
        return [
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Instruct1"),
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Instruct2")
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        
        if let firstVC = pageCollection.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

    
}

extension InstructionsPagesController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let pageIndex = pageCollection.firstIndex(of: viewController)
            else {
                return nil
        }
        
        let previousIndex = pageIndex - 1
        
        guard previousIndex >= 0
            else {
                return nil
        }
        
        guard pageCollection.count > previousIndex
            else {
                return nil
        }
        
        return pageCollection[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let pageIndex = pageCollection.firstIndex(of: viewController)
            else {
                return nil
        }
        
        let nextIndex = pageIndex + 1
        
        guard nextIndex < pageCollection.count
            else {
                //if reached end, go to the map to start the game
                return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapPage")
        }
        
        return pageCollection[nextIndex]
        
    }
    
    
    
}

extension InstructionsPagesController : UIPageViewControllerDelegate {
    
}


