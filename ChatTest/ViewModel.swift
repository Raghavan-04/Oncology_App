//
//  ViewModel.swift
//  ChatTest
//
//  Created by Raghavan on 18/09/24.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var welcomeText: String = ""
    @Published var showChatButton: Bool = false
    private var typingCompleted: Bool = false
    private let fullText = "Welcome to OncoChats AI Treatments"
    private let typingSpeed = 0.09  // Speed of typing effect

    func startTyping() {
        guard !typingCompleted else { return }
        
        var currentIndex = 0
        Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { timer in
            if currentIndex < self.fullText.count {
                let index = self.fullText.index(self.fullText.startIndex, offsetBy: currentIndex)
                self.welcomeText.append(self.fullText[index])
                currentIndex += 1
            } else {
                timer.invalidate()
                withAnimation {
                    self.showChatButton = true
                    self.typingCompleted = true
                }
            }
        }
    }
}
