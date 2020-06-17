//
//  DevicesView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 09.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI


struct DeviceState {
    var name: String = ""
    var description: String = ""
    var gateway: Gateway? = nil
    var location: Location? = nil
    var dataFormatIndex: Int = 0
    
    var locationDescription: String {
        get { location.map { ["\($0.lat)", "\($0.lon)"].joined(separator: " ") } ?? "" }
        set {  }
    }
    
    var dataFormat: DeviceDataFormat {
        DeviceDataFormat.allCases[dataFormatIndex]
    }
}

struct NewDeviceView: View {
    @Binding var state: DeviceState
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Device's name")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                TextField("Type name...", text: $state.name)
                    .textFieldStyle(MainTextFieldStyle())
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("Description")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                TextField("Type description...", text: $state.description)
                    .textFieldStyle(MainTextFieldStyle())
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Gateway")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                Button(action: {}) {
                    Text(state.gateway != nil ? state.gateway!.name : "Gateway")
                }
                .buttonStyle(DisclosureButtonStyle(direction: .down))
                .foregroundColor(.inputBackground)
                .frame(height: 36.0)
                .frame(maxWidth: .infinity)
            }
            
            if state.gateway == nil {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Key")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    Button(action: {}) {
                        Text("Scan the QR code")
                    }
                    .buttonStyle(DisclosureButtonStyle())
                    .foregroundColor(.inputBackground)
                    .frame(height: 36.0)
                    .frame(maxWidth: .infinity)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Location")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                Button(action: {}) {
                    HStack(spacing: 0) {
                        TextField("Select your location", text: $state.locationDescription)
                            .textFieldStyle(MainTextFieldStyle())
                        Image("pin_icon")
                            .foregroundColor(.white)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Data format")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                Picker(selection: $state.dataFormatIndex, label: EmptyView()) {
                    ForEach(0..<DeviceDataFormat.allCases.count) {
                        Text(DeviceDataFormat.allCases[$0].displayName).frame(height: 80)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}

struct GatewayState {
    var name: String = ""
}

struct NewGatewayView: View {
    
    @Binding var state: GatewayState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Gateway's name")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                TextField("Type name...", text: $state.name)
                    .textFieldStyle(MainTextFieldStyle())
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("Key")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                Button(action: {}) {
                    Text("Scan the QR code")
                }
                .buttonStyle(DisclosureButtonStyle())
                .foregroundColor(.inputBackground)
                .frame(height: 36.0)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct DevicesView: View {
    
    @EnvironmentObject private var localStorage: LocalStorage
    @State private var objectType: Int = 0
    @State private var gatewayState = GatewayState()
    @State private var deviceState = DeviceState()
    
    var objectTypes = ["Device", "Gateway"]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Color.background.edgesIgnoringSafeArea(.all)
                VStack(spacing: 36) {
                    Picker(selection: $objectType, label: EmptyView()) {
                        ForEach(0..<objectTypes.count) {
                            Text(self.objectTypes[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    if objectType == 0 {
                        NewDeviceView(state: $deviceState)
                    } else {
                        NewGatewayView(state: $gatewayState)
                    }
                }
                .padding()
                VStack {
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Text(objectType == 0 ? "Add device" : "Add gateway")
                    }
                    .buttonStyle(MainButtonStyle())
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                }
                .padding()
            }.navigationBarTitle("Add new")
        }
        .overlay(
            ZStack {
                if localStorage.user == nil {
                    LoginView()
                        .transition(.opacity)
                        .zIndex(0)
                }
            }
        )
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
    }
}
