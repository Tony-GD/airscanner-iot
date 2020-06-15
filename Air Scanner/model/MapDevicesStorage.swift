//
//  MapDevicesStorage.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 15.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation
import Combine
import FirebaseFirestore

final class MapDevicesStorage: ObservableObject {
    static let shared = MapDevicesStorage()
    @Published private var devices: [Device] = []
    @Published var filter: PublicMetric? = nil
    
    private var listener: ListenerRegistration?
    
    var filteredDevices: [Device] {
        guard let filter = filter else { return devices }
        return devices.filter { $0.publicMetrics.contains(filter) }
    }
    
    init() {
        subscribe()
    }
    
    deinit {
        unsubscribe()
    }
    
    func updateFilter(_ filter: PublicMetric?) {
        self.filter = filter
    }
    
    private func unsubscribe() {
        listener?.remove()
        listener = nil
    }
    
    private func subscribe() {
        listener = Firestore.firestore().collection("devices").whereField("hasPublicMetrics", isEqualTo: true).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            self.devices = snapshot.documents.compactMap {
                let data = $0.data()
                guard let location = data["location"] as? GeoPoint else { return nil }
                return Device(displayName: data["display_name"] as? String ?? "",
                              dataFormat: (data["data_format"] as? String).flatMap(DeviceDataFormat.init),
                              hasPublicMetrics: data["hasPublicMetrics"] as? Bool ?? false,
                              location: (lat: Float(location.latitude), lon: Float(location.longitude)),
                              publicMetrics: (data["publicMetrics"] as? [String] ?? []).compactMap(PublicMetric.init))
            }
        }
    }
}
