//
//  LocalStorage.swift
//  Air Scanner
//
//  Created by User on 05.05.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation

protocol LocalStorageType {
    var user: User? { get set }
}

final class LocalStorage: LocalStorageType {
    
    static let shared: LocalStorage = LocalStorage()
    
    private struct StorageKeys {
        static let USER_KEY = "USER_KEY"
    }
    
    var user: User? {
        get {
            UserDefaults.standard.data(forKey: StorageKeys.USER_KEY).flatMap { try? JSONDecoder().decode(User.self, from: $0) }
        }
        
        set {
            guard let data = newValue.flatMap({ try? JSONEncoder().encode($0) }) else {
                UserDefaults.standard.removeObject(forKey: StorageKeys.USER_KEY)
                return
            }
            UserDefaults.standard.set(data, forKey: StorageKeys.USER_KEY)
        }
    }
}
