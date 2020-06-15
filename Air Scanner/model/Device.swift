//
//  Device.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 15.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation

enum DeviceDataFormat: String {
    case singleValue = "single_value"
    case json = "json"
}

typealias Location = (lat: Float, lon: Float)

enum PublicMetric: String, CaseIterable, Equatable {
    case co2 = "CO2"
    case humidity = "Humidity"
    case pm10 = "PM10"
    case pm1_0 = "PM1,0"
    case pm2_5 = "PM2,5"
    case temperature = "Temperature"
    
}

struct Device {
    let displayName: String
    let dataFormat: DeviceDataFormat?
    let hasPublicMetrics: Bool
    let location: Location
    let publicMetrics: [PublicMetric]
}
