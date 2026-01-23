//
//  FallbackAPIService.swift
//  ChatTest
//
//  Created by Raghavan on 18/09/24.
//

import Foundation
class FallbackAPIService {
    static let shared = FallbackAPIService()

    func fetchAIResponse(for message: String, completion: @escaping (String) -> Void) {
        // Mock response for demonstration purposes
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            // Simulate a failure condition
            let errorResponse = """
            {
                "error": {
                    "message": "You exceeded your current quota, please check your plan and billing details.",
                    "type": "insufficient_quota",
                    "code": "insufficient_quota"
                }
            }
            """

            // Simulating an API failure
            let jsonData = Data(errorResponse.utf8)
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                   let error = json["error"] as? [String: Any],
                   let errorMessage = error["message"] as? String {
                    completion("Error: \(errorMessage)")
                } else {
                    completion("Bot: Sorry, something went wrong.")
                }
            } catch {
                completion("Bot: Sorry, something went wrong.")
            }
        }
    }
}
