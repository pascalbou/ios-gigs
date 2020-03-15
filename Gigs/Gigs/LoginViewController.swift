//
//  LoginViewController.swift
//  Gigs
//
//  Created by krikaz on 3/15/20.
//  Copyright © 2020 thewire. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case logIn
}

class LoginViewController: UIViewController {
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var logInSegmentedControl: UISegmentedControl!
    

    @IBAction func logInTypeChanged(_ sender: UISegmentedControl) {
         if sender.selectedSegmentIndex == 0 {
             loginType = .signUp
             logInButton.setTitle("Sign Up", for: .normal)
         } else {
             loginType = .logIn
             logInButton.setTitle("Log In", for: .normal)
         }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        print("button tapped")
        
         guard let gigController = gigController else { return }
                 
         if let username = usernameTextField.text,
             !username.isEmpty,
             let password = passwordTextField.text,
             !password.isEmpty {
             
             print("it works 1")
             let user = User(username: username, password: password)
             
             if loginType == .signUp {
                print("it works 2")
                gigController.signUp(with: user) { (error) in
                    if let error = error {
                         NSLog("Error occured during sign up: \(error)")
                     } else {
                         print("test")
                         DispatchQueue.main.async {
                             let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                             let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                             alertController.addAction(alertAction)
                             self.present(alertController, animated: true) {
                                 self.loginType = .logIn
                                 self.logInSegmentedControl.selectedSegmentIndex = 1
                                 self.logInButton.setTitle("Log In", for: .normal)
                             }
                         }
                     }
                 }
             } else {
                 gigController.logIn(with: user) { (error) in
                     if let error = error {
                         NSLog("Error occured during sign up: \(error)")
                     } else {
                         DispatchQueue.main.async {
                             self.dismiss(animated: true, completion: nil)
                         }
                     }
                 }
             }
         }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
