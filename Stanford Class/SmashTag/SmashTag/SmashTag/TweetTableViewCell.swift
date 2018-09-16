//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by James Small on 3/21/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell
{
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        tweetProfileImageView.image = nil
        tweetUserLabel?.text = tweet?.user.description
        
        let myMutableString = NSMutableAttributedString(string: (tweet?.text)!)
        
        // user mentions blue
        for mention in (tweet?.userMentions)! {
            myMutableString.addAttribute(
                NSForegroundColorAttributeName,
                value: UIColor.orange,
                range: mention.nsrange)
        }
        // url mentions
        for mention in (tweet?.urls)! {
            myMutableString.addAttribute(
                NSForegroundColorAttributeName,
                value: UIColor.blue,
                range: mention.nsrange)
        }
        // hashtag mentions
        for mention in (tweet?.hashtags)! {
            myMutableString.addAttribute(
                NSForegroundColorAttributeName,
                value: UIColor.red,
                range: mention.nsrange)
        }

        tweetTextLabel?.attributedText = myMutableString
        
        if let profileImageURL = tweet?.user.profileImageURL {

            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                
                let urlContents = try? Data(contentsOf: profileImageURL)
                
                if let imageData = urlContents, profileImageURL == self?.tweet?.user.profileImageURL {
                    
                    DispatchQueue.main.async {
                        self?.tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
        
        

        
    }

}
