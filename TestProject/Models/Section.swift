//
//  Section.swift
//  TestProject
//
//  Created by Aswin Koramanghat on 01/09/20.
//  Copyright © 2020 Aswin Koramanghat. All rights reserved.
//

import UIKit

class Section: Hashable {
    enum SectionType: Int {
        case search
        case movie
    }
    var id = UUID()
    var title: String
    var videos: [Movie]
    
    init(title: String, videos: [Movie]) {
        self.title = title
        self.videos = videos
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.id == rhs.id
    }
}

//extension Section {
//  static var allSections: [Section] = [
//    Section(title: "Now Playing", videos: [
//      Movie(
//        id: 633604, posterPath: "/kfpgGNDkwqPggRa1j9z1jINK7y3.jpg", backdrop: "/mFofjESo9brnQYdIq8r42nFLvSe.jpg", title: "Yummy", releaseDate: "2020-07-23", rating: 7.3, overview: "A family must use a magical box of Animal Crackers to save a rundown circus from being taken over by their evil uncle Horatio P. Huntington."
//      ),
//      Movie(
//        id: 315064, posterPath: "/kfpgGNDkwqPggRa1j9z1jINK7y3.jpg", backdrop: "/mFofjESo9brnQYdIq8r42nFLvSe.jpg", title: "Yummy", releaseDate: "2020-07-23", rating: 7.3, overview: "A family must use a magical box of Animal Crackers to save a rundown circus from being taken over by their evil uncle Horatio P. Huntington."
//      ),
//      Movie(
//        id: 606234, posterPath: "/kfpgGNDkwqPggRa1j9z1jINK7y3.jpg", backdrop: "/mFofjESo9brnQYdIq8r42nFLvSe.jpg", title: "Yummy", releaseDate: "2020-07-23", rating: 7.3, overview: "A family must use a magical box of Animal Crackers to save a rundown circus from being taken over by their evil uncle Horatio P. Huntington."
//        ),
//      Movie(
//        id: 446893, posterPath: "/kfpgGNDkwqPggRa1j9z1jINK7y3.jpg", backdrop: "/mFofjESo9brnQYdIq8r42nFLvSe.jpg", title: "Yummy", releaseDate: "2020-07-23", rating: 7.3, overview: "A family must use a magical box of Animal Crackers to save a rundown circus from being taken over by their evil uncle Horatio P. Huntington."
//        ),
//      Movie(
//        id: 531876, posterPath: "/kfpgGNDkwqPggRa1j9z1jINK7y3.jpg", backdrop: "/mFofjESo9brnQYdIq8r42nFLvSe.jpg", title: "Yummy", releaseDate: "2020-07-23", rating: 7.3, overview: "A family must use a magical box of Animal Crackers to save a rundown circus from being taken over by their evil uncle Horatio P. Huntington."
//      )
//
//    ]),
//  ]
//}
