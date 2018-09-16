//
//  TweetDetailImageTableViewCell.swift
//  SmashTag
//
//  Created by James Small on 3/26/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import UIKit

struct imageData {
    var imageURL: URL
    var aspectRatio: Double
}

class TweetDetailImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetImage: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var tweetImageData: imageData? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        
        if let url = tweetImageData?.imageURL {
            
            spinner.startAnimating()
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            
                let urlContents = try? Data(contentsOf: url)
                
                if let imageData = urlContents, url == self?.tweetImageData?.imageURL {
                    
                    DispatchQueue.main.async {
                        self?.tweetImage?.image = UIImage(data: imageData)
                        self?.spinner?.stopAnimating()
                    }
                }
            }
 
        }
    }
    
    
  
}
