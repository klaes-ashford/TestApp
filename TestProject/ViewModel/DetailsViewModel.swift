//
//  DetailsViewModel.swift
//  TestProject
//
//  Created by Aswin Koramanghat on 02/09/20.
//  Copyright © 2020 Aswin Koramanghat. All rights reserved.
//

import Foundation
protocol DetailsViewModelling {
    func getSynopsis()
    var title: Box<String> { get set }
    var tagline: Box<String> { get set }
    var overview: Box<String> { get set }
    var posterUrl: Box<String> { get set }
}

class DetailsViewModel: DetailsViewModelling {
    private var networkManager: SourceManager
    private var movieId: Int
    private var model: Synopsis? {
        didSet {
            configureValues()
        }
    }
    var title: Box<String> = Box("")
    var tagline: Box<String> = Box("")
    var overview: Box<String> = Box("")
    var posterUrl: Box<String> = Box("")
    init(networkManager: SourceManager, movieId: Int) {
        self.networkManager = networkManager
        self.movieId = movieId
    }
    
    func getSynopsis() {
        networkManager.getSynopsis(id: movieId) { synopsis, error in
            self.model = synopsis
        }
    }
    
    private func configureValues() {
        guard let model = model else { return }
        title.value = model.title
        tagline.value = model.tagline
        overview.value = model.overview
        posterUrl.value = "https://image.tmdb.org/t/p/w500\(model.posterPath)"
    }
}
