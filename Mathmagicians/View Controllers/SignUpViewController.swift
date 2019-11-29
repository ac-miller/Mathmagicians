//
//  SignUpViewController.swift
//  Description: UI and checking for registering user accounts
//
//  Copyright © 2019 Mathmagicians. All rights reserved.
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
    
    var errorText: String = ""
    
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
                    self.errorText = "Email already in use"
                case .invalidEmail?:
                    self.errorText = "Email is incorrect format"
                case .wrongPassword?:
                    self.errorText = "Wrong Password"
                case .networkError?:
                    self.errorText = "Network Error"
                case .weakPassword?:
                    self.errorText = "Password must be at least 6 characters"
                default:
                    self.errorText = "Try Again Later"
                }
                //self.errorLabel.isHidden = false
                self.createAlert(title: "Error", message: self.errorText)
            }
            
        }
        
    }
    
    func createAlert (title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Retry", style: UIAlertAction.Style.default) { (act) in
            print("Alert dismissed")
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
