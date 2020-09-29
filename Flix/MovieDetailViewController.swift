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
    var movieDetail : MovieDetail!
    
    @IBOutlet weak var overviewScrollView: UIScrollView!
    @IBOutlet var innerView: UIView!
    
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
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
