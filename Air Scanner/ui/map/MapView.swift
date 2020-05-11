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
    func makeUIViewController(context: Context) -> MapViewController {
        return MapViewController()
    }
    
    func updateUIViewController(_ uiViewController:  MapViewController, context: Context) {
        
    }
   
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
