//
//  FileManager+Extension.swift
//  TestProject
//
//  Created by Aswin Koramanghat on 02/09/20.
//  Copyright © 2020 Aswin Koramanghat. All rights reserved.
//

import Foundation

public extension FileManager {
// Returns a URL that points to the document folder of this playground.
    static var applicationSupportDirectory: URL {
        return try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
    }
}
