//
//  ImageScrollViewController.swift
//  SmashTag
//
//  Created by James Small on 3/29/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import UIKit

class ImageScrollViewController: UIViewController
{

    public var imageToDisplay: UIImage! {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    fileprivate var imageView = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.contentSize = imageView.frame.size
            
            
            
            scrollView.addSubview(imageView)

        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let scaleWidth = scrollView.bounds.size.width / imageView.bounds.size.width
        let scaleHeight = scrollView.bounds.size.height / imageView.bounds.size.height
        
        scrollView.minimumZoomScale = min(scaleWidth,scaleHeight)
        scrollView.maximumZoomScale = max(scaleWidth,scaleHeight)
        
        scrollView.zoomScale = max(scaleWidth,scaleHeight)
        
        scrollView.contentSize = imageView.frame.size
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    

}

// MARK: UIScrollViewDelegate
// Extension which makes ImageViewController conform to UIScrollViewDelegate
// Handles viewForZooming(in scrollView:)
// by returning the UIImageView as the view to transform when zooming
extension ImageScrollViewController : UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
