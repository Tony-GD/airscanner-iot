//
//  GatewayDetailsView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 22.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct DeviceMetricsView: View {
    var device: Device
    var body: some View {
        Group {
            if device.metrics.isEmpty {
                Text("No metrics available")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.secondaryText)
            } else {
                Text("Merics view here")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.secondaryText)
            }
        }
    }
}

struct DeviceDetailsCell: View {
    @ObservedObject var device: Device
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.inputBackground
            VStack(alignment: .leading, spacing: 5) {
                Text(device.displayName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                HStack(spacing: 8) {
                    Image("pin_icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 12)
                    Text(device.locationDescription)
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.6))
                }
            }
            .padding(16)
            VStack {
                Spacer()
                DeviceMetricsView(device: device)
            }
            .padding(16)
        }
        .frame(height: 176)
        .cornerRadius(4)
        .padding(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
    }
}

struct GatewayDetailsView: View {
    @EnvironmentObject private var storage: MapDevicesStorage
    var gateway: Gateway
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(self.storage.userDevices.filter { $0.gatewayId == self.gateway.id }.enumerated()), id: \.offset) { item in
                        NavigationLink(destination: DeviceDetailsView(device: item.element)) {
                           DeviceDetailsCell(device: item.element)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    Button(action: {
                        
                    }) {
                        HStack {
                            Spacer()
                            Text("+ Add device")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(20)
                    }
                    Spacer()
                }
                .frame(minHeight: proxy.size.height)
                .background(Color.background)
            }
        }
        .navigationBarTitle("\(gateway.name)")
        .navigationBarItems(trailing:
            Button(action: {}) {
                Image(systemName: "pencil")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }
        )
    }
}
