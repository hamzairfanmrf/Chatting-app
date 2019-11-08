//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    let thunderSymbol = "\u{26A1}"
    var messages: [MessageModel] = []
    let authModel = AuthModel()
    let databaseModel = DatabaseModel()
    
    @IBAction func LogOutButton(_ sender: Any) {
        authModel.logoutUser(onSuccess: {
            self.navigationController?.popToRootViewController(animated: true)
        }, onFailure: {error in
            print("error logging out \(error)")
            
        })
    }
    override func viewDidLoad() {
        navigationItem.hidesBackButton = true
        title = "\(thunderSymbol) Flash Chat"
      
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.dataSource = self
            tableView.delegate = self
        databaseModel.fetchMessages()
        databaseModel.delegate = self
        super.viewDidLoad()

    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        guard let messageText = messageTextfield.text, !messageText.isEmpty, let messageSender = Auth.auth().currentUser?.email else {
               print("Message text field is empty!")
               return
           }
           
           // Access Firestore
          
           
           // Data you want to store in Firestore
           let messageData: [String: Any] = [
               "messageText": messageText,  // Assign the non-empty message text
               "senderEmail": messageSender,
               "dateTime": FieldValue.serverTimestamp() // Replace with actual sender info
           ]
        db.collection(K.FStore.collectionName).addDocument(data: messageData) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document successfully added to UserMessages collection!")
            }
        }
        databaseModel.fetchMessages()
        DispatchQueue.main.async{
            self.messageTextfield.text = ""
        }
    }

    }

extension ChatViewController: UITableViewDataSource, UITableViewDelegate,DatabaseModelDelegate {
    func didFetchMessages(_ messages: [MessageModel]) {
        self.messages = messages
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if !self.messages.isEmpty {
                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
    // Handle errors
    func didFailWithError(error: String) {
        print("Failed to fetch messages: \(error)")
        // Optionally, show an alert to the user
    }
    
    // Number of rows in the table view section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count  // Return the number of messages in your array
    }
    
    // Method to configure and return the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the reusable cell with identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! CustomCell
        
        // Get the message for the current row
        let message = messages[indexPath.row]
        
        // Configure the cell (assuming you have UILabels in CustomCell for email and message text)
        cell.MessageLabel.text = message.senderEmail
        cell.MessageLabel.text = message.messageText
        if(message.senderEmail == Auth.auth().currentUser?.email){
            cell.leftImage.isHidden = true
            cell.MessageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
        }
        else{
            cell.UserImage.isHidden = true
            cell.MessageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
        }
        
        return cell
    }
    
    // (Optional) Set the height for each cell, if needed
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // Customize the height as needed
    }
}

