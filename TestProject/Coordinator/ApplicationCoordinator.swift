//
//  ApplicationCoordinator.swift
//  TestProject
//
//  Created by Aswin Koramanghat on 01/09/20.
//  Copyright © 2020 Aswin Koramanghat. All rights reserved.
//

import Foundation
import UIKit

class ApplicationCoordinator: Coordinator {
    
    let window: UIWindow
    let rootViewController: UINavigationController
    let flickerListCoordinator: MovieListCoordinator
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
        let viewModel = ViewModel(networkManager: NetworkManager())
        flickerListCoordinator = MovieListCoordinator(presenter: rootViewController, viewModel: viewModel)
    }
    
    func start() {
        window.rootViewController = rootViewController
        flickerListCoordinator.start()
        window.makeKeyAndVisible()
    }
}
