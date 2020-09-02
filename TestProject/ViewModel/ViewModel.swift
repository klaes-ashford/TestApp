//
//  ViewModel.swift
//  TestProject
//
//  Created by Aswin Koramanghat on 01/09/20.
//  Copyright © 2020 Aswin Koramanghat. All rights reserved.
//

import Foundation
import UIKit

protocol ViewModelling {
    var isSearching: Bool { get set }
    var sections: Box<[Section]> { get set }
    func itemTapped(movie: Movie)
    func updateSearchResults(with query: String)
    func height(sectionIndex: Int) -> CGFloat
    func getNowPlaying()
}

typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>

class ViewModel: ViewModelling {
    var sections: Box<[Section]> = Box([])
    private var networkManager: SourceManager
    var isSearching = false
    private var networkSections: [Section] = []
    
    init(networkManager: SourceManager) {
        self.networkManager = networkManager
    }
    
    func filteredSections(for queryOrNil: String?) -> [Section] {
        isSearching = !(queryOrNil?.isEmpty ?? true)
        let sections = networkSections
        guard
            let query = queryOrNil,
            !query.isEmpty
            else {
                return sections
        }
        let filteredMovies = sections.first!.videos.filter { video in
            return searchLogic(title: video.title.lowercased(), query: query.lowercased())
        }
        let recentSearches = retrieveSearchedMovies()
        return [Section(title: "Recent Searches", videos: recentSearches), Section(title: "Search Result", videos: filteredMovies)]
    }
    
    private func searchLogic(title: String, query: String) -> Bool {
        let words = title.split{$0 == " "}.map(String.init)
        let startsWith =  words.contains { (word) -> Bool in
            word.starts(with: query)
        }
        let wordsPresent: Bool = {
            let queryWords = query.split{$0 == " "}.map(String.init)
            let set1:Set<String> = Set(queryWords)
            let set2:Set<String> = Set(words)
            return set1.subtracting(set2).isEmpty
        }()
        return startsWith || wordsPresent
    }
    
    private func storeSearched(movies: [Movie]) {
        do {
            let plistURL = URL(fileURLWithPath: "myAPIKeys", relativeTo: FileManager.applicationSupportDirectory).appendingPathExtension("plist")
            
            let plistEncoder = PropertyListEncoder()
            plistEncoder.outputFormat = .xml
            let plistData = try plistEncoder.encode(movies)
            try plistData.write(to: plistURL)
        } catch {print(error)        }
        
    }
    
    private func retrieveSearchedMovies() -> [Movie] {
        let plistURL = URL(fileURLWithPath: "myAPIKeys", relativeTo: FileManager.applicationSupportDirectory).appendingPathExtension("plist")
        do  {
            let plistDecoder = PropertyListDecoder()
            let data = try Data.init(contentsOf: plistURL)
            let value = try plistDecoder.decode([Movie].self, from: data)
            return value
        } catch {            print(error)
            return []
        }
    }
    
    func height(sectionIndex: Int) -> CGFloat {
        if self.isSearching {
            if sectionIndex == 0 {
                return 44
            } else {
                return 280
            }
        } else {
            return 280
        }
    }
    
    func getNowPlaying() {
        networkManager.getNewMovies(page: 1) { movies, error in
            guard let movies = movies else { return }
            let newSection = Section(title: "Now Playing", videos: movies)
            self.sections.value.append(newSection)
            self.networkSections.append(newSection)
        }
    }
        
    func updateSearchResults(with query: String) {
        sections.value = filteredSections(for: query)
    }
    
    func itemTapped(movie: Movie) {
        if isSearching {
            var movies = retrieveSearchedMovies()
            movies.append(movie)
            storeSearched(movies: movies)
        }
    }
    
}
