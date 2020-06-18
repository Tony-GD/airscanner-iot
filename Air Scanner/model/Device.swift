//
//  Device.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 15.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Combine

enum DeviceDataFormat: String, CaseIterable, Encodable {
    case json = "json"
    case singleValue = "single_value"
    
    var displayName: String {
        switch self {
        case .json:
            return "JSON Value"
        case .singleValue:
            return "Single Value"
        }
    }
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

struct MetricConfig {
    let metricKey: String
    let isPublic: Bool
}

struct Metric {
    let value: Double
    let lastUpdate: TimeInterval
}

func ==(lhs: Device, rhs: Device) -> Bool {
    lhs.id == rhs.id
}

final class Device: Hashable {
    let id: String
    let displayName: String
    let dataFormat: DeviceDataFormat
    let hasPublicMetrics: Bool
    let location: Location
    let publicMetrics: [PublicMetric]
    let config: [String: [MetricConfig]]
    @Published var metrics: [String: Metric] = [:]
    
    var listener: ListenerRegistration?
    
    deinit {
        listener?.remove()
        listener = nil
    }
    
    init?(id: String, data: [String: Any]) {
        guard let location = data["location"] as? GeoPoint,
            let dataFormat = (data["data_format"] as? String).flatMap(DeviceDataFormat.init) else { return nil }
        self.id = id
        self.displayName = data["display_name"] as? String ?? ""
        self.dataFormat = dataFormat
        self.hasPublicMetrics = data["hasPublicMetrics"] as? Bool ?? false
        self.location = (lat: Float(location.latitude), lon: Float(location.longitude))
        self.publicMetrics = (data["publicMetrics"] as? [String] ?? []).compactMap(PublicMetric.init)
        
        guard let metricsConfig = data["metricsConfig"] as? [String: Any] else {
            self.config = [:]
            return
        }
        
        var config: [String: [MetricConfig]] = [:]
        
        for (key, value) in metricsConfig {
            guard let json = value as? [String: Any],
                let metric = json["measurementType"] as? String else { continue }
            let isPublic = json["is_public"] as? Bool ?? false
            config[metric, default: []].append(MetricConfig(metricKey: key, isPublic: isPublic))
        }
        
        self.config = config
        self.listener = Firestore.firestore().collection("devices").document(id).collection("metrics").addSnapshotListener {[weak self] snapshot, _ in
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                let data = document.data()
                guard let value = data["value"] as? Double, let timestamp = (data["last_update"] as? String).flatMap({ Double($0) }) else { continue }
                let metric = Metric(value: value, lastUpdate: timestamp)
                self?.metrics[document.documentID] = metric
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func value(for publicMetric: PublicMetric, metrics: [String: Metric]) -> Double? {
        guard let metricConfigs = config[publicMetric.rawValue]?.filter({ $0.isPublic }) else { return nil }
        guard !metricConfigs.isEmpty else { return nil }
        
        let metric = metricConfigs.map(\.metricKey).compactMap { metrics[$0] }.sorted { $0.lastUpdate > $1.lastUpdate }.first
        return metric?.value
    }
}
