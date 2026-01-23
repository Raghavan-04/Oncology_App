// provides the message view
//  MessageView.swift
//  ChatTest
//
//  Created by Raghavan on 17/09/24.
//

import Foundation
import SwiftUI

struct MessageView: View {
    var message: String
    var isCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
                Text(message)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
            } else {
                Text(message)
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                Spacer()
            }
        }
    }
}
