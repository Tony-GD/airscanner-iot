//
//  LocalStorage.swift
//  Air Scanner
//
//  Created by User on 05.05.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation

class LocalStorageImpl: LocalStorage {
    
    private static let USER_KEY = "USER_KEY"
    
    func saveUser(user: User) {
        print("signed in \(user.email)")
        let defaults = UserDefaults.standard
        do {
            let encoded = try JSONEncoder().encode(user)
            let json = String(data: encoded, encoding: .utf8)
            print("save user \(json)")
            defaults.set(json, forKey: LocalStorageImpl.USER_KEY)
        } catch {
            print("save user error")
        }
        
        
    }
    
    func getUser() -> User {
        let defaults = UserDefaults.standard
        do {
            let encodedUser = defaults.string(forKey: LocalStorageImpl.USER_KEY)
            print("getUser \(encodedUser)")
            if let data = encodedUser?.data(using: .utf8) {
                return try JSONDecoder().decode(User.self, from: data)
            } else {
                print("get user else")
                return EmptyUser
            }
        } catch  {
            print("get user catch")
            return EmptyUser
        }
        
    }
    
    
}
