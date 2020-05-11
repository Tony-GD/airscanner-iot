//
//  User.swift
//  Air Scanner
//
//  Created by User on 05.05.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation

struct User: Encodable, Decodable, Equatable {
    let id: String?
    let idToken: String?
    let givenName: String?
    let familyName: String?
    let email: String?
}

let EmptyUser = User(id: "", idToken: "", givenName: "", familyName: "", email: "")
