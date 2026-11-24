//
//  DataManager.swift
//  Zurich
//
//  Created by Harrison Leath on 1/12/21.
//

import FirebaseFirestore

class DataManager {
    
    //create user settings in cloud
    static func createUserSettings(completionHandler: @escaping (Bool?) -> Void) {
        if AuthManager().uid.isEmpty { completionHandler(false); return }
        let db = Firestore.firestore()
        db.collection("users").document(AuthManager().uid).setData([
            "multilineInputEnabled": false,
            "deleteOldNotes": false,
            "useHaptics": true,
            "useBiometrics": false,
            "placeholder": "Start typing, or swipe right for your notes…",
            "defaultView": 0,
            "referrals": 0,
            "referralLink": "",
            "hasPremium": false
        ]) { (error) in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
                completionHandler(false)
            } else {
                print("User settings created successfully")
                completionHandler(true)
            }
        }
    }
    
    //reads the user settings in users -> user uid (fields)
    static func retrieveUserSettings(completionHandler: @escaping (Settings?, Bool?) -> Void) {
        if AuthManager().uid.isEmpty { completionHandler(nil, false); return }
        let db = Firestore.firestore()
        db.collection("users").document(AuthManager().uid).getDocument { (snapshot, error) in
            if let error = error {
                print("Error retrieving document: \(error.localizedDescription)")
                completionHandler(nil, false)
            } else {
                let settings = Settings(
                    multilineInputEnabled: snapshot?.get("multilineInputEnabled") as? Bool ?? false,
                    deleteOldNotes: snapshot?.get("deleteOldNotes") as? Bool ?? false,
                    useHaptics: snapshot?.get("useHaptics") as? Bool ?? true,
                    useBiometrics: snapshot?.get("useBiometrics") as? Bool ?? false,
                    placeholder: migratedPlaceholder(snapshot?.get("placeholder") as? String),
                    defaultView: snapshot?.get("defaultView") as? Int ?? 0, usePureDarkMode: snapshot?.get("usePureDarkMode") as? Bool ?? false,
                    referrals: snapshot?.get("referrals") as? Int ?? 0,
                    referralLink: snapshot?.get("referralLink") as? String ?? "",
                    hasPremium: snapshot?.get("hasPremium") as? Bool ?? false)
                completionHandler(settings, true)
            }
        }
    }
    
    /// The old default prompt pointed the wrong way and read awkwardly;
    /// swap it for the new default, but keep anything the user wrote.
    private static func migratedPlaceholder(_ stored: String?) -> String {
        let newDefault = "Start typing, or swipe right for your notes…"
        guard let stored, !stored.isEmpty,
              stored != "Tap to start typing or swipe left to right for saved notes..." else { return newDefault }
        return stored
    }

    //update the given setting with a value
    static func updateUserSettings(setting: String, value: Any, completionHandler: @escaping (Bool?) -> Void) {
        if AuthManager().uid.isEmpty { completionHandler(false); return }
        let db = Firestore.firestore()
        db.collection("users").document(AuthManager().uid).updateData([
            setting: value,
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
                completionHandler(false)
                return
            }
            completionHandler(true)
        }
    }
    
    //delete setting document attributed to currently logged in user
    static func deleteUserSettings(completionHandler: @escaping (Bool?) -> Void) {
        if AuthManager().uid.isEmpty { completionHandler(false); return }
        let db = Firestore.firestore()
        db.collection("users").document(AuthManager().uid).delete { (error) in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
    }
    
    //create note document with 2 fields, timestamp and content
    //returns documentID so doc can be updated immediately...
    @discardableResult static func createNote(content: String, timestamp: Double, color: String) -> String {
        if AuthManager().uid.isEmpty { return ""}
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("notes").document(AuthManager().uid).collection("userNotes").addDocument(data: [
            "content": content,
            "timestamp": timestamp,
            "color": color
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        return ref?.documentID ?? ""
    }
    
    //update the content (and timestamp) of a single document
    static func updateNoteContent(content: String, uid: String, completionHandler: @escaping (Bool?) -> Void) {
        if AuthManager().uid.isEmpty { completionHandler(false); return }
        let db = Firestore.firestore()
        db.collection("notes").document(AuthManager().uid).collection("userNotes").document(uid).updateData([
            "content": content,
            "timestamp": Date.timeIntervalSinceReferenceDate,
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
                completionHandler(false)
                return
            }
            completionHandler(true)
        }
    }
    
    //update color of a single document
    static func updateNoteColor(color: String, uid: String, completionHandler: @escaping (Bool?) -> Void) {
        if AuthManager().uid.isEmpty { completionHandler(false); return }
        let db = Firestore.firestore()
        db.collection("notes").document(AuthManager().uid).collection("userNotes").document(uid).updateData([
            "color": color,
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
                completionHandler(false)
                return
            }
            completionHandler(true)
        }
    }
    
    //update the value of reminder for note with uid
    static func updateNoteReminder(reminder: String, reminderTimestamp: Double, uid: String, completionHandler: @escaping (Bool?) -> Void) {
        if AuthManager().uid.isEmpty { completionHandler(false); return }
        let db = Firestore.firestore()
        db.collection("notes").document(AuthManager().uid).collection("userNotes").document(uid).updateData([
            "reminder": reminder,
            "reminderTimestamp": reminderTimestamp
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
                completionHandler(false)
                return
            }
            completionHandler(true)
        }
    }
    
    static func removeReminder(uid: String, completionHandler: @escaping (Bool?) -> Void) {
        if AuthManager().uid.isEmpty { completionHandler(false); return }
        let db = Firestore.firestore()
        db.collection("notes").document(AuthManager().uid).collection("userNotes").document(uid).updateData([
            "reminder": FieldValue.delete(),
            "reminderTimestamp": FieldValue.delete()
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
                completionHandler(false)
                return
            }
            completionHandler(true)
        }
    }

    
    //observe data change in notes -> user uid -> collection userNotes, and retrieve all notes in userNotes
    /// Returns the listener registration; the caller must keep it and call
    /// `remove()` when it no longer wants updates (e.g. on sign-out),
    /// otherwise Firestore keeps the listener, and everything its closure
    /// captures, alive for the life of the process.
    @discardableResult
    static func observeNoteChange(completionHandler: @escaping (NoteCollection?, Bool?) -> Void) -> ListenerRegistration? {
        if AuthManager().uid.isEmpty { return nil }
        let db = Firestore.firestore()
        let collection = NoteCollection()
        return db.collection("notes").document(AuthManager().uid).collection("userNotes").order(by: "timestamp", descending: false).addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshots: \(String(describing: error))")
                completionHandler(nil, false)
                return
            }
            snapshot.documentChanges.forEach { diff in
                let content = diff.document.get("content") as? String ?? ""
                let timestamp = diff.document.get("timestamp") as? Double ?? 0
                let id = diff.document.documentID
                let color = diff.document.get("color") as? String ?? ""
                let reminder = diff.document.get("reminder") as? String ?? ""
                let reminderTimestamp = diff.document.get("reminderTimestamp") as? Double ?? 0
                let note = FBNote(content: content, timestamp: timestamp, id: id, color: color, reminder: reminder, reminderTimestamp: reminderTimestamp)

                if (diff.type == .added) {
                    collection.FBNotes.insert(note, at: 0)
                }

                if (diff.type == .modified) {
                    if let noteIndex = collection.FBNotes.firstIndex(where: { $0.id == id}) {
                        collection.FBNotes.remove(at: noteIndex)
                        //could also just append to array normally since array is sorted below
                        collection.FBNotes.insert(note, at: 0)
                    }
                    collection.FBNotes.sort { ($0.timestamp) > ($1.timestamp) }
                }

                if (diff.type == .removed) {
                    collection.FBNotes = collection.FBNotes.filter {$0.id != diff.document.documentID }
                }
            }

            // Fire the completion once per snapshot, not once per document
            // change. The old code invoked it inside `forEach`, so the
            // initial snapshot with N notes produced N `reloadData()` calls
            // on the main thread — visible as a stagger on first paint and
            // a spike whenever multiple notes changed at once.
            completionHandler(collection, true)
        }
    }
    
    /// Deletes every note the signed-in user has on the server, in batches
    /// of up to 500 (Firestore's write-batch limit). Queries the server
    /// rather than trusting whatever the client has loaded, and calls the
    /// completion exactly once.
    static func deleteAllNotes(completionHandler: @escaping (Bool) -> Void) {
        let uid = AuthManager().uid
        if uid.isEmpty { completionHandler(false); return }
        let db = Firestore.firestore()
        let notes = db.collection("notes").document(uid).collection("userNotes")

        notes.limit(to: 500).getDocuments(source: .server) { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("Error listing notes to delete: \(String(describing: error))")
                completionHandler(false)
                return
            }
            if snapshot.documents.isEmpty {
                completionHandler(true)
                return
            }
            let batch = db.batch()
            snapshot.documents.forEach { batch.deleteDocument($0.reference) }
            batch.commit { error in
                if let error = error {
                    print("Error deleting notes: \(error)")
                    completionHandler(false)
                } else {
                    // Keep going until the collection is empty.
                    deleteAllNotes(completionHandler: completionHandler)
                }
            }
        }
    }

    //delete note document based on the documentID
    static func deleteNote(docID: String, completionHandler: @escaping (Bool?) -> Void) {
        if AuthManager().uid.isEmpty { completionHandler(false); return }
        let db = Firestore.firestore()
        db.collection("notes").document(AuthManager().uid).collection("userNotes").document(docID).delete { (error) in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
    }
}
