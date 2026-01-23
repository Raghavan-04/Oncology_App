//gives messages
//  ChatView.swift
//  ChatTest
//
//  Created by Raghavan on 17/09/24.
//

import SwiftUI

struct ChatView: View {
    @State private var messages = ["Hello!", "How can I assist you?"]
    @State private var messageText = ""
    @State private var selectedFileURL: URL?
    @State private var isFilePickerPresented = false
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages, id: \.self) { message in
                    MessageView(message: message, isCurrentUser: message.contains("[USER]"))
                }
            }
            .padding()
            
            HStack {
                TextField("Type a message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    sendMessage()
                }, label: {
                    Image(systemName: "paperplane.fill")
                })
            }
            .padding()
            
            Button(action: {
                // Trigger file sharing
                isFilePickerPresented = true
            }) {
                Image(systemName: "paperclip")
            }
            .sheet(isPresented: $isFilePickerPresented) {
                DocumentPickerView(selectedFileURL: $selectedFileURL)
            }
            
            if let fileURL = selectedFileURL {
                Text("Selected file: \(fileURL.lastPathComponent)")
                // Implement file upload logic here
            }
        }
    }
    
    func sendMessage() {
        messages.append("[USER]" + messageText)
        messageText = ""
    }
}
