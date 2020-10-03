//
//  Constants.swift
//  Flix
//
//  Created by Esther Max-Onakpoya on 9/25/20.
//

import Foundation
import UIKit

struct Constants {
    static let loadingCellId = "loadingCell"
    static let movieCellId = "movieListCell"
    static let movieTitleApiId = "title"
    static let movieOverviewApiId = "overview"
    static let moviePosterApiId = "poster_path"
    static let movieResultsApiId = "results"
    static let movieBackdropApiId = "backdrop_path"
    static let baseUrlImagePathApi = "https://image.tmdb.org/t/p/w"
    static let baseUrlMoviePathApi = "https://api.themoviedb.org/3/movie/"
    static let baseUrlGenrePathApi = "https://api.themoviedb.org/3/genre/movie/"
    static let apiKey = "api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US"
    static let videoSectionApi = "videos?"
    static let nowPlayingSectionApi = "now_playing?"
    static let movieDetailViewSegueId = "toMovieDetailScreen"
    static let imageHiRes = 780
    static let imageLowRes = 185
    static let genericFailedMessage = "Error: process failed"
    static let movieApiId = "id"
    static let posterCornerRadius : CGFloat = 20
    static let movieGenreApiId = "genre_ids"
    static let genreListSectionApi = "list?"
    static let noMovieGenreId = -1
}
