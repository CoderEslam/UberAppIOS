//
//  UberAppApp.swift
//  UberApp
//
//  Created by Eslam Ghazy on 18/8/23.
//

import SwiftUI

@main
struct UberAppApp: App {
    // to make only on object and be sengular
    @StateObject var locationViewModel = LocationSearchViewViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
        }
    }
}
