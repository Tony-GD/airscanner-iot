//
//  WhirlyGlobeMapView.swift
//  Air Scanner
//
//  Created by User on 06.05.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation
import SwiftUI



struct WhirlyGlobeMapView : UIViewControllerRepresentable {
    
    private static var mapViewController: MapViewController? = nil
    
    var devices:[Device]
    var userLocation: Location?
    @Binding var moveToUserLocation: Bool
    
    func makeUIViewController(context: Context) -> MapViewController {
        
        // Workaround of the well known bug of SwiftUI. It recreates the VC every time we change the tab in TabView
        if WhirlyGlobeMapView.mapViewController == nil {
            let controller = MapViewController()
            controller.userLocation = userLocation
            WhirlyGlobeMapView.mapViewController = controller
        }
        
        return WhirlyGlobeMapView.mapViewController!
    }
    
    func updateUIViewController(_ uiViewController:  MapViewController, context: Context) {
        uiViewController.configure(with: devices)
        uiViewController.userLocation = userLocation
        if moveToUserLocation {
            uiViewController.moveToUserLocation()
            DispatchQueue.main.async {
                self.moveToUserLocation = false
            }
        }
    }
}


struct WhirlyGlobeMapView_Previews: PreviewProvider {
    @State static var moveToUserLocation: Bool = false
    static var previews: some View {
        WhirlyGlobeMapView(devices: [], userLocation: nil, moveToUserLocation: $moveToUserLocation)
    }
}
