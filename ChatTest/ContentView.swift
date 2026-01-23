import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    @State private var messages: [String] = []
    @State private var messageText = ""
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    
    // Declare Firestore database instance here
    private var db = Firestore.firestore()

    var body: some View {
        VStack {
            HStack {
                Text("Oncowise Bot")
                    .font(.title2)
                    .bold()
                Spacer()
                // Clear chat button
                Button(action: clearChat) {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 20))
                }
                // Add history button
                Button(action: {
                    // Fetch chat history for a specific session ID (you need to define a sessionID)
                    fetchChatHistory(sessionID: "yourSessionID")
                }) {
                    Image(systemName: "clock.fill") // Use appropriate history icon
                        .font(.system(size: 20))
                }
            }
            .padding()

            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        ForEach(messages.indices, id: \.self) { index in
                            let message = messages[index]
                            let formattedMessage = formatMessage(message)
                            
                            HStack {
                                if message.contains("[USER]") {
                                    Spacer()
                                    ChatBubble(text: formattedMessage, color: .blue)
                                } else {
                                    ChatBubble(text: formattedMessage, color: .gray)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 10)
                        }
                        if isLoading {
                            HStack {
                                Spacer()
                                Text("Bot is typing...")
                                    .foregroundColor(.gray)
                                    .padding()
                                Spacer()
                            }
                        }
                        if let errorMessage = errorMessage {
                            HStack {
                                Spacer()
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .padding()
                                Spacer()
                            }
                        }
                    }
                    .onChange(of: messages) { _ in
                        withAnimation {
                            if let lastMessageIndex = messages.indices.last {
                                proxy.scrollTo(lastMessageIndex, anchor: .bottom)
                            }
                        }
                    }
                }
                .background(Color.gray.opacity(0.12))
            }
            
            HStack {
                TextField("Type something...", text: $messageText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .onSubmit {
                        sendMessage(message: messageText)
                    }
                
                Button(action: {
                    sendMessage(message: messageText)
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 10)
            }
            .padding()
        }
    }
    
    private func formatMessage(_ message: String) -> String {
        return message
            .replacingOccurrences(of: "[USER]", with: "")
            .replacingOccurrences(of: "[BOT]", with: "")
    }
    
    func sendMessage(message: String) {
        guard !message.isEmpty else { return }
        
        // Add user message to the chat
        messages.append("[USER] \(message)")
        self.messageText = ""
        
        // Call the Flask server
        fetchResponse(for: message)

        // Save message to Firestore (sessionID should be defined)
        saveMessageToFirestore(sessionID: "yourSessionID", message: "[USER] \(message)")
    }

    func fetchResponse(for message: String) {
        isLoading = true
        errorMessage = nil
        
        let ngrokUrl = "https://6e28-34-143-236-152.ngrok-free.app/get-response?message=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        guard let url = URL(string: ngrokUrl) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false // Stop loading indicator
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching response: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let botMessage = json?["response"] as? String {
                    DispatchQueue.main.async {
                        withAnimation {
                            messages.append("[BOT] \(botMessage)")
                            
                            // Save bot response to Firestore (sessionID should be defined)
                            saveMessageToFirestore(sessionID: "yourSessionID", message: "[BOT] \(botMessage)")
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error parsing JSON: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    // Function to save message to Firestore
    func saveMessageToFirestore(sessionID: String, message: String) {
        db.collection("chat_sessions").document(sessionID).setData([
            "messages": FieldValue.arrayUnion([message])
        ], merge: true) { error in
            if let error = error {
                print("Error saving message: \(error)")
            } else {
                print("Message saved to Firestore")
            }
        }
    }

    // Function to fetch chat history from Firestore
    func fetchChatHistory(sessionID: String) {
        db.collection("chat_sessions").document(sessionID).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let fetchedMessages = data?["messages"] as? [String] {
                    self.messages = fetchedMessages
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // Function to clear chat
    func clearChat() {
        // Clear messages from the array
        messages.removeAll()
        // Optionally, you can also clear the Firestore messages for the session if needed
        clearMessagesFromFirestore(sessionID: "yourSessionID")
    }
    
    // Function to clear messages from Firestore
    func clearMessagesFromFirestore(sessionID: String) {
        db.collection("chat_sessions").document(sessionID).setData([
            "messages": []
        ], merge: true) { error in
            if let error = error {
                print("Error clearing messages: \(error)")
            } else {
                print("Messages cleared in Firestore")
            }
        }
    }
}

struct ChatBubble: View {
    var text: String
    var color: Color

    var body: some View {
        Text(text)
            .padding()
            .background(color)
            .foregroundColor(color == .blue ? .white : .black)
            .cornerRadius(15)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: color == .blue ? .trailing : .leading)
    }
}
