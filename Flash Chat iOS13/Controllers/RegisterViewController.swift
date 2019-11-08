//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    let authModel = AuthModel()
    
    @IBAction func registerPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let email = emailTextfield.text, !email.isEmpty,
                     let password = passwordTextfield.text, !password.isEmpty else {
                   // Show an error message if fields are empty
                   print("Error: Fields cannot be empty")
                   return
               }
               
        authModel.registerUser(email: email, password: password,onSucess: {
            self.performSegue(withIdentifier: K.registerSegue, sender: self)
        },onFailure: {errorMessage in
            print("Error registering user: \(errorMessage)")
        })
    }
    
}
