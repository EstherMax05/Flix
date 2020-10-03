//
//  MovieDetailViewController.swift
//  Flix
//
//  Created by Esther Max-Onakpoya on 9/24/20.
//

import UIKit
struct MovieDetail {
    var posterImage : UIImage?
    var backdropImage : UIImage?
    var title : String?
    var overview : String?
    var trailer : URL?
}
class MovieDetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var watchTrailerButton: UIButton!
    @IBOutlet var didTap: UITapGestureRecognizer!
    var movieDetail : MovieDetail!
    var trailerResults = [[String:Any]]()
    var trailerKey = ""
    
    @IBOutlet weak var overviewScrollView: UIScrollView!
    @IBOutlet var innerView: UIView!
    @IBAction func didTapPoster(_ sender: UITapGestureRecognizer) {
        print("Tapppeddddddd")
        if didTap.state == .ended {
            print("Tapppeddddddasfsaffsdfdsd")
        }
        performSegue(withIdentifier: "trailerSegue", sender: nil)
    }
    
    @IBAction func watchTrailerTapped(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posterImageView.layer.cornerRadius = Constants.posterCornerRadius
        posterImageView.image = movieDetail.posterImage
        backdropImageView.image = movieDetail.backdropImage
        movieTitleLabel.text = movieDetail.title
        movieOverviewLabel.text = movieDetail.overview
        print("overviewScrollView.contentSize ", overviewScrollView.contentSize)
        overviewScrollView.contentSize = CGSize(width: self.view.frame.width, height: innerView.frame.maxY)
        print("overviewScrollView.contentSiz2e ", overviewScrollView.contentSize)
        print("movieOverviewLabel.frame.maxY ", movieOverviewLabel.frame.maxY, " ",  innerView.frame.maxY, " ", self.view.frame.maxY)
        // Do any additional setup after loading the view.
        callNetwork(url : movieDetail.trailer!)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "trailerSegue" {
            let viewController = segue.destination as! TrailerViewController
            viewController.videoId = trailerResults[0]["key"] as! String
            
        }
    }
    
    func callNetwork(url : URL, key : String = "results") {
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
                print(Constants.genericFailedMessage)
                print(error.localizedDescription)
           } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.trailerResults = dataDictionary[key] as! [[String:Any]]
                print("trailerResults ", dataDictionary[key] as! [[String:Any]])
                print("trailerResults URL ", url)
           }
        }
        task.resume()
        print("trailerResults.count ", trailerResults)
    }
    

}
