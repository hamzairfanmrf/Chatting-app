import Foundation
import FirebaseFirestore

// Define a protocol to notify the view controller
protocol DatabaseModelDelegate: AnyObject {
    func didFetchMessages(_ messages: [MessageModel])
    func didFailWithError(error: String)
}

class DatabaseModel {
    
    // Define a delegate property
    weak var delegate: DatabaseModelDelegate?
    
    // Fetch messages function
    func fetchMessages() {
        let db = Firestore.firestore()
        
        // Retrieve documents from the "messages" collection, ordered by "dateTime"
        db.collection(K.FStore.collectionName)
            .order(by: "dateTime", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error retrieving messages: \(error.localizedDescription)")
                    self.delegate?.didFailWithError(error: error.localizedDescription)
                } else {
                    var messages: [MessageModel] = []
                    
                    // Loop through the documents in the snapshot
                    for document in querySnapshot!.documents {
                        // Extract the data
                        let data = document.data()
                        if let senderEmail = data["senderEmail"] as? String,
                           let messageText = data["messageText"] as? String,
                           let time = data["dateTime"] as? Timestamp {
                            let actualTime = time.dateValue()
                            
                            // Create a MessageModel object
                            let message = MessageModel(senderEmail: senderEmail, messageText: messageText, dateTime: actualTime)
                            
                            // Append it to the messages list
                            messages.append(message)
                        }
                    }
                    
                    // Notify the delegate with fetched messages
                    self.delegate?.didFetchMessages(messages)
                }
            }
    }
}
