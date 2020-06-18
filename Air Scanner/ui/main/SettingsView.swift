//
//  SettingsView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 09.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var localStorage: LocalStorage
    @State private var askForLogout = false
    @State private var clasterizationIsOn = false
    
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
                    Spacer()
                    
                    
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
