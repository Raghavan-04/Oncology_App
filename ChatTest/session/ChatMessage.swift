//
//  ChatMessage.swift
//  ChatTest
//
//  Created by Raghavan on 01/10/24.
//

import Foundation

struct ChatMessage: Identifiable, Codable {
    var id: UUID = UUID() // Unique identifier for each message
    var sender: String // Identifier for the sender (e.g., user ID or role)
    var timestamp: Date // Time when the message was sent
    var text: String? // The text content of the message (optional)
    var resources: [ChatResource] // An array of resources associated with the message

    // You can add more properties as needed
}
