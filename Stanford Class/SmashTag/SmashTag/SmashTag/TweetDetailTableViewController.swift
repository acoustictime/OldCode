//
//  TweetDetailTableViewController.swift
//  SmashTag
//
//  Created by James Small on 3/25/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import UIKit
import Twitter

private struct tweetData {
    let description: String?
    let url: URL?
    let aspectRatio: Double?
    let section: String?
}

class TweetDetailTableViewController: UITableViewController {

    public var tweet : Twitter.Tweet? {
        didSet {
            // create data structure
            
            // media section
            if let media = tweet?.media, media.count > 0 {
                var mediaArray = [tweetData]()
                for mediaItem in media {
                    mediaArray.append(tweetData(description: mediaItem.url.description, url: mediaItem.url, aspectRatio: mediaItem.aspectRatio, section: "Images"))
                }
                data.append(mediaArray)
            }
            
            // Hashtags section
            if let hashTags = tweet?.hashtags, hashTags.count > 0 {
                var hashTagsArray = [tweetData]()
                for hashTagsItem in hashTags {
                    hashTagsArray.append(tweetData(description: hashTagsItem.keyword, url: nil, aspectRatio: nil, section: "HashTags"))
                }
                data.append(hashTagsArray)
            }
            
            // Users section
            if let users = tweet?.userMentions, users.count > 0 {
                var usersArray = [tweetData]()
                for userItems in users {
                    usersArray.append(tweetData(description: userItems.keyword, url: nil, aspectRatio: nil, section: "Users"))
                }
                data.append(usersArray)
                
            }
            
            // URLS section
            if let urls = tweet?.urls, urls.count > 0 {
                var urlsArray = [tweetData]()
                for urlItems in urls {
                    urlsArray.append(tweetData(description: urlItems.keyword, url: nil, aspectRatio: nil, section: "URLs"))
                }
                data.append(urlsArray)
                
            }
            
        }
    }

    
    // internal data structure
    private var data = [[tweetData]]()
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionArray = data[section]
        
        return sectionArray[0].section
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return data[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let rowSectionTitle = data[indexPath.section][indexPath.row].section {
            if rowSectionTitle == "Images" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
                
                if let tweetImageCell = cell as? TweetDetailImageTableViewCell {
                    
                    let tweetImageData = data[indexPath.section][indexPath.row]
                    
                    
                    
                    tweetImageCell.tweetImageData = imageData(imageURL: tweetImageData.url!, aspectRatio: tweetImageData.aspectRatio!)
                }
                
                
                return cell
            }
            
            if rowSectionTitle == "URLs" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "detailCellURL", for: indexPath)
                
                let tweetImageData = data[indexPath.section][indexPath.row]
                
                cell.textLabel?.text = tweetImageData.description
                
                
                return cell
            }
        }
        
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = data[indexPath.section][indexPath.row].description

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationViewController = segue.destination
        
        if let tweetTableViewController = destinationViewController as? TweetTableViewController,
            let identifier = segue.identifier {
            if identifier == "tweetDetailSearch" {
                if let searchTerm = sender as? UITableViewCell {
                    if let actualSearch = searchTerm.textLabel?.text  {
                        tweetTableViewController.searchText = actualSearch
                        
                    }
                }
            }
        }
        
        if let imageScrollViewController = destinationViewController as? ImageScrollViewController,
            let identifier = segue.identifier {
            if identifier == "imageScroll" {
                if let imageCell = sender as? TweetDetailImageTableViewCell {
                    if let tweetImageView = imageCell.tweetImage {
                        if let tweetImage = tweetImageView.image {
                            imageScrollViewController.imageToDisplay = tweetImage
                        }
                    }
                    
                }
            }
        }
        
        if let webViewController = destinationViewController as? WebViewController,
            let identifier = segue.identifier {
            if identifier == "tweetURL" {

                if let searchTerm = sender as? UITableViewCell {
                    if let actualSearch = searchTerm.textLabel?.text  {
                        webViewController.url = URL(string: actualSearch)
                        
                    }
                }
                
                
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let rowSectionTitle = data[indexPath.section][indexPath.row].section {
            if rowSectionTitle == "Images" {
                
                let tweet = data[indexPath.section][indexPath.row]
             
                
                
               return view.bounds.width / CGFloat(tweet.aspectRatio!)
            }
        }
        
        return UITableViewAutomaticDimension
        
    }
}
