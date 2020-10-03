//
//  ViewController.swift
//  Flix
//
//  Created by Esther Max-Onakpoya on 9/23/20.
//

import UIKit

class MovieTableViewController: UITableViewController {
    // MARK: - Model
    var movies = [[String: Any]]()
    var isDoneLoading = false {
        didSet {
            self.tableView.separatorStyle = .singleLine
            self.tableView.reloadData()
        }
    }
    var waitMessages = ["Rolling the reel...", "Setting the scenes...", "Loading the movies...", "Almost there..."]
    
    // MARK: - Tableview Overrides
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isDoneLoading {
            return 1
        }
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isDoneLoading {
            return view.frame.height
        }
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isDoneLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.loadingCellId, for: indexPath) as! LoadingCell
            cell.loadMoviesActivityIndicator.startAnimating()
            cell.waitMessageLabel.text =  waitMessages[Int.random(in: 0..<waitMessages.count)]
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.movieCellId, for: indexPath) as! MovieCell
        cell.movieTitleLabel.text = movies[indexPath.row][Constants.movieTitleApiId] as? String
        cell.movieDetailLabel.text = movies[indexPath.row][Constants.movieOverviewApiId] as? String
        if let image = getImage(key: Constants.moviePosterApiId, index: indexPath.row) {
            cell.moviePosterImageView.image = image
        }
//        cell.moviePosterImageView
        return cell
    }
    
    // MARK: - Helper function to get image from web, given a URL
    func getImage(key: String, index: Int, resolution: Int = Constants.imageLowRes) -> UIImage? {
        let baseUrlPath = Constants.baseUrlImagePathApi + "\(resolution)"
        let posterUrlPath = movies[index][key] as! String
        // let posterURL = URL(string: baseUrlPath+posterUrlPath)
        if let posterURL = URL(string: baseUrlPath+posterUrlPath) {
            if let posterImage = try? Data(contentsOf: posterURL) {
                return UIImage(data: posterImage)
            }
        }
        return nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        
        let url = URL(string: (Constants.baseUrlMoviePathApi+Constants.nowPlayingSectionApi+Constants.apiKey))!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
            print(Constants.genericFailedMessage)
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            self.movies = dataDictionary[Constants.movieResultsApiId] as! [[String:Any]]
              self.isDoneLoading = true
           }
        }
        task.resume()
    }
    
    // MARK: - Navigation to detailedView
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! MovieCell
        let indexPath = tableView.indexPath(for: cell)
        let movieId = movies[indexPath!.row][Constants.movieApiId] as! Int
        let trailerUrl = URL(string:Constants.baseUrlMoviePathApi+"\(movieId)/"+Constants.videoSectionApi+Constants.apiKey)
        if segue.identifier == Constants.movieDetailViewSegueId {
            let vc = segue.destination as! MovieDetailViewController
            vc.movieDetail = MovieDetail(posterImage: cell.moviePosterImageView.image, backdropImage: getImage(key: Constants.movieBackdropApiId, index: indexPath!.row, resolution: Constants.imageHiRes), title: cell.movieTitleLabel.text, overview: cell.movieDetailLabel.text, trailer: trailerUrl)
        }
    }


}

