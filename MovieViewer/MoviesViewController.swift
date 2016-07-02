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

enum DisplayMode {
    
    case Grid, List
}

private let sectionInsets = UIEdgeInsets(top: 30.0, left: 10.0, bottom: 20.0, right: 10.0)

class MoviesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var displayModeSegmented: UISegmentedControl!
    
    var movies: [Movie]?
    var refreshControl: UIRefreshControl!
    var refreshControlGrid: UIRefreshControl!
    var viewMode: MoviesViewMode = .NowPlaying
    var endPointUrl: String {
        switch viewMode {
        case .TopRated:
            return TMDBClient.MovieTopRated
        default:
            return TMDBClient.MovieNowPlaying
        }
    }
    var displayMode = DisplayMode.Grid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set delegate
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // set display mode
        setDisplayMode(displayMode)
        
        // setup UI controls
        setupRefreshControls()
        
        // load data to view
        loadMovies()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var indexPath: NSIndexPath?
        if let cell = sender as? UITableViewCell {
            indexPath = tableView.indexPathForCell(cell)
        } else if let cell = sender as? UICollectionViewCell {
            indexPath = collectionView.indexPathForCell(cell)
        }
        
        let movie = movies![indexPath!.row]
        let movieDetailView = segue.destinationViewController as! MovieDetailViewController
        movieDetailView.movie = movie
    }
    
    @IBAction func onChangeDisplayMode(sender: AnyObject) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            setDisplayMode(.Grid)
        case 1:
            setDisplayMode(.List)
        default:
            setDisplayMode(.Grid)
        }
    }
    
    func hideError() {
        errorView.hidden = true
    }
    
    func showError(error: NSError) {
        errorLabel.text = error.localizedDescription
        errorView.hidden = false
    }
    
    func setupRefreshControls() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        refreshControlGrid = UIRefreshControl()
        refreshControlGrid.addTarget(self, action: #selector(onRefresh), forControlEvents: .ValueChanged)
        collectionView.insertSubview(refreshControlGrid, atIndex: 0)
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
            self.endRefreshing()
            
            guard error == nil else {
                self.movies?.removeAll()
                self.reloadData()
                self.showError(error!)
                return
            }
            
            self.movies = movies
            self.reloadData()
        })
    }
    
    func setDisplayMode(mode: DisplayMode) {
        
        displayMode = mode
        
        switch mode {
        case .Grid:
            collectionView.hidden = false
            tableView.hidden = true
        case .List:
            collectionView.hidden = true
            tableView.hidden = false
        }
        
        reloadData()
    }
    
    func endRefreshing() {
        self.refreshControl.endRefreshing()
        self.refreshControlGrid.endRefreshing()
    }
    
    func reloadData() {
        
        switch displayMode {
        case .Grid:
            collectionView.reloadData()
        case .List:
            tableView.reloadData()
        }
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

extension MoviesViewController: UICollectionViewDataSource {
    
    // Asks your data source object for the number of items in the specified section.
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movies?.count ?? 0
    }
    
    // Asks your data source object for the cell that corresponds to the specified item in the collection view.
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let gridCell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCollectionCell", forIndexPath: indexPath) as! MovieCollectionCell
        let movie = movies![indexPath.row]
        gridCell.setData(movie)
        
        return gridCell
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    
    // Asks the delegate for the size of the specified item’s cell.
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 145, height: 200)
    }
    
    // Asks the delegate for the margins to apply to content in the specified section.
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}
