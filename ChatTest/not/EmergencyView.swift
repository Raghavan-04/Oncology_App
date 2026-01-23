//
//  provides emergency link
//EmergencyView.swift
//  ChatTest
//
//  Created by Raghavan on 18/09/24.
//
/*import SwiftUI

struct EmergencyView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Emergency")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                VStack(alignment: .leading, spacing: 15) {
                    Text("Contacts")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("• Ambulance: 911")
                }
                .padding(.horizontal, 20)
                
                Spacer()

                VStack(spacing: 15) {
                    Button(action: {
                        // Action to call emergency number
                        callEmergencyNumber()
                    }) {
                        Text("Call Ambulance")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Action to send alert
                        sendEmergencyAlert()
                    }) {
                        Text("Send Emergency Alert")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Function to handle calling emergency number
    private func callEmergencyNumber() {
        // Implement call functionality
        print("Calling emergency number...")
    }
    
    // Function to handle sending emergency alert
    private func sendEmergencyAlert() {
        // Implement alert functionality
        print("Sending emergency alert...")
    }
}

struct EmergencyView_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyView()
    }
}

  /*      NavigationLink(destination: EmergencyView()) {
VStack {
    Image(systemName: "phone.fill")
    Text("Emergency")
}
}
.padding(.horizontal, 10)*/

*/
