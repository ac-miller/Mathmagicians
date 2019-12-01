//
//  HomeViewController.swift
//  Description: UI setup to render home page
//
//  Copyright © 2019 Mathmagicians. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet var greetingText: UILabel!
    
    let userID = Auth.auth().currentUser?.uid
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        greetingText.isHidden = true
        ref.child("users").child(userID!).child("name").observeSingleEvent(of: .value, with: {
            (snapshot) in
            let value = snapshot.value as? NSDictionary
            let name = value?["first"] as? String ?? ""
            if name == "" {
                self.greetingText.text = "Hi Mathmagician!"
            }
            else {
                self.greetingText.text = "Hi \(name)!"
            }
            self.greetingText.isHidden = false
        }) { (error) in
            print(error.localizedDescription)
        }
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
    
    //setting the next nav bar to say Menu instead of Back
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Menu"
        navigationItem.backBarButtonItem = backItem
    }
    
}
