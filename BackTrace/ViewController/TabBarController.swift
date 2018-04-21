//
//  TabViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/7/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class TabBarController : UITabBarController, CLLocationManagerDelegate {
    let journalTableViewController = JournalTableViewController()
    let locationTabelViewController = LocationTableViewController()
    let mapViewController = MapViewController()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        journalTableViewController.title = "Journal"
        journalTableViewController.tabBarItem = UITabBarItem(title: "Journal", image: #imageLiteral(resourceName: "book-simple-7"), tag: 0)

        locationTabelViewController.title = "Location"
        locationTabelViewController.tabBarItem = UITabBarItem(title: "Location", image: #imageLiteral(resourceName: "pin-map-7"), tag: 1)
        
        mapViewController.title = "Map"
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "earth-america-7"), tag: 2)
        
        viewControllers = [journalTableViewController, locationTabelViewController, mapViewController].map { UINavigationController(rootViewController: $0) }
        
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: mapViewController.zoomLevel)
        DataSource.currentLatitude = location.coordinate.latitude
        DataSource.currentLongtitude = location.coordinate.longitude
        if mapViewController.mapView.isHidden {
            mapViewController.mapView.isHidden = false
            mapViewController.mapView.camera = camera
        } else {
            mapViewController.mapView.animate(to: camera)
        }
        
    }
}
