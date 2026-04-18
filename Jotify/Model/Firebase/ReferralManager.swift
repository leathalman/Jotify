//
//  ReferralManager.swift
//  Jotify
//
//  Created by Harrison Leath on 5/20/22.
//

import FirebaseAuth
import FirebaseFirestore

class ReferralManager {

    //should be created when a user's account is created
    func createReferralLink() {
        let uid = AuthManager().uid
        let referralURLString = "https://jotifyapp.com/?invitedby=\(uid)"

        User.settings?.referralLink = referralURLString

        DataManager.updateUserSettings(setting: "referralLink", value: referralURLString) { success in
            if !(success ?? false) {
                print("Error creating and uploading referralLink to firestore")
            }
        }
    }
    
    func grantReferralCredit(referrerId: String) {
        print("Adding referral credits")
        
        //update referral count for current user
        DataManager.updateUserSettings(setting: "referrals", value: (User.settings?.referrals ?? 0) + 1) { success in
            if !success! {
                print("Error granting referral credit")
            }
        }
        
        var referrerValue: Int = 0
        
        //get the value of the other user's setting
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(referrerId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                referrerValue = document.get("referrals") as? Int ?? 0
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
        
        //set the value of the other users' setting
        db.collection("users").document(referrerId).updateData([
            "referrals": referrerValue + 1,
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            }
        }
    }
    
}
