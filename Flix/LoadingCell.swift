//
//  LoadingCell.swift
//  Flix
//
//  Created by Esther Max-Onakpoya on 9/25/20.
//

import UIKit

class LoadingCell: UITableViewCell {
    
    @IBOutlet weak var loadMoviesActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var waitMessageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
