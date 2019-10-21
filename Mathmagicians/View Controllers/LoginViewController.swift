//
//  LoginViewController.swift
//  Mathmagicians
//
//  Created by Jesse Chan on 10/12/19.
//  Copyright © 2019 Jesse Chan. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        errorLabel.isHidden = true
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in

            if error == nil {
                print("Registration Successful")
                self.performSegue(withIdentifier: "loginSuccess", sender: nil)
            } else {
                let errorCode = AuthErrorCode(rawValue: error!._code)
                
                switch errorCode {
                case .invalidEmail?:
                    self.errorLabel.text = "ERROR: Email is incorrect format"
                case .wrongPassword?:
                    fallthrough
                case .userNotFound?:
                    self.errorLabel.text = "ERROR: Username or Password Incorrect"
                case .networkError?:
                    self.errorLabel.text = "ERROR: Network Error"
                default:
                    self.errorLabel.text = "ERROR: Try Again Later"
                }
                self.errorLabel.isHidden = false
                
            }
        }
    }
}
