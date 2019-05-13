//
//  LoginController+handlers.swift
//  Login Screen
//
//  Created by Harrison Leath on 2/23/18.
//  Copyright © 2018 Harrison Leath. All rights reserved.
//
import UIKit
import Firebase
import Photos

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text
            else {
                print("Form is not valid!")
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                print("Create User Error")
                return
            }
            
            guard (user?.user.uid) != nil else {
                return
            }
            
            //successfully authenticated user
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_Images").child("\(imageName).png")
            
            //use JPEG compression to help load times for profile pictures
            //WILL CRASH APP IF NO IMAGE IS AVAILABLE: using !
            if let uploadData = self.profileImageView.image!.jpegData(compressionQuality: 0.1) {
                
                let uid = user?.user.uid
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error as Any)
                        return
                    }
                    
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            print(error)
                        } else {
                            let profileImageUrl = url?.absoluteString
                            let values = ["profileImageUrl": profileImageUrl]
                            self.registerUerIntoDatabaseWithUID(uid: uid!, values: values as [String : AnyObject])
                            print(profileImageUrl ?? "profile url")
                        }
                    }
                    let values = ["name":name, "email": email]
                    self.registerUerIntoDatabaseWithUID(uid: uid!, values: values as [String : AnyObject])
                    
                })
            }
        }
    }
    
    private func registerUerIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        //insert your own database reference source here
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (error2, ref) in
            
            if error2 != nil {
                print("error2")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            print("Saved User successfully into firebase")
        })
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized: print("Access is granted by user")
        case .notDetermined: PHPhotoLibrary.requestAuthorization({
            (newStatus) in
            print("status is \(newStatus)")
            if newStatus == PHAuthorizationStatus.authorized { print("success") }
        })
        case .restricted: print("User do not have access to photo album.")
        case .denied: print("User has denied the permission.")
        @unknown default:
            print("Photo access switch failed")
        }
    }
    
    @objc func handleSelectProfileImageView(_ sender: UITapGestureRecognizer) {
        
        checkPermission()
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled picker")
        dismiss(animated: true, completion: nil)
    }
    
}
