//
//  ContentView.swift
//  Air Scanner
//
//  Created by User on 27.04.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI


struct MainView: View {
    @EnvironmentObject var auth: AppAuth
    @State private var selection = 0
   
    var body: some View {
        TabView(selection: $selection){
            Text("\(auth.user?.email ?? "default value")")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Home")
                    }
            }
            .tag(0)
            VStack{
                MapView()
                    .edgesIgnoringSafeArea(.top)
            }
            .tabItem {
                VStack {
                    Image("second")
                    Text("Map")
                }
            }
            .tag(1)
            Text("Third View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Notifications")
                    }
            }
            .tag(2)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
