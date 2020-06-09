//
//  MapView.swift
//  Air Scanner
//
//  Created by User on 06.05.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation
import SwiftUI
import WhirlyGlobe



struct MapView : UIViewControllerRepresentable {
    
    private static var mapViewController: MapViewController? = nil
    
    func makeUIViewController(context: Context) -> MapViewController {
        
        // Workaround of the well known bug of SwiftUI. It recreates the VC every time we change the tab in TabView
        if MapView.mapViewController == nil {
            MapView.mapViewController = MapViewController()
        }
        
        return MapView.mapViewController!
    }
    
    func updateUIViewController(_ uiViewController:  MapViewController, context: Context) {
        
    }
   
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
