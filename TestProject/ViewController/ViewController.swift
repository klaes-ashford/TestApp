//
//  ViewController.swift
//  TestProject
//
//  Created by Aswin Koramanghat on 01/09/20.
//  Copyright © 2020 Aswin Koramanghat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var networkManager: NetworkManager!
    private var isSearching = false
    
    // MARK: - Properties
    private var sections: [Section] = [] {
        didSet {
            self.applySnapshot(animatingDifferences: true)
        }
    }
    private var networkSections: [Section] = []
    private lazy var dataSource = makeDataSource()
    private var searchController = UISearchController(searchResultsController: nil)
    var viewModel: ViewModelling!
    
    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.collectionView.delegate = self
        networkManager = NetworkManager()
        networkManager.getNewMovies(page: 1) { movies, error in
            guard let movies = movies else { return }
            let newSection = Section(title: "Now Playing", videos: movies)
            self.sections.append(newSection)
            self.networkSections.append(newSection)
        }
        configureSearchController()
        configureLayout()
    }
    
    
    // MARK: - Functions
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, video) ->
                UICollectionViewCell? in
                if self.isSearching {
                    let sectionType = Section.SectionType(rawValue: indexPath.section)
                    switch sectionType {
                    case .movie:
                        let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: "MovieCollectionViewCell",
                            for: indexPath) as? MovieCollectionViewCell
                        cell?.movie = video
                        return cell

                    case .search:
                        let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: "SearchResultCollectionViewCell",
                            for: indexPath) as? SearchResultCollectionViewCell
                        cell?.movie = video
                        return cell

                    default: fatalError()
                    }
                    
                }
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "MovieCollectionViewCell",
                    for: indexPath) as? MovieCollectionViewCell
                cell?.movie = video
                return cell
        })
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let section = self.dataSource.snapshot()
                .sectionIdentifiers[indexPath.section]
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier,
                for: indexPath) as? SectionHeaderReusableView
            view?.titleLabel.text = section.title
            return view
        }
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.videos, toSection: section)
        }
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        sections = filteredSections(for: searchController.searchBar.text)
        applySnapshot()
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
    
    func searchLogic(title: String, query: String) -> Bool {
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
        
    func storeSearched(movies: [Movie]) {
        do {
            let plistURL = URL(fileURLWithPath: "myAPIKeys", relativeTo: FileManager.applicationSupportDirectory).appendingPathExtension("plist")
            
            let plistEncoder = PropertyListEncoder()
            plistEncoder.outputFormat = .xml
            let plistData = try plistEncoder.encode(movies)
            try plistData.write(to: plistURL)
        } catch {print(error)        }
        
    }
    
    func retrieveSearchedMovies() -> [Movie] {
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
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: - Layout Handling
extension ViewController {
    private func configureLayout() {
        self.collectionView.register(UINib(nibName:"MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        self.collectionView.register(UINib(nibName:"SearchResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
        collectionView.register(
            SectionHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier
        )
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
            var size: NSCollectionLayoutSize
            if self.isSearching {
                if sectionIndex == 0 {
                    size = NSCollectionLayoutSize(
                        widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                        heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 44 : 60)
                    )
                } else {
                    size = NSCollectionLayoutSize(
                        widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                        heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 280 : 250)
                    )

                }
                            } else {
                size = NSCollectionLayoutSize(
                    widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                    heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 280 : 250)
                )
            }
            let itemCount = isPhone ? 1 : 3
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.interGroupSpacing = 10
            // Supplementary header view setup
            let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(20)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource Implementation
extension ViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if isSearching {
            guard let movie = dataSource.itemIdentifier(for: indexPath) else {
                return
            }
            var movies = retrieveSearchedMovies()
            movies.append(movie)
            storeSearched(movies: movies)
        }
    }
}
