//
//  ViewController.swift
//  Flix
//
//  Created by Esther Max-Onakpoya on 9/23/20.
//

import UIKit

class MovieTableViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieListCell", for: indexPath) as! MovieCell
        cell.movieTitleLabel.text = movies[indexPath.row]["title"] as? String
        cell.movieDetailLabel.text = movies[indexPath.row]["overview"] as? String
        if let image = getImage(key: "poster_path", index: indexPath.row) {
            cell.moviePosterImageView.image = image
        }
//        cell.moviePosterImageView
        return cell
    }
    
    func getImage(key: String, index: Int, resolution: Int = 185) -> UIImage? {
        let baseUrlPath = "https://image.tmdb.org/t/p/w\(resolution)"
        let posterUrlPath = movies[index][key] as! String
        // let posterURL = URL(string: baseUrlPath+posterUrlPath)
        if let posterURL = URL(string: baseUrlPath+posterUrlPath) {
            if let posterImage = try? Data(contentsOf: posterURL) {
                return UIImage(data: posterImage)
            }
        }
        return nil
    }
    
    
    var movies = [[String: Any]]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
              self.movies = dataDictionary["results"] as! [[String:Any]]
            print("HET")
            print(self.movies)
            self.tableView.reloadData()
           }
        }
        task.resume()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! MovieCell
        let indexPath = tableView.indexPath(for: cell)
        let str1 = movies[indexPath!.row]["id"] as! Int
        let trailerUrl = URL(string:"https://api.themoviedb.org/3/movie/\(str1)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")
        if segue.identifier == "toMovieDetailScreen" {
            let vc = segue.destination as! MovieDetailViewController
            vc.movieDetail = MovieDetail(posterImage: cell.moviePosterImageView.image, backdropImage: getImage(key: "backdrop_path", index: indexPath!.row, resolution: 780), title: cell.movieTitleLabel.text, overview: cell.movieDetailLabel.text, trailer: trailerUrl)
        }
    }


}

