//
//  AddDeviceRequest.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 18.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation

struct AddDeviceRequest: Encodable {
    let key: String
    let gatewayId: String
    let displayName: String
    let isPublic: Bool
    let locLat: Float
    let locLon: Float
    let dataFormat: DeviceDataFormat
    let locationDescription: String
}
