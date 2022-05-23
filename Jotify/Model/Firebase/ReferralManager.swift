//
//  ReferralManager.swift
//  Jotify
//
//  Created by Harrison Leath on 5/20/22.
//

import FirebaseAuth
import FirebaseDynamicLinks
import FirebaseFirestore

class ReferralManager {
    
    //should be created when a user's account is created
    func createReferralLink() {
        let uid = AuthManager().uid
        let link = URL(string: "https://jotifyapp.com/?invitedby=\(uid)")
        let referralLink = DynamicLinkComponents(link: link!, domainURIPrefix: "https://jotify.page.link")
        
        referralLink?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.austinleath.Jotify")
        referralLink?.iOSParameters?.minimumAppVersion = "2.0.0"
        referralLink?.iOSParameters?.appStoreID = "1469983730"
        
        referralLink?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.austinleath.Jotify")
        referralLink?.androidParameters?.minimumVersion = 1
                
        referralLink?.shorten { (shortURL, warnings, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            DataManager.updateUserSettings(setting: "referralLink", value: shortURL?.absoluteString ?? "") { success in
                if !success! {
                    print("Error creating and uploading referralLink to firestore")
                }
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
