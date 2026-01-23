import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var isSignUp: Bool = false
    @State private var isLoading: Bool = false // Loading state

    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "message.fill") // Placeholder for your logo
                    .font(.system(size: 80))
                    .padding(.top, 40)

                Text(isSignUp ? "Create Account" : "Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)

                Spacer()

                // Email TextField
                TextField("Email", text: $email)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Password SecureField
                SecureField("Password", text: $password)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Login/Sign Up Button
                Button(action: {
                    isLoading = true // Start loading
                    if isSignUp {
                        registerUser()
                    } else {
                        authenticateUser()
                    }
                }) {
                    Text(isSignUp ? "Sign Up" : "Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                .padding(.horizontal)

                // Loading Indicator
                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                }

                Spacer()

                // Toggle between Login and Sign Up
                Button(action: {
                    isSignUp.toggle()
                }) {
                    Text(isSignUp ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                        .font(.footnote)
                }
                .padding(.bottom, 40)

                // Forgot Password Button
                Button(action: {
                    // Action for forgot password
                }) {
                    Text("Forgot your password?")
                        .foregroundColor(.blue)
                        .font(.footnote)
                }
                .padding(.bottom, 40)

            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .background(Color.white.ignoresSafeArea())
            .navigationTitle("")
            .navigationBarHidden(true)
            .background(
                NavigationLink(destination: HomeView(), isActive: $isLoggedIn) { EmptyView() }
            )
        }
    }

    // Function to authenticate user
    private func authenticateUser() {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please enter both email and password."
            showAlert = true
            isLoading = false // Stop loading
            return
        }

        // Firebase authentication logic
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                isLoading = false // Stop loading
                if let error = error {
                    errorMessage = error.localizedDescription
                    showAlert = true
                } else {
                    isLoggedIn = true // Navigate to HomeView on successful login
                }
            }
        }
    }

    // Function to register user
    private func registerUser() {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please fill in all fields."
            showAlert = true
            isLoading = false // Stop loading
            return
        }

        // Register the user with Firebase
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                isLoading = false // Stop loading
                if let error = error {
                    errorMessage = error.localizedDescription
                    showAlert = true
                } else {
                    errorMessage = "Registration successful! You can now log in."
                    showAlert = true
                    isSignUp = false // Switch back to login mode after sign up
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false))
    }
}

