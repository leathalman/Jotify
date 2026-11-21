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
    
    /// Credits both the new user and the person who referred them.
    ///
    /// Uses `FieldValue.increment` so the server does the arithmetic. The old
    /// version read the referrer's count with an async `getDocument` but wrote
    /// `referrerValue + 1` before that read came back, so it always wrote 1
    /// and nobody could ever reach the 3 referrals needed for premium.
    func grantReferralCredit(referrerId: String) {
        guard !referrerId.isEmpty, referrerId != AuthManager().uid else { return }
        print("Adding referral credits")

        DataManager.updateUserSettings(setting: "referrals", value: FieldValue.increment(Int64(1))) { success in
            if success == true {
                User.settings?.referrals += 1
            } else {
                print("Error granting referral credit")
            }
        }

        Firestore.firestore().collection("users").document(referrerId).updateData([
            "referrals": FieldValue.increment(Int64(1)),
        ]) { error in
            if let error = error {
                print("Error crediting referrer: \(error)")
            }
        }
    }

}
