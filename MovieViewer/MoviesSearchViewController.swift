//
//  MoviesSearchViewController.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 7/7/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit
import MBProgressHUD

class MoviesSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var searchBar = UISearchBar()
    var noDataLabel: UILabel!
    var searchMovieSettings = SearchMovieSettings()
    var movies: [Movie]? {
        didSet {
            
            filteredMovies = movies
        }
    }
    var filteredMovies: [Movie]?
    var isMoreDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set delegate
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        // init UI theme
        setTheme()
        hideError()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "filtersSegue" {
            // we wrapped our FiltersViewController inside a UINavigationController
            let navController = segue.destinationViewController as! UINavigationController
            let filtersView = navController.topViewController as! FiltersViewController
            filtersView.settings = self.searchMovieSettings
        }
        
        if let cell = sender as? UITableViewCell {
            let indexPath = tableView.indexPathForCell(cell)
            let movie = filteredMovies![indexPath!.row]
            let movieDetailView = segue.destinationViewController as! MovieDetailViewController
            movieDetailView.movie = movie
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var numOfSection = 0
        if let filteredMovies = filteredMovies {
            if filteredMovies.count > 0 {
                tableView.separatorStyle = .SingleLine
                numOfSection = 1
                tableView.backgroundView = nil
            } else {
                tableView.backgroundView = noDataLabel
                tableView.separatorStyle = .None
            }
        }
        
        return numOfSection
    }
    
    @IBAction func didSaveSettings(segue: UIStoryboardSegue) {
        
        let filtersView = segue.sourceViewController as! FiltersViewController
        searchMovieSettings = filtersView.settings
        searchMovies()
    }
    
    @IBAction func didCancelSettingChanges(segue: UIStoryboardSegue) {
        
        // in this case, do nothing
    }
    
    func hideError() {
        
        errorView.hidden = true
    }
    
    func showError(error: NSError) {
        
        errorLabel.text = error.localizedDescription
        errorView.hidden = false
    }
    
    func searchMovies() {
        
        // reset table data and page index
        searchMovieSettings.page = 1
        // load movies according to search settings
        loadMovies(false)
    }
    
    func loadMoreMovies() {
        
        // increase page index
        searchMovieSettings.page += 1
        // load movies according to search settings
        loadMovies(true)
    }
    
    func loadMovies(loadMore: Bool) {
        
        hideError()
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        TMDBClient.searchMovies(searchMovieSettings) { (movies, error) in
            
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            // turn off data loading flag
            self.isMoreDataLoading = false
            
            guard error == nil else {
                // reset table data and page index
                self.movies?.removeAll()
                self.searchMovieSettings.page = 1
                self.tableView.reloadData()
                // show error
                self.showError(error!)
                return
            }
            
            // case load more data
            if loadMore {
                self.movies! += movies!
                self.tableView.reloadData()
            // case newly search
            } else {
                self.movies = movies
                self.tableView.reloadData()
                // scroll to top row
                if movies?.count > 0 {
                    self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
                }
            }
        }
    }
    
    func setTheme() {
        
        tableView.backgroundColor = UIColor.blackColor()
        // remove showing empty row for table incase network error
        tableView.tableFooterView = UIView()
        
        searchBar.tintColor = themeColor
        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = themeColor
        searchBar.keyboardAppearance = .Dark
        
        errorView.backgroundColor = UIColor.whiteColor()
        errorView.alpha = 0.8
        errorLabel.textColor = UIColor.redColor()
        
        noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text = "no results found"
        noDataLabel.textColor = UIColor.whiteColor()
        noDataLabel.textAlignment = .Center
    }
}

extension MoviesSearchViewController: UITableViewDataSource {
    
    // Tells the data source to return the number of rows in a given section of a table view.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredMovies?.count ?? 0
    }
    
    // Asks the data source for a cell to insert in a particular location of the table view.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = filteredMovies![indexPath.row]
        cell.setData(movie)
        cell.setTheme()
        
        return cell
    }
    
    // Asks the delegate for the actions to display in response to a swipe in the specified row.
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        // setup favorite action
        let isFavorited = filteredMovies![indexPath.row].isFavorited
        let actionTitle = isFavorited ? "Unfavorite" : "Favorite"
        let favoriteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: actionTitle, handler: { (action: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            
            self.filteredMovies![indexPath.row].isFavorited = !isFavorited
            // reload row style
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
            // dismiss cell actions
            tableView.editing = false
        })
        favoriteAction.backgroundColor = UIColor.darkGrayColor()
        
        // setup share action
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share" , handler: { (action: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            
            let shareMenu = UIAlertController(title: nil, message: "Share your Movie", preferredStyle: .ActionSheet)
            let twitterAction = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.Default, handler: nil)
            let facebookAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.Default, handler: nil)
            let moreAction = UIAlertAction(title: "More", style: UIAlertActionStyle.Default, handler: nil)
            let doneAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.Cancel, handler: { (action) in
                
                // // dimiss cell actions
                tableView.editing = false
            })
            
            shareMenu.addAction(twitterAction)
            shareMenu.addAction(facebookAction)
            shareMenu.addAction(moreAction)
            shareMenu.addAction(doneAction)
            self.presentViewController(shareMenu, animated: true, completion: nil)
        })
        shareAction.backgroundColor = UIColor.lightGrayColor()
        
        return [shareAction, favoriteAction]
    }
}

extension MoviesSearchViewController: UITableViewDelegate {
    
    // Tells the delegate that the specified row is now selected.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// SearchBar methods
extension MoviesSearchViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchMovieSettings.query = searchBar.text!
        searchBar.resignFirstResponder()
        searchMovies()
    }
}

// Support infinity data loading
extension MoviesSearchViewController: UIScrollViewDelegate {

    // Tells the delegate when the user scrolls the content view within the receiver.
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if !isMoreDataLoading {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                // turn on data loading flag
                isMoreDataLoading = true
                // load more movie
                loadMoreMovies()
            }
        }
    }
}
