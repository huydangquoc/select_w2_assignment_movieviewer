//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 6/30/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "http://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = NSURLRequest(URL: url)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue())
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request) { (data, response, error) in
            if let data = data {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                    NSLog("response: \(responseDictionary)")
                    
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return movies?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath)
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        
        cell.textLabel?.text = title
        
        return cell
    }
    
}

extension MoviesViewController: UITableViewDelegate {
    
}