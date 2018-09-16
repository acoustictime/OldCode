//
//  ImageCollectionViewCell.swift
//  SmashTag
//
//  Created by James Small on 3/30/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    public var imageURL: URL? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        if let url = imageURL {
            spinner.startAnimating()
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                
                
                let urlContents = try? Data(contentsOf: url)
                
                if let imageData = urlContents, url == self?.imageURL {
                    
                    DispatchQueue.main.async {
                        self?.imageView.image = UIImage(data: imageData)
                        self?.spinner?.stopAnimating()
                    }
                }
            }
            
        }
    }
    
}
