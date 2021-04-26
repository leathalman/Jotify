//
//  SignInWithApple+Firebase.swift
//  Jotify
//
//  Created by Harrison Leath on 4/5/21.
//

import CryptoKit
import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore

extension AuthenticationController: ASAuthorizationControllerDelegate {
    
    //nonce as required by Firebase
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    //methods used for sign in with apple workflow
    func presentSignInWithApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        //        request.requestedScopes = [.email]
        
        // Generate nonce for validation after authentication successful
        self.currentNonce = randomNonceString()
        // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
        request.nonce = sha256(currentNonce!)
        
        // Present Apple authorization form
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func createFirebaseUserFromAppleSignIn(credential: ASAuthorizationAppleIDCredential) {
        // Retrieve the secure nonce generated during Apple sign in
        guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        
        // Retrieve Apple identity token
        guard let appleIDToken = credential.identityToken else {
            print("Failed to fetch identity token")
            return
        }
        
        // Convert Apple identity token to string
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Failed to decode identity token")
            return
        }
        
        // Initialize a Firebase credential using secure nonce and Apple identity token
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
        
        // Sign in or create account with Firebase using Sign In with Apple
        Auth.auth().signIn(with: firebaseCredential) { (authResult, error) in
            if error != nil {
                print("Error occured with Sign In with Apple")
            }
            //change rootViewController to PageViewController w/ animation
            self.setRootViewController(duration: 0.2, vc: PageBoyController())
            
            let db = Firestore.firestore()
            db.collection("users").document(AuthManager().uid).getDocument { (snapshot, error ) in
                if (snapshot?.exists)! {
                    print("User Document exist")
                    //update user settings if it exists
                    User.updateSettings()
                } else {
                    print("User Document does not exist")
                    //create user settings if it doesn't exist
                    DataManager.createUserSettings { (success) in }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Save authorised user ID in userdefaults for future reference
            UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
            createFirebaseUserFromAppleSignIn(credential: appleIDCredential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}
