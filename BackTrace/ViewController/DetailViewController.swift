//
//  DetailViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/29/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

class DetailViewController : UITableViewController {
    // Adapted from https://stackoverflow.com/questions/34694377/swift-how-can-i-make-an-image-full-screen-when-clicked-and-then-original-size by vacawama@StackOverflow
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let imageViewController = FullScreenImageViewController(image: imageView.image)
        navigationController?.pushViewController(imageViewController, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
}
