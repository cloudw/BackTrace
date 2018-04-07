//
//  ViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/2/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let zoomLevel:Float = 14.6
    let mapView : GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 40.11, longitude: -88.23, zoom: 14.6)
        return GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
    }
    
}
