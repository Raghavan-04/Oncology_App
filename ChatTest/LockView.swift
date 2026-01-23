//
//  LockView.swift
//  ChatTest
//
//  Created by Raghavan on 29/09/24.
//

struct LockView: View {
    @EnvironmentObject var googleSignInManager: GoogleSignInManager

    var body: some View {
        VStack {
            if googleSignInManager.isSignedIn {
                NavigationLink(destination: HomeView()) {
                    Text("Continue to Home")
                }
            } else {
                Button(action: {
                    googleSignInManager.signIn()
                }) {
                    Text("Sign in with Google")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
}
