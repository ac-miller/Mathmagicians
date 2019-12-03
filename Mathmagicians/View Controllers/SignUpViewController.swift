//
//  SignUpViewController.swift
//  Description: UI and checking for registering user accounts
//
//  Copyright © 2019 Mathmagicians. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    //not using first/last name yet. Must save those
    //by using the return userID from auth.createuser
    //we can store them in a subdatabase
    
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    var errorText: String = ""
    let validUsername = CharacterSet.letters.inverted

    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.delegate = self
        lastName.delegate = self
        
        errorLabel.isHidden = true
        errorLabel.numberOfLines = 0
        
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            if error == nil {
                print("Registration Successful")
                //store names
                let ref = Database.database().reference()
                let userID = Auth.auth().currentUser?.uid
                let name = ["first": self.firstName.text!, "last": self.lastName.text!]
                let childUpdate = ["users/\(userID!)/name/": name]
                ref.updateChildValues(childUpdate)
                
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
    
    //restricts text field to only uppercase and lowercase characters less than 20 chars
    //part of text field delegate
    //https://riptutorial.com/ios/example/24016/uitextfield---restrict-textfield-to-certain-characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        //for char testing
        let components = string.components(separatedBy: validUsername)
        let filtered = components.joined(separator: "")
        
        //for length testing
        let maxLength = 20
        let current: NSString = textField.text! as NSString
        let new: NSString =
            current.replacingCharacters(in: range, with: string) as NSString

        return (string == filtered && new.length <= maxLength)
    }
    
}
