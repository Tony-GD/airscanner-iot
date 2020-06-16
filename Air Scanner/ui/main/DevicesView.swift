//
//  DevicesView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 09.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI


struct NewDeviceView: View {
    var body: some View {
        Text("Add new device form")
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
    
    @EnvironmentObject var localStorage: LocalStorage
    @State var objectType: Int = 0
    @State var gatewayState = GatewayState()
    
    var objectTypes = ["Device", "Gateway"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                VStack(spacing: 36) {
                    Picker(selection: $objectType, label: EmptyView()) {
                        ForEach(0..<objectTypes.count) {
                            Text(self.objectTypes[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    if objectType == 0 {
                        NewDeviceView()
                    } else {
                        NewGatewayView(state: $gatewayState)
                    }
                    Spacer()
                    VStack(spacing: 12) {
                        Button(action: {
                            
                        }) {
                            Text(objectType == 0 ? "Add device" : "Add gateway")
                        }
                        .buttonStyle(MainButtonStyle())
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            
                        }) {
                            Text("Cancel")
                        }
                        .buttonStyle(GhostButtonStyle())
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Add new")
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
