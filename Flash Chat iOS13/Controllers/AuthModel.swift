//
//  AuthModel.swift
//  Flash Chat iOS13
//
//  Created by Mac on 14/10/2024.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthModel{
    func loginUser(email: String, password: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
           Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
               if let error = error {
                   // Handle login error
                   print("Login failed: \(error.localizedDescription)")
                   onFailure(error.localizedDescription) // Pass the error to the closure
                   return
               }
               
               // User logged in successfully
               print("Login successful!")
               onSuccess()  // Call the success closure to handle segue
               
           }
       }
    func registerUser(email: String, password: String, onSucess: @escaping () -> Void, onFailure: @escaping (String) -> Void)  {
           Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
               if let error = error {
                   // Show error message
                   print("Error registering user: \(error.localizedDescription)")
                   onFailure(error.localizedDescription)
                   return
               }
               
               // User registered successfully
               print("User registered successfully with email: \(email)")
               onSucess()
            
               // Optionally, navigate to the next screen
           }
       }
    func logoutUser(onSuccess:@escaping ()-> Void, onFailure: @escaping (String)-> Void ) {
        do {
            try Auth.auth().signOut()
            print("User successfully logged out")
           onSuccess()
            // Optionally, navigate the user to a login screen or another part of your app
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            onFailure(signOutError as! String)
        }
    }
    
}
