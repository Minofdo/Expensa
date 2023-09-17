//
//  UserData.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-12.
//

import Foundation
import FirebaseDatabase

class UserData: ObservableObject {
    @Published var email :String?
    @Published var isFirstLogin :Bool?
    
    @Published var ref: DatabaseReference 
    
    // Entire dataset related to user
    @Published var dataSnapshot: DataSnapshot?
    
    init() {
        self.ref = Database.database(url: "https://expensa-e0ac6-default-rtdb.asia-southeast1.firebasedatabase.app").reference();
    }
    
    func loadDataForUser() {
        print("LOADING DATA")
        if var email = email {
            email = makeEmailFireStoreSafe(email)
            ref.child(email).getData(completion:  { error, snapshot in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return;
                }
                if let snapshot = snapshot {
                    print("DATA LOADED SUCCESSFULLY")
                    self.dataSnapshot = snapshot
                    print(snapshot)
                }
            });
        }
    }
    
    func makeEmailFireStoreSafe(_ email: String) -> String {
        let originalString = "example.email@example.com"
        let replacements = [".", "#", "$", "[", "]"]
        var result = email
        for replaceChar in replacements {
            result = result.replacingOccurrences(of: replaceChar, with: "_")
        }
        return result
    }
    
}
