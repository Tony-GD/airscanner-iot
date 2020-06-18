//
//  GatewayListView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 18.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct GatewayListCell: View {
    var gateway: Gateway?
    var selected: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 2.0)
                .frame(width: 16, height: 16)
                .overlay(
                    ZStack {
                        if selected {
                            RoundedRectangle(cornerRadius: 6)
                                .fill()
                                .frame(width: 12, height: 12)
                        }
                    }
            ).foregroundColor(.white)
            Text(gateway?.name ?? "None")
                .font(.system(size: 17))
                .foregroundColor(.white)
        }
        .padding()
    }
}

struct GatewayListView: View {
    @EnvironmentObject private var storage: MapDevicesStorage
    @Binding var isDisplayed: Bool
    @Binding var gateway: Gateway?
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            
            List {
                Button(action: {
                    self.gateway = nil
                    self.isDisplayed = false
                }) {
                    GatewayListCell(gateway: nil, selected: self.gateway == nil)
                }
                ForEach(Array(storage.gateways.enumerated()), id: \.offset) { item in
                    Button(action: {
                        self.gateway = item.element
                        self.isDisplayed = false
                    }) {
                        GatewayListCell(gateway: item.element, selected: item.element.id == self.gateway?.id)
                    }
                }
            }
        }.navigationBarTitle("Gateways", displayMode: .inline)
    }
}
