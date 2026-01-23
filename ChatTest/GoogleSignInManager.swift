//
//  GoogleSignInManager.swift
//  ChatTest
//
//  Created by Raghavan on 29/09/24.
//

import Firebase
import GoogleSignIn
import SwiftUI

class GoogleSignInManager: ObservableObject {
    @Published var isSignedIn = false

    func signIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(with: config, presenting: UIApplication.shared.windows.first?.rootViewController) { user, error in
            if let error = error {
                print("Sign-in failed: \(error)")
                return
            }

            guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase Sign-in failed: \(error)")
                } else {
                    self.isSignedIn = true
                }
            }
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
        self.isSignedIn = false
    }
}
