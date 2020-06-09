//
//  LocalStorage.swift
//  Air Scanner
//
//  Created by User on 05.05.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation
import Combine

final class LocalStorage: ObservableObject {
    
    static let shared: LocalStorage = LocalStorage()
    
    private struct StorageKeys {
        static let USER_KEY = "USER_KEY"
        static let GREETING_KEY = "GREETING_KEY"
    }
    
    var user: User? {
        get {
            UserDefaults.standard.data(forKey: StorageKeys.USER_KEY).flatMap { try? JSONDecoder().decode(User.self, from: $0) }
        }
        
        set {
            objectWillChange.send()
            guard let data = newValue.flatMap({ try? JSONEncoder().encode($0) }) else {
                UserDefaults.standard.removeObject(forKey: StorageKeys.USER_KEY)
                return
            }
            UserDefaults.standard.set(data, forKey: StorageKeys.USER_KEY)
        }
    }
    
    var greetingShown: Bool {
        get {
            UserDefaults.standard.bool(forKey: StorageKeys.GREETING_KEY)
        }
        
        set {
            objectWillChange.send()
            UserDefaults.standard.set(newValue, forKey: StorageKeys.GREETING_KEY)
        }
    }
}
