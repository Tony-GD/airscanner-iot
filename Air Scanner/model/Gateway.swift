//
//  Gateway.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 17.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation

struct Gateway {
    let id: String
    let name: String
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.name = data["display_name"] as? String ?? ""
    }
}
