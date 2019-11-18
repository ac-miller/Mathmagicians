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
    
    var errorText: String = ""
    
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
                    self.errorText = "Email is incorrect format"
                case .wrongPassword?:
                    fallthrough
                case .userNotFound?:
                    self.errorText = "Username or Password Incorrect"
                case .networkError?:
                    self.errorText = "Network Error"
                default:
                    self.errorText = "Try Again Later"
                }
                //self.errorLabel.isHidden = false
                self.createAlert(title: "Error", message: self.errorText, action: "Retry")
            }
        }
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            if error == nil {
                self.createAlert(title: "Email Sent", message: "Check your email for a link to reset your password", action: "OK")
            } else {
                self.createAlert(title: "Error", message: "Invalid Email", action: "Retry")
            }
        }
        
    }

    func createAlert (title: String, message: String, action type: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: type, style: UIAlertAction.Style.default) { (act) in
            print("Alert dismissed")
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
