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
    
    private lazy var mapVC: MaplyViewController = {
        let vc: MaplyViewController = MaplyViewController(asFlatMap: ())
        vc.clearColor = .white
        vc.frameInterval = 2
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(mapVC)
        self.view.addSubview(mapVC.view)
        mapVC.view.clipToSuperview()
        
        let coordSystem = MaplySphericalMercator(webStandard: ())
        
        let baseCacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let tilesCacheDir = "\(baseCacheDir)/stamentiles/"
        let maxZoom = Int32(18)
        guard let tileSource = MaplyRemoteTileSource(
                baseURL: "http://tile.stamen.com/terrain/",
                ext: "png",
                minZoom: 0,
                maxZoom: maxZoom) else {
            return
        }
        
        tileSource.cacheDir = tilesCacheDir
        let layer = MaplyQuadImageTilesLayer(coordSystem: coordSystem, tileSource: tileSource)!
        mapVC.add(layer)
        
        mapVC.height = 1.0
        mapVC.animate(toPosition: MaplyCoordinateMakeWithDegrees(-3.6704803, 40.5023056), time: 1.0)
    }
}
