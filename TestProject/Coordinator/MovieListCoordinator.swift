//
//  MovieListCoordinator.swift
//  TestProject
//
//  Created by Aswin Koramanghat on 01/09/20.
//  Copyright © 2020 Aswin Koramanghat. All rights reserved.
//

import Foundation
import UIKit

class MovieListCoordinator: Coordinator {
    
    private let presenter: UINavigationController
    private let viewModel: ViewModelling
    private var movieListViewController: ViewController!
    private var movieDetailsCordinator: MovieDetailsCoordinator!
    
    init(presenter: UINavigationController, viewModel: ViewModelling) {
        self.presenter = presenter
        self.viewModel = viewModel
    }
    
    func start() {
        let movieListViewController = ViewController(nibName: "ViewController", bundle: nil)
        movieListViewController.title = "Movies"
        movieListViewController.viewModel = viewModel
        movieListViewController.delegate = self
        presenter.pushViewController(movieListViewController, animated: true)
        self.movieListViewController = movieListViewController
    }
}

class MovieDetailsCoordinator: Coordinator {
    
    private let presenter: UINavigationController
    private let viewModel: ViewModelling
    private var movieDetailsViewController: ViewController!
    
    init(presenter: UINavigationController, viewModel: ViewModelling) {
        self.presenter = presenter
        self.viewModel = viewModel
    }
    
    func start() {
        let movieDetailsViewController = ViewController(nibName: "ViewController", bundle: nil)
        presenter.pushViewController(movieDetailsViewController, animated: true)
        self.movieDetailsViewController = movieDetailsViewController
    }
}


extension MovieListCoordinator: movieListViewControllerDelegate {
    func viewControllerDidSelectMovie(_ selectedMovie: Movie) {
        let movieDetailCoordinator = MovieDetailsCoordinator(presenter: presenter, viewModel: ViewModel())
        movieDetailCoordinator.start()
        self.movieDetailsCordinator = movieDetailCoordinator
    }
}

protocol movieListViewControllerDelegate: class {
    func viewControllerDidSelectMovie(_ selectedMovie: Movie)
}

