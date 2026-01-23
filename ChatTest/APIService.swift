import Foundation

struct OpenAIResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}

class APIService {
    static let shared = APIService()
    
    private init() {}  // Make the initializer private to enforce singleton usage
    
    func fetchAIResponse(for message: String, completion: @escaping (String) -> Void) {
        let apiKey = ""  // Replace with your actual API key
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json: [String: Any] = [
            "model": "text-embedding-ada-002",
            "messages": [["role": "user", "content": message]]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            completion("Failed to encode request data.")
            return
        }
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Network Error: \(error.localizedDescription)")
                self?.fallbackToManualChat(for: message, completion: completion)
                return
            }
            
            guard let data = data else {
                print("No data received from the API")
                self?.fallbackToManualChat(for: message, completion: completion)
                return
            }
            
            do {
                if let jsonString = String(data: data, encoding: .utf8), jsonString.contains("error") {
                    print("Response JSON: \(jsonString)")
                    self?.fallbackToManualChat(for: message, completion: completion)
                    return
                }
                
                let responseObject = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                let aiMessage = responseObject.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Sorry, I didn't understand that."
                completion(aiMessage)
            } catch {
                print("Decoding Error: \(error.localizedDescription)")
                self?.fallbackToManualChat(for: message, completion: completion)
            }
        }
        task.resume()
    }
    
    private func fallbackToManualChat(for message: String, completion: @escaping (String) -> Void) {
        // Manual chat logic can be implemented here, for now, we just return a message
        let manualResponse = "Sorry, I couldn't connect to the AI service. How can I assist you manually?"
        completion(manualResponse)
    }
}
