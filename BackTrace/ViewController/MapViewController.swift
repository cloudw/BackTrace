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

class MapViewController: UIViewController {
    let zoomLevel:Float = 14.6
    let mapView : GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 40.11, longitude: -88.23, zoom: 14.6)
        return GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
    }
}
