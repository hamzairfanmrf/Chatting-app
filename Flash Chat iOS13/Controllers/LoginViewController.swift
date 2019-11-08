//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    let authModel = AuthModel()

    @IBAction func loginPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let email = emailTextfield.text, !email.isEmpty,
              let password = passwordTextfield.text, !password.isEmpty else {
            // Show error if fields are empty
            print("Error: Fields cannot be empty")
            return
        }
        
        authModel.loginUser(email: email, password: password, onSuccess: {
            // Perform segue on successful login
            self.performSegue(withIdentifier: K.loginSegue, sender: self)
        }, onFailure: { errorMessage in
            // Handle the error, e.g., show an alert
            print("Error: \(errorMessage)")
        })
       }
    }

    

