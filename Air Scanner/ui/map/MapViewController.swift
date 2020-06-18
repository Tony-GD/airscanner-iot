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
    
    private var trackerViews: [PinView] = []
    private var userLocationObject: MaplyComponentObject?
    private var pinTrackerView: UIImageView?
    
    private var filter: PublicMetric? = nil
    
    var userLocation: Location? = nil {
        didSet {
            updateUserLocation()
        }
    }
    
    var allowLocationSelection: Bool = false
    var didSelectLocation: ((Location?) -> ())?
    
    private lazy var mapVC: MaplyViewController = {
        let vc: MaplyViewController = MaplyViewController(asFlatMap: ())
        vc.clearColor = .white
        vc.frameInterval = 2
        vc.delegate = self
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
    
    func configure(with devices: [Device], filter: PublicMetric?) {
        self.filter = filter
        self.devices = devices
    }
    
    func configure(with pinLocation: Location?) {
        guard let location = pinLocation else { return }
        addLocationMarker(at: MaplyCoordinateMakeWithDegrees(location.lon, location.lat))
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
            view.configure(with: $0, displayedMetric: self.filter)
            let tracker = MaplyViewTracker()
            tracker.loc = MaplyCoordinateMakeWithDegrees($0.location.lon, $0.location.lat)
            tracker.view = view
            return tracker
        }
        
        self.trackerViews = trackers.map { $0.view as! PinView }
        
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
    
    private func addLocationMarker(at coord: MaplyCoordinate) {
        if let pinTrackerView = self.pinTrackerView {
            mapVC.removeViewTrack(for: pinTrackerView)
        }
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "pin_icon"))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.frame = CGRect(x: -22.0, y: -40.0, width: 44, height: 40)
        
        let tracker = MaplyViewTracker()
        tracker.loc = coord
        tracker.view = imageView
        pinTrackerView = imageView
        
        mapVC.add(tracker)
    }
}

extension Float {
    var radiansToDegrees: Float {
        self * 180.0 / .pi
    }
}

extension MaplyCoordinate {
    var location: Location {
        (lat: y.radiansToDegrees, lon: x.radiansToDegrees)
    }
}

extension MapViewController: MaplyViewControllerDelegate {
    func maplyViewController(_ viewC: MaplyViewController!, didTapAt coord: MaplyCoordinate) {
        guard allowLocationSelection else { return }
        addLocationMarker(at: coord)
        didSelectLocation?(coord.location)
    }
}
