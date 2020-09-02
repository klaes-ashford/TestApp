//
//  MovieSubset.swift
//  TestProject
//
//  Created by Aswin Koramanghat on 02/09/20.
//  Copyright © 2020 Aswin Koramanghat. All rights reserved.
//

import Foundation

struct MovieSubset: Codable {
    init(id: Int, title: String) {
        self.id =  id
        self.title = title
    }
    let id: Int
    let title: String
}
