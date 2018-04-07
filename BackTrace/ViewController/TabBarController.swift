//
//  TabViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/7/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

class TabBarController : UITabBarController {
    let mapViewController = MapViewController()
    let recordViewController = RecordViewController()
    
    override func viewDidLoad() {
        mapViewController.title = "Map"
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "earth-america-7"), tag: 0)
        
        recordViewController.title = "Records"
        recordViewController.tabBarItem = UITabBarItem(title: "Records", image: #imageLiteral(resourceName: "pin-map-7"), tag: 1)
        
        viewControllers = [mapViewController, recordViewController].map { UINavigationController(rootViewController: $0) }
    }
}
