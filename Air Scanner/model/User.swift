//
//  User.swift
//  Air Scanner
//
//  Created by User on 05.05.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation

struct User: Codable, Equatable {
    let id: String
    let idToken: String
    let givenName: String?
    let familyName: String?
    let email: String?
    let photoURL: URL?
    
    var fullName: String {
        return [givenName, familyName].compactMap { $0 }.joined(separator: " ")
    }
    
    var userName: String? {
        return email.map { "@" + $0.components(separatedBy: "@").first! }
    }
}
