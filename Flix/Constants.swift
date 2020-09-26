//
//  Constants.swift
//  Flix
//
//  Created by Esther Max-Onakpoya on 9/25/20.
//

import Foundation

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
    static let apiKey = "api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US"
    static let videoSectionApi = "videos?"
    static let nowPlayingSectionApi = "now_playing?"
    static let movieDetailViewSegueId = "toMovieDetailScreen"
    static let imageHiRes = 780
    static let imageLowRes = 185
    static let genericFailedMessage = "Error: process failed"
    static let movieApiId = "id"
}
