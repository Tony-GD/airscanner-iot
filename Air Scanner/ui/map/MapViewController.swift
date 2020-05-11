//
//  MapViewController.swift
//  Air Scanner
//
//  Created by User on 08.05.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation
import UIKit
import WhirlyGlobe


class MapViewController: UIViewController {
    private var theViewC: MaplyBaseViewController?
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidLoad()
          print("map view did load")
//      // Create an empty globe and add it to the view
        theViewC = MaplyViewController(asFlatMap: ())
        self.view.addSubview(theViewC!.view)
      theViewC!.view.frame = self.view.bounds
      addChild(theViewC!)
        let globeViewC = theViewC as? WhirlyGlobeViewController
        let mapViewC = theViewC as? MaplyViewController
        theViewC!.clearColor = (globeViewC != nil) ? UIColor.black : UIColor.white

        // and thirty fps if we can get it ­ change this to 3 if you find your app is struggling
        theViewC!.frameInterval = 2

        // set up the data source
        let coordSystem = MaplySphericalMercator(webStandard: ())
 // add the capability to use the local tiles or remote tiles
        let useLocalTiles = false

        // we'll need this layer in a second
        let layer: MaplyQuadImageTilesLayer

        if useLocalTiles {
            guard let tileSource = MaplyMBTileSource(mbTiles: "geography-class_medres") else {
                // can't load local tile set
                print("Error")
                return
            }
            layer = MaplyQuadImageTilesLayer(coordSystem: coordSystem, tileSource: tileSource)!
        }
        else {
            // Because this is a remote tile set, we'll want a cache directory
            let baseCacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
            let tilesCacheDir = "\(baseCacheDir)/stamentiles/"
            let maxZoom = Int32(18)

            // Stamen Terrain Tiles, courtesy of Stamen Design under the Creative Commons Attribution License.
            // Data by OpenStreetMap under the Open Data Commons Open Database License.
            guard let tileSource = MaplyRemoteTileSource(
                    baseURL: "http://tile.stamen.com/terrain/",
                    ext: "png",
                    minZoom: 0,
                    maxZoom: maxZoom) else {
                // can't create remote tile source
                return
            }
            tileSource.cacheDir = tilesCacheDir
            layer = MaplyQuadImageTilesLayer(coordSystem: coordSystem, tileSource: tileSource)!
        }
        
        // start up over Madrid, center of the old-world
        if let globeViewC = globeViewC {
            globeViewC.add(layer)
            globeViewC.height = 0.8
            globeViewC.animate(toPosition: MaplyCoordinateMakeWithDegrees(-3.6704803, 40.5023056), time: 1.0)
        }
        else if let mapViewC = mapViewC {
            mapViewC.add(layer)
            mapViewC.height = 1.0
            mapViewC.animate(toPosition: MaplyCoordinateMakeWithDegrees(-3.6704803, 40.5023056), time: 1.0)
        }
        print("map did load")
    }
}
