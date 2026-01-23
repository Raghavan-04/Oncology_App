//
//  BookAppointmentView.swift
//  ChatTest
//
//  Created by Raghavan on 18/10/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct BookAppointmentView: View {
    @State private var selectedDoctor: String = ""
    @State private var selectedDate = Date()
    @State private var showConfirmation = false
    @State private var bookingError = false
    
    let doctors = ["Dr. Smith", "Dr. Johnson", "Dr. Lee", "Dr. Patel","Dr. Sharan"]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    // Doctor Selection
                    Section(header: Text("Choose a Doctor")) {
                        Picker("Select Doctor", selection: $selectedDoctor) {
                            ForEach(doctors, id: \.self) { doctor in
                                Text(doctor)
                            }
                        }
                        .pickerStyle(MenuPickerStyle()) // Optional: Change the picker style
                    }
                    
                    // Date and Time Picker
                    Section(header: Text("Choose Date and Time")) {
                        DatePicker("Select Date", selection: $selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                }
                .navigationTitle("Book Appointment")
                
                // Book Button
                Button(action: {
                    bookAppointment()
                }) {
                    Text("Confirm Appointment")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .alert(isPresented: $showConfirmation) {
                    Alert(
                        title: Text("Appointment Confirmed"),
                        message: Text("Your appointment with \(selectedDoctor) is confirmed for \(formattedDate(selectedDate))"),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .alert(isPresented: $bookingError) {
                    Alert(
                        title: Text("Error"),
                        message: Text("There was an error booking your appointment. Please try again."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .padding(.top, 20)
            }
        }
    }
    
    // Function to book appointment and save it to Firestore
    func bookAppointment() {
        guard !selectedDoctor.isEmpty else {
            bookingError = true // Show error if no doctor is selected
            return
        }
        
        // Reference to Firestore
        let db = Firestore.firestore()
        let appointmentData: [String: Any] = [
            "doctor": selectedDoctor,
            "date": selectedDate,
            "userId": Auth.auth().currentUser?.uid ?? "Anonymous" // Use current user's UID
        ]
        
        // Add document to Firestore
        db.collection("appointments").addDocument(data: appointmentData) { error in
            if let error = error {
                print("Error saving appointment: \(error.localizedDescription)") // Print error to console
                bookingError = true // Show error alert
            } else {
                showConfirmation = true // Show confirmation alert
            }
        }
    }
    
    // Format the date for display
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// Preview provider for SwiftUI previews
struct BookAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        BookAppointmentView()
    }
}
