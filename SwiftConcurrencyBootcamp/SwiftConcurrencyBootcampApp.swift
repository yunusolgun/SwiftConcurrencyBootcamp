//
//  SwiftConcurrencyBootcampApp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by yunus olgun on 3.04.2025.
//

import SwiftUI

@main
struct SwiftConcurrencyBootcampApp: App {
    var body: some Scene {
        WindowGroup {
            DownloadImageAsync()
        }
    }
}
