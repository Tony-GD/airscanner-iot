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
    
    private var devices: [Device] = [] {
        didSet {
            DispatchQueue.main.async {
                self.updatePins()
            }
        }
    }
    
    private var trackerViews: [UIView] = []
    private var userLocationObject: MaplyComponentObject?
    
    var userLocation: Location? = nil {
        didSet {
            updateUserLocation()
        }
    }
    
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
        mapVC.animate(toPosition: userLocation.map { MaplyCoordinateMakeWithDegrees($0.lon, $0.lat) } ?? MaplyCoordinateMakeWithDegrees(-3.6704803, 40.5023056), time: 0.3)
    }
    
    func configure(with devices: [Device]) {
        self.devices = devices
    }
    
    func moveToUserLocation() {
        guard let location = userLocation else { return }
        mapVC.animate(toPosition: MaplyCoordinateMakeWithDegrees(location.lon, location.lat), time: 0.3)
    }
    
    private func updatePins() {
        trackerViews.forEach {
            self.mapVC.removeViewTrack(for: $0)
        }
        trackerViews.removeAll()
        let trackers:[MaplyViewTracker] = devices.map {
            let view = PinView(frame: CGRect(x: -18.0, y: -52.0, width: 36.0, height: 52.0))
            let tracker = MaplyViewTracker()
            tracker.loc = MaplyCoordinateMakeWithDegrees($0.location.lon, $0.location.lat)
            tracker.view = view
            return tracker
        }
        
        self.trackerViews = trackers.map(\.view)
        
        trackers.forEach { self.mapVC.add($0) }
    }
    
    private func updateUserLocation() {
        
        if let locationObject = self.userLocationObject {
            mapVC.remove([locationObject], mode: MaplyThreadCurrent)
        }
        
        guard let location = userLocation else {
            userLocationObject = nil
            return
        }
        
        let marker = MaplyScreenMarker()
        marker.size = CGSize(width: 22, height: 22)
        marker.image = #imageLiteral(resourceName: "location_pin")
        marker.loc = MaplyCoordinateMakeWithDegrees(location.lon, location.lat)
        self.userLocationObject = mapVC.addScreenMarkers([marker], desc: [:])
    }
}
