//
//  DatabaseManager.swift
//  Messenger
//
//  Created by 郭丰锐 on 2020/12/23.
//

import Foundation
import FirebaseDatabase
let str = "https://messenger-f2ab3-default-rtdb.firebaseio.com/"
final class DatabaseManager {
    static let shared = DatabaseManager()
    
    let ref: DatabaseReference = Database.database().reference(fromURL: "https://messenger-f2ab3-default-rtdb.firebaseio.com")
    
}

extension DatabaseManager {
    
    public func userExists(with email: String, complete: @escaping((Bool) -> Void)) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        ref.child(safeEmail).observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.value as? String != nil else {
                complete(false)
                return
            }
            complete(true)
        }
    }
    
    public func insertUser(with user: ChatAppUser) {
        ref.child(user.safeMail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
        
    }
}

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let email: String
    var safeMail: String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
