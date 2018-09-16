//
//  ResultsTableViewController.swift
//  SmashTag
//
//  Created by James Small on 3/22/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import UIKit
import CoreData

class RecentsTableViewController: UITableViewController {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    // my data source
    var searchResultsData: [[String: String]]?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAndReloadTable()
        
    }
    
    private func getAndReloadTable() {
        searchResultsData = TweetSearchResults().tweetSearchResultsArray
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if let searchResultsData = searchResultsData {
            return searchResultsData.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearch", for: indexPath)

        // Configure the cell...
        
         let searchData = searchResultsData?[indexPath.row]

        cell.textLabel?.text = searchData?.first?.key
        cell.detailTextLabel?.text = searchData?.first?.value
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationViewController = segue.destination
        
        if let tweetTableViewController = destinationViewController as? TweetTableViewController,
            let identifier = segue.identifier {
            if identifier == "recentsSearchSegue" {
                if let searchTerm = sender as? UITableViewCell {
                    if let actualSearch = searchTerm.textLabel?.text  {
                        tweetTableViewController.searchText = actualSearch
                    }
                }
            }
        }
        
        if segue.identifier == "popularitySegue" {
            if let popularityTVC = segue.destination as? PopularityTableViewController {
                if let mentionRow = sender as? IndexPath {
                    
                   let mentionRowData = searchResultsData?[mentionRow.row]
                        popularityTVC.mention = mentionRowData?.first?.key
                        popularityTVC.container = container
                    
                }
            }
        }
    }

    @IBAction func clearRecentSearchs(_ sender: UIBarButtonItem) {
        let tweetSearchResultSaver = TweetSearchResults()
        tweetSearchResultSaver.clearRecentTweetSearches()
        searchResultsData = TweetSearchResults().tweetSearchResultsArray
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            searchResultsData?.remove(at: indexPath.row)
            let tweetSearchResultSaver = TweetSearchResults()
            tweetSearchResultSaver.updateRecentTweetSearchesArray(searchResultsData!)
            getAndReloadTable()
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {

        performSegue(withIdentifier: "popularitySegue", sender: indexPath)        
    }
  
}
