//
//  SignUpViewController.swift
//  Mathmagicians
//
//  Created by Jesse Chan on 10/12/19.
//  Copyright © 2019 Jesse Chan. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    //not using first/last name yet. Must save those
    //by using the return userID from auth.createuser
    //we can store them in a subdatabase
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
        errorLabel.numberOfLines = 0
        
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            if error == nil {
                print("Registration Successful")
                self.performSegue(withIdentifier: "signedSuccess", sender: nil)
            } else {
                let errorCode = AuthErrorCode(rawValue: error!._code)
                
                switch errorCode {
                case .emailAlreadyInUse?:
                    self.errorLabel.text = "ERROR: Email Already in Use"
                case .invalidEmail?:
                    self.errorLabel.text = "ERROR: Email is incorrect format"
                case .wrongPassword?:
                    self.errorLabel.text = "ERROR: Wrong Password"
                case .networkError?:
                    self.errorLabel.text = "ERROR: Network Error"
                case .weakPassword?:
                    self.errorLabel.text = "ERROR: Password must be at least 6 characters"
                default:
                    self.errorLabel.text = "ERROR: Try Again Later"
                }
                self.errorLabel.isHidden = false
                
            }
        }
    }
    
}
