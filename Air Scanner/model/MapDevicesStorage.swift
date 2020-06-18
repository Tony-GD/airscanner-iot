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
    @Published private var userDevices: [Device] = []
    @Published var gateways: [Gateway] = []
    @Published var filter: PublicMetric? = nil
    
    private var publicDevicesListener: ListenerRegistration?
    private var gatewaysListener: ListenerRegistration?
    private var userDevicesListener: ListenerRegistration?
    
    var filteredDevices: [Device] {
        let uniqueDevices = Array(Set(devices + userDevices))
        guard let filter = filter else { return uniqueDevices }
        return uniqueDevices.filter { $0.publicMetrics.contains(filter) }
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
        devices = []
        publicDevicesListener?.remove()
        publicDevicesListener = nil
        unsubscribeFormUserSpecifcInfo()
    }
    
    func unsubscribeFormUserSpecifcInfo() {
        gateways = []
        userDevices = []
        gatewaysListener?.remove()
        gatewaysListener = nil
        
        userDevicesListener?.remove()
        userDevicesListener = nil
    }
    
    func subscribeForUserSpecificInfo() {
        guard let userId = LocalStorage.shared.user?.id else { return }
        gatewaysListener?.remove()
        gatewaysListener = Firestore.firestore().collection("gateways").whereField("user_id", isEqualTo: userId).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            self.gateways = snapshot.documents.compactMap { Gateway(id: $0.documentID, data: $0.data()) }
        }
        
        userDevicesListener = Firestore.firestore().collection("devices").whereField("user_id", isEqualTo: userId).addSnapshotListener{ snapshot, error in
            guard let snapshot = snapshot else { return }
            self.userDevices = snapshot.documents.compactMap { Device(id: $0.documentID, data: $0.data())  }
        }
    }
    
    private func subscribe() {
        publicDevicesListener = Firestore.firestore().collection("devices").whereField("hasPublicMetrics", isEqualTo: true).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            self.devices = snapshot.documents.compactMap { Device(id: $0.documentID, data: $0.data())  }
        }
        subscribeForUserSpecificInfo()
    }
}
