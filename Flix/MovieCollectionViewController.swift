//
//  CollectionViewController.swift
//  Flix
//
//  Created by Esther Max-Onakpoya on 10/2/20.
//

import UIKit

private let reuseIdentifier = "moviePosterCell"

class MovieCollectionViewController: UICollectionViewController {
    // MARK: - Model
    var movies = [[String: Any]]()
    // TODO: - Refactor the below part of the model. Individual vars are quite messy. Change to struct or something
    var genreToMoviesIndex = [Int: [Int]]()
    var genreToMoviesKeys = [Int]()
    var genres = [[String : Any]]()
    var genreIdToString = [Int: String]()
    enum NetworkCaller {
        case MOVIE
        case GENRE
    }
    
    private var reuseIdentifier = "loadingCollectionCell"
    var isDoneLoading = false {
        didSet {
            var movieIndex = -1
            for movie in self.movies {
                movieIndex += 1
                if let genreIdList = movie[Constants.movieGenreApiId] as? [Int] {
                    let genreId = genreIdList.isEmpty ? Constants.noMovieGenreId : genreIdList[0]
                    if self.genreToMoviesIndex[genreId] != nil{
                        self.genreToMoviesIndex[genreId]?.append(movieIndex)
                        continue
                    }
                    self.genreToMoviesIndex[genreId] = [movieIndex]
                    self.genreIdToString[genreId] = getGenre(genreId: genreId)
                }
            }
            genreToMoviesKeys.append(contentsOf: self.genreToMoviesIndex.keys)
            genreToMoviesKeys.sort(by: >)
            reuseIdentifier = "moviePosterCell"
            updateLayout()
            self.collectionView.reloadData()
            
        }
    }
    var waitMessages = ["Rolling the reel...", "Setting the scenes...", "Loading the movies...", "Almost there..."]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        updateLayout()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
//        layout. = 30
//        layout.minimumInter
        // Do any additional setup after loading the view.
        
        let genreUrl = URL(string: (Constants.baseUrlGenrePathApi+Constants.genreListSectionApi+Constants.apiKey))!
        callNetwork(url: genreUrl, writeTo: NetworkCaller.GENRE)
        
        let url = URL(string: (Constants.baseUrlMoviePathApi+Constants.nowPlayingSectionApi+Constants.apiKey))!
        callNetwork(url: url, writeTo: NetworkCaller.MOVIE, shouldLoad: true)
        
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "toMovieDetailScreenFromCollection" {
            let cell = sender as! MovieCollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)!
            let movieIndex = getMovieIndex(section: indexPath.section, row: indexPath.row)
            print("indexPath.row: ", indexPath.row, "; indexPath.item: ", indexPath.item)
            let movieId = movies[movieIndex][Constants.movieApiId] as! Int
            let trailerUrl = URL(string:Constants.baseUrlMoviePathApi+"\(movieId)/"+Constants.videoSectionApi+Constants.apiKey)
            let vc = segue.destination as! MovieDetailViewController
            vc.movieDetail = MovieDetail(posterImage: cell.posterImageView.image, backdropImage: getImage(key: Constants.movieBackdropApiId, index: movieIndex, resolution: Constants.imageHiRes), title: movies[movieIndex][Constants.movieTitleApiId] as? String, overview: movies[movieIndex][Constants.movieOverviewApiId] as? String, trailer: trailerUrl)
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return genreToMoviesIndex.count > 0 ? genreToMoviesIndex.count : 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreToMoviesKeys.count > section ? genreToMoviesIndex[genreToMoviesKeys[section]]?.count as! Int : 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !isDoneLoading {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LoadingCollectionViewCell
            cell.loadingCellActivityIndicator.startAnimating()
            cell.loadingMessageLabel.text = waitMessages[Int.random(in: 0..<waitMessages.count)]
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
        let key = genreToMoviesKeys[indexPath.section]
        if let image = getImage(key: Constants.moviePosterApiId, index: (genreToMoviesIndex[key]?[indexPath.row])!) {
            cell.posterImageView.image = image
        }
        cell.posterImageView.layer.cornerRadius = Constants.posterCornerRadius
        print("indexPath.row: ", indexPath.row, "; indexPath.item: ", indexPath.item)
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionSectionHeader", for: indexPath) as? SectionHeaderCollectionReusableView{
            sectionHeader.sectionTitleLabel.text = ""
            if isDoneLoading {
                sectionHeader.sectionTitleLabel.text = genreIdToString[genreToMoviesKeys[indexPath.section]]
            }
            return sectionHeader
        }
        return UICollectionReusableView()
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
    
    func getMovieIndex(section: Int, row: Int) -> Int {
        return (genreToMoviesIndex[genreToMoviesKeys[section]]?[row])!
    }
    
    func getGenre(genreId : Int) -> String! {
        for genre in genres {
            if ((genre["id"] as! Int) == genreId) {
                return genre["name"] as? String
            }
        }
        return nil
    }
    
    func updateLayout() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let cellsPerRow : CGFloat = 4
        let width = (view.frame.width - (layout.minimumInteritemSpacing * (cellsPerRow-1)) - 16)/cellsPerRow
        layout.itemSize = CGSize(width: width, height: (3/2) * width)
        print("layout.itemSize.width: ", layout.itemSize.width, "; view.frame.width: ", view.frame.width)
        if !isDoneLoading {
            layout.itemSize = CGSize(width: view.frame.width - 16, height: view.frame.height - 16)
        }
    }
    
    func callNetwork(url : URL, writeTo : NetworkCaller, shouldLoad : Bool = false) {
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
                print(Constants.genericFailedMessage)
                print(error.localizedDescription)
           } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            switch writeTo {
            case .GENRE:
                self.genres = dataDictionary["genres"] as! [[String:Any]]
            case .MOVIE:
                self.movies = dataDictionary[Constants.movieResultsApiId] as! [[String:Any]]
            default:
                print(Constants.genericFailedMessage)
            }
            if shouldLoad{
              self.isDoneLoading = true
            }
           }
        }
        task.resume()
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if isDoneLoading {
//            let cell = collectionView.cellForItem(at: indexPath) as! MovieCollectionViewCell
//            performSegue(withIdentifier: "toMovieDetailScreenFromCollection", sender: cell)
//        }
//    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
