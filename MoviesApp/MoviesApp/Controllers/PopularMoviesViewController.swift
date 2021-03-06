//
//  PopularMoviesViewController.swift
//  MoviesApp
//
//  Created by Nicholas Babo on 10/11/18.
//  Copyright © 2018 Nicholas Babo. All rights reserved.
//

import UIKit

enum PresentationState {
    case initial
    case loading
    case ready
    case error
    case noResults(String)
}

class PopularMoviesViewController: UIViewController {
    
    let screen = PopularMoviesScreen(frame: .zero)
    
    var presentationState:PresentationState = .initial{
        didSet{
            self.refreshUI(for: presentationState)
        }
    }
    
    var service: MoviesService = MoviesServiceImplementation()
    var movies:[Movie] = []
    var genres:[Genre] = []
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.title = "Movies"
        self.tabBarItem = UITabBarItem(title: "Popular Movies", image: UIImage.icon.list, selectedImage: UIImage.icon.list)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchMovies()
        self.fetchGenres()
        self.setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.screen.collectionView.reloadData()
        super.viewWillAppear(animated)
    }
    
    override func loadView() {
        self.view = screen
    }
    
}

extension PopularMoviesViewController{
    
    func refreshUI(for state:PresentationState){
        self.screen.refreshUI(with: state)
    }
    
}

//API - Movies
extension PopularMoviesViewController {
    func fetchMovies(query: String? = nil) {
        self.presentationState = .loading
        let request = query == nil ? APIRequest.fecthPopularMovies : APIRequest.searchMovie
        service.fetchPopularMovies(request: request, query: query, page: nil) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleFetch(of: response.results, withQuery: query, totalResults: response.totalResults)
            case .error:
                self?.presentationState = .error
            }
        }
    }
    
    func handleFetch(of movies: [Movie], withQuery query:String? = nil, totalResults:Int) {
        if movies.count > 0{
            self.movies = movies
            self.screen.collectionView.setupCollectionView(with: movies, totalResults: totalResults, selectionDelegate: self)
            self.presentationState = .ready
        }else{
            if let query = query{
                self.presentationState = .noResults(query)
            }else{
                self.presentationState = .error
            }
        }
    }
    
}

//API - Genres
extension PopularMoviesViewController{
    func fetchGenres(){
        service.fetchGenre { [weak self] result in
            switch result{
            case .success(let genres):
                self?.handleFetch(of: genres)
            case .error:
                print("handle error in fetching genres")
            }
        }
    }
    
    func handleFetch(of genres:[Genre]){
        self.genres = genres
    }
}

//Movie Selection Delegate
extension PopularMoviesViewController: MovieSelectionDelegate{
    func didSelect(movie: Movie) {
        let detailController = MovieDetailViewController(movie: movie, genres: self.genres)
        self.navigationController?.pushViewController(detailController, animated: true)
    }
}

//Search Controller/Bar
extension PopularMoviesViewController: UISearchBarDelegate{
    
    func setupSearchBar(){
        self.definesPresentationContext = true
        let searchController = UISearchController(searchResultsController: nil)
        searchController.definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text{
            if !text.isEmpty{
                self.screen.collectionView.setupCollectionView(with: [], totalResults: 0, selectionDelegate: self)
                fetchMovies(query: text)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchMovies()
    }
    
}
