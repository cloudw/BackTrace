//
//  FullScreenImageViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/29/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

class FullScreenImageViewController : UIViewController, UIScrollViewDelegate {
    let imageView : UIImageView
    let scrollView = UIScrollView()
    
    init(image: UIImage?){
        imageView = UIImageView(image: image)
        imageView.frame = UIScreen.main.bounds
        imageView.contentMode = .scaleAspectFit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = scrollView
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.popFullScreenView)))

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.delegate = self
        scrollView.addSubview(imageView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc private func popFullScreenView() {
        navigationController?.popViewController(animated: false)
    }
}
