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
            
            if loadMore {
                self.movies! += movies!
                self.tableView.reloadData()
            } else {
                self.movies = movies
                self.tableView.reloadData()
                // scroll to top
                self.tableView.setContentOffset(CGPointZero, animated: true)
            }
        }
    }
    
    func setTheme() {
        
        tableView.backgroundColor = UIColor.blackColor()
        // remove showing empty row for table incase network error
        tableView.tableFooterView = UIView()
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
