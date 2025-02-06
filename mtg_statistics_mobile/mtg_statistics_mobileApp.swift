//
//  mtg_statistics_mobileApp.swift
//  mtg_statistics_mobile
//
//  Created by Logan Krause on 2/5/25.
//

import SwiftUI

@main
struct mtg_statistics_mobileApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LifeLinkerView()
        }
    }
}
