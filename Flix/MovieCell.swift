//
//  MovieCell.swift
//  Flix
//
//  Created by Esther Max-Onakpoya on 9/23/20.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // TODO: - change moviePosterImageView layer cornerRadius from literal to calculated item
        moviePosterImageView.layer.cornerRadius = Constants.posterCornerRadius
        moviePosterImageView.layer.borderWidth = 0.5
        moviePosterImageView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        moviePosterImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
