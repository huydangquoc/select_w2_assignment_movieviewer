//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 6/30/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

enum MoviesViewMode {
    
    case NowPlaying, TopRated
}

class MoviesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var movies: [Movie]?
    var refreshControl: UIRefreshControl!
    var viewMode: MoviesViewMode = .NowPlaying
    var endPointUrl: String {
        switch viewMode {
        case .TopRated:
            return TMDBClient.MovieTopRated
        default:
            return TMDBClient.MovieNowPlaying
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        loadMovies()
        setupRefreshControl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        let movie = movies![indexPath.row]
        let movieDetailView = segue.destinationViewController as! MovieDetailViewController
        movieDetailView.movie = movie
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tabBarController?.tabBar.hidden = false
    }
    
    func hideError() {
        errorView.hidden = true
    }
    
    func showError(error: NSError) {
        errorLabel.text = error.localizedDescription
        errorView.hidden = false
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func onRefresh() {
        loadMovies()
    }
    
    func loadMovies() {
        
        hideError()
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        // make network request
        TMDBClient.fetchMovies(endPointUrl, page: nil, language: nil, complete: {(movies: [Movie]?, error: NSError?) -> Void in
            
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            // end refreshing
            self.refreshControl.endRefreshing()
            
            guard error == nil else {
                self.movies?.removeAll()
                self.tableView.reloadData()
                self.showError(error!)
                return
            }
            
            self.movies = movies
            self.tableView.reloadData()
        })
    }
}

extension MoviesViewController: UITableViewDataSource {
    
    // Tells the data source to return the number of rows in a given section of a table view.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return movies?.count ?? 0
    }
    
    // Asks the data source for a cell to insert in a particular location of the table view.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        cell.setData(movie)
        
        return cell
    }
    
}

extension MoviesViewController: UITableViewDelegate {
    
    // Tells the delegate that the specified row is now selected.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}