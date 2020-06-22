//
//  SettingsView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 09.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct SettingsGatewayCell: View {
    var gateway: Gateway
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color.mainButton)
                    .frame(width: 48, height: 48)
                Image("gateway")
                    .offset(x: 16, y: 0)
            }
            .padding(.horizontal, 11)
            Text(gateway.name)
                .font(.system(size: 14, weight: .bold))
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .padding(.trailing, 20)
        }
        .frame(height: 70)
        .background(Color.inputBackground)
        .cornerRadius(2)
        .foregroundColor(.white)
    }
}

struct SettingsDeviceCell: View {
    var device: Device
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color.mainButton)
                    .frame(width: 48, height: 48)
                Image("device")
                    .offset(x: 16, y: 0)
            }
            .padding(.horizontal, 11)
            VStack(alignment: .leading, spacing: 5) {
                Text(device.displayName)
                    .font(.system(size: 14, weight: .bold))
                Text(device.locationDescription)
                    .font(.system(size: 12))
                    .foregroundColor(.secondaryText)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .padding(.trailing, 20)
        }
        .frame(height: 70)
        .background(Color.inputBackground)
        .cornerRadius(2)
        .foregroundColor(.white)
    }
}

struct SettingsView: View {
    
    @EnvironmentObject var localStorage: LocalStorage
    @State private var askForLogout = false
    @State private var clasterizationIsOn = false
    @EnvironmentObject private var storage: MapDevicesStorage
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Color.background.edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading, spacing: 25) {
                    HStack(spacing: 15) {
                        RemoteImage(placeholder: Image(systemName: "person.fill"), url: localStorage.user?.photoURL)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .cornerRadius(30)
                        VStack(alignment: .leading) {
                            Text(localStorage.user?.fullName ?? "")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                            Text(localStorage.user?.userName ?? "")
                                .font(.system(size: 13))
                                .foregroundColor(.white)
                        }
                    }
                    
                    List {
                        ForEach(Array(storage.gateways.enumerated()), id: \.offset) { gateway in
                            ZStack {
                                SettingsGatewayCell(gateway: gateway.element)
                                NavigationLink(destination: GatewayDetailsView(gateway: gateway.element)) {
                                    EmptyView()
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.trailing, 20)
                            }
                            .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                        }
                        
                        ForEach(Array(storage.userDevices.filter{ $0.gatewayId.isEmpty }.enumerated()), id: \.offset) { device in
                            ZStack {
                                SettingsDeviceCell(device: device.element)
                                NavigationLink(destination: DeviceDetailsView(device: device.element)) {
                                    EmptyView()
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.trailing, 20)
                            }
                            .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                        }
                        Button(action: {
                            self.selectedTab = 1
                        }) {
                            HStack {
                                Spacer()
                                Text("+ Add new")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(20)
                        }
                        .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                    }
                    .background(Color.background)
                    
                    Toggle(isOn: $clasterizationIsOn) {
                        Text("Voronoi clasterization")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.white.opacity(0.6))
                    }
                    
                    HStack(spacing: 20) {
                        Button(action: { }) {
                            HStack(spacing: 15) {
                                Image("privacy")
                                Text("Privacy")
                                    .font(.system(size: 14))
                            }
                            .foregroundColor(.white)
                            .padding()
                        }
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        
                        Button(action: { self.askForLogout = true }) {
                            HStack(spacing: 15) {
                                Image("exit")
                                Text("Sign out")
                                    .font(.system(size: 14))
                            }
                            .foregroundColor(.white)
                            .padding()
                        }
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                    }
                    .background(Color.mainButton)
                    .cornerRadius(3)
                }
                .padding()
            }
            .navigationBarTitle("Settings")
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
        .alert(isPresented: $askForLogout) {
            return Alert(title: Text("Do you really want to sign out?"), message: nil, primaryButton: .cancel(), secondaryButton: .default(Text("Sign out"), action: {
                withAnimation {
                    Authentication.signOut()
                }
            }))
        }
    }
}
