//
//  HomeViewController.swift
//  Description: UI setup to render home page
//
//  Copyright © 2019 Mathmagicians. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch let soError as NSError {
            print ("Error during signout: %@", soError)
        }
        
        
        
    }
    
}
