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
    
    init(presenter: UINavigationController, viewModel: ViewModelling) {
        self.presenter = presenter
        self.viewModel = viewModel
    }
    
    func start() {
        let movieListViewController = ViewController(nibName: "ViewController", bundle: nil)
        movieListViewController.title = "Movies"
        movieListViewController.viewModel = viewModel
        presenter.pushViewController(movieListViewController, animated: true)
        self.movieListViewController = movieListViewController
    }
}
