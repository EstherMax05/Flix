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
        moviePosterImageView.layer.cornerRadius = 35
        moviePosterImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
