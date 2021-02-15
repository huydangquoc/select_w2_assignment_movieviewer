//
//  MoviesSearchViewController.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 7/7/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit
import MBProgressHUD
import Social
import MGSwipeTableCell

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
            favoriteProvider.populateData((filteredMovies?.movieIds())!)
        }
    }
    var filteredMovies: [Movie]?
    var isMoreDataLoading = false
    var favoriteProvider = FirebaseFavoriteProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set delegate
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        favoriteProvider.dataSource = self
        favoriteProvider.delegate = self
        
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        // init UI theme
        setTheme()
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        // prepare favorite provider
        favoriteProvider.prepare { (error) in
            
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if error != nil {
                print(error?.localizedDescription)
                return
            }
        }
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
        
        hideError()
        
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
        cell.delegate = self
        
        return cell
    }
}

extension MoviesSearchViewController: UITableViewDelegate {
    
    // Tells the delegate that the specified row is now selected.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: SearchBar Methods
extension MoviesSearchViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
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

extension MoviesSearchViewController: FavoriteProviderDataSource {
    
    // get favorite object by object id
    func getFavoriteObjectById(favoriteProvider: FavoriteProvider, favoriteObjectId objectId: Int) -> FavoriteObject? {
        
        // get favorite object by id
        let movies = filteredMovies?.filter({ (movie) -> Bool in
            return movie.getFavoriteObjectId() == objectId
        })
        if movies?.count > 0 {
            return movies![0]
        }
        return nil
    }
}

extension MoviesSearchViewController: FavoriteProviderDelegate {
    
    // object Id did changed favorite value
    func favoriteProvider(favoriteProvider: FavoriteProvider, objectIdDidChangedFavoriteValue objectId: Int) {
        
        // get row index
        let index = filteredMovies?.indexOf({ (movie) -> Bool in
            return movie.getFavoriteObjectId() == objectId
        })
        // reload row style
        if let index = index {
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Right)
        }
    }
}

extension MoviesSearchViewController: MGSwipeTableCellDelegate {
    
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool
    {
        switch (direction) {
        case .LeftToRight:
            // tap on Favorite button
            if index == 0 {
                tapFavoriteButton(cell)
            }
        case .RightToLeft:
            // tap on Share button
            if index == 0 {
                tapShareButton(cell)
            }
        }
        
        return true
    }
    
    private func tapFavoriteButton(cell: MGSwipeTableCell!) {
        
        if let indexPath = tableView.indexPathForCell(cell) {
            let movie = filteredMovies![indexPath.row]
            favoriteProvider.saveFavorite(movie, isFavorited: !movie.isFavorited)
        }
    }
    
    private func tapShareButton(cell: MGSwipeTableCell!) {
        
        if let indexPath = tableView.indexPathForCell(cell) {
            
            let movie = filteredMovies![indexPath.row]
            let shareMenu = UIAlertController(title: nil, message: "Share your Movie", preferredStyle: .ActionSheet)
            let twitterAction = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.Default) { (action) -> Void in
                
                // Check if sharing to Twitter is possible.
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                    // Initialize the default view controller for sharing the post.
                    let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    twitterComposeVC.setInitialText("Why this movie get so hight rating? Could you tell me?")
                    // Display the compose view controller.
                    self.presentViewController(twitterComposeVC, animated: true, completion: nil)
                }
                else {
                    self.showAlertMessage("You are not logged in to your Twitter account.")
                }
            }
            let facebookAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.Default) { (action) -> Void in
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                    // Initialize the default view controller for sharing the post.
                    let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    facebookComposeVC.setInitialText("\(movie.overview!)")
                    // Display the compose view controller.
                    self.presentViewController(facebookComposeVC, animated: true, completion: nil)
                }
                else {
                    self.showAlertMessage("You are not connected to your Facebook account.")
                }
            }
            let moreAction = UIAlertAction(title: "More", style: UIAlertActionStyle.Default) { (action) -> Void in
                
                let activityViewController = UIActivityViewController(activityItems: [movie.overview!], applicationActivities: nil)
                activityViewController.excludedActivityTypes = [UIActivityTypeMail]
                self.presentViewController(activityViewController, animated: true, completion: nil)
            }
            let doneAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.Cancel, handler: nil)
            
            shareMenu.addAction(twitterAction)
            shareMenu.addAction(facebookAction)
            shareMenu.addAction(moreAction)
            shareMenu.addAction(doneAction)
            self.presentViewController(shareMenu, animated: true, completion: nil)
        }
    }
    
    private func showAlertMessage(message: String!) {
        
        let alertController = UIAlertController(title: "Movie Viewer", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
}
