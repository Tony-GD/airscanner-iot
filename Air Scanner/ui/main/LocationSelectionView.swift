//
//  LocationSelectionView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 18.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct LocationSelectionView: View {
    
    @EnvironmentObject private var locationManager: LocationManager
    @State private var moveToUserLocation: Bool = false
    @Binding var location: Location?
    @Binding var isDisplayed: Bool
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            SelectLocationMapView(userLocation: locationManager.location, location: $location)
            if location != nil {
                VStack {
                    HStack {
                        Spacer()
                        Text("\(location!.lat) \(location!.lon)")
                            .padding()
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .background(Color.mainButton.opacity(0.3))
                            .cornerRadius(2)
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
            }
            
        }.navigationBarTitle("Location", displayMode: .inline)
    }
}
