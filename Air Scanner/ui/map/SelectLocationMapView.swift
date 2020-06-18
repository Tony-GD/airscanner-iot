//
//  SelectLocationMapView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 18.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct SelectLocationMapView : UIViewControllerRepresentable {
    var userLocation: Location?
    @Binding var location: Location?
    
    func makeUIViewController(context: Context) -> MapViewController {
        let controller =  MapViewController()
        controller.userLocation = userLocation
        return controller
    }
    
    func updateUIViewController(_ uiViewController:  MapViewController, context: Context) {
        uiViewController.userLocation = userLocation
        uiViewController.allowLocationSelection = true
        uiViewController.configure(with: location)
        uiViewController.didSelectLocation = {
            self.location = $0
        }
    }
}
