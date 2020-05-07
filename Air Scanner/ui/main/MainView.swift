//
//  ContentView.swift
//  Air Scanner
//
//  Created by User on 27.04.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI
import Mapbox

struct ContentView: View {
    @State private var selection = 0
    @State var annotations: [MGLPointAnnotation] = [
        MGLPointAnnotation(title: "Mapbox", coordinate: .init(latitude: 37.791434, longitude: -122.396267))
    ]
    
    var body: some View {
        TabView(selection: $selection){
            Text("First View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("First")
                    }
            }
            .tag(0)
            VStack{
                MapView(annotations: $annotations).centerCoordinate(.init(latitude: 37.791293, longitude: -122.396324)).zoomLevel(16)
            }
            .tabItem {
                VStack {
                    Image("seconf")
                    Text("Second")
                }
            }
            .tag(1)
            Text("Third View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Third")
                    }
            }
            .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
