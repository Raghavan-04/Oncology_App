//
//  ChatResource.swift
//  ChatTest
//
//  Created by Raghavan on 01/10/24.
//

import Foundation

enum ResourceType: String, Codable {
    case image
    case video
    case document
    case text // You can add more types as needed
}

struct ChatResource: Identifiable, Codable {
    var id: UUID = UUID() // Unique identifier for each resource
    var type: ResourceType // The type of the resource (image, video, etc.)
    var url: String // URL or path to access the resource
    var title: String // Optional title for the resource
    var description: String? // Optional description for the resource
    
    // You can add more properties as needed
}
