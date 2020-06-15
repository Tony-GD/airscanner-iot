//
//  ContentView.swift
//  Air Scanner
//
//  Created by User on 27.04.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI


struct MainView: View {
    @EnvironmentObject var localStorage: LocalStorage
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection){
            MapView()
                .tabItem {
                    Image("map")
                }
                .tag(0)
            
            DevicesView()
                .tabItem {
                    Image("add")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Image("settings")
                }
                .tag(2)
        }
        .accentColor(.white)
        .background(Color.background)
        .overlay(
            ZStack {
                if !localStorage.greetingShown {
                    GreetingView()
                        .zIndex(0)
                        .transition(.opacity)
                }
            }
        )
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
