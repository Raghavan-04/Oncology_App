//
//  FirestoreManager.swift
//  ChatTest
//
//  Created by Raghavan on 18/09/24.
//

import Foundation
import Firebase
import FirebaseFirestore
//import FirebaseFirestoreSwift

class FirestoreManager: ObservableObject {
    private var db = Firestore.firestore()
    
    @Published var messages: [String] = []
    
    init() {
        fetchMessages()
    }
    
    // Fetch messages from Firestore
    func fetchMessages() {
        db.collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error.localizedDescription)")
                    return
                }
                
                self.messages = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    return data["text"] as? String
                } ?? []
            }
    }
    
    // Send a message to Firestore
    func sendMessage(message: String, isAgentMessage: Bool) {
        let messageData: [String: Any] = [
            "text": message,
            "timestamp": Timestamp()
        ]
        
        let collection = db.collection("messages")
        collection.addDocument(data: messageData) { error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
            }
        }
    }
}
