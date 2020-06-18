//
//  AddGatewayRequest.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 17.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation

struct AddGatewayRequest: Encodable {
    var key: String
    var displayName: String
}
