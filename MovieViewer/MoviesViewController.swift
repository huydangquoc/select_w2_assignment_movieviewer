//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 6/30/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        Movie.fetchNowPlaying(page: nil, language: nil, complete: {(movies: [Movie], error: NSError?) -> Void in
            self.movies = movies
            self.tableView.reloadData()
        })        
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
    
}

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return movies?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        cell.setData(movie)
        
        return cell
    }
    
}

extension MoviesViewController: UITableViewDelegate {
    
}