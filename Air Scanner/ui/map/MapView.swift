//
//  MapView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 15.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct MapView: View {
    @EnvironmentObject private var storage: MapDevicesStorage
    @EnvironmentObject private var locationManager: LocationManager
    @State private var moveToUserLocation: Bool = false
    @State private var showFilters: Bool = false
    var body: some View {
        ZStack(alignment: .topLeading) {
            WhirlyGlobeMapView(devices: storage.filteredDevices,
                               userLocation: locationManager.location,
                               filter: storage.filter,
                               moveToUserLocation: $moveToUserLocation)
                .edgesIgnoringSafeArea(.top)
                .zIndex(0)
            HStack {
                Button(action: {
                    withAnimation {
                        self.showFilters = true
                    }
                }) { Image("filters").padding() }
                Spacer()
                Button(action: {
                    self.moveToUserLocation = true
                }) { Image("location").padding() }
            }
            .zIndex(1)
            
            if showFilters {
                Color
                    .black
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(2)
                    .transition(.opacity).onTapGesture {
                        withAnimation {
                            self.showFilters = false
                        }
                    }
                
                FiltersView(showFilters: $showFilters)
                    .frame(width: 200)
                    .zIndex(3)
                    .transition(.move(edge: .leading))
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
