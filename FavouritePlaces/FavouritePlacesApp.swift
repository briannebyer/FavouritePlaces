//
//  FavouritePlacesApp.swift
//  FavouritePlaces
//
//  Created by Brianne Byer on 26/4/2023.
//

import SwiftUI

@main
struct FavouritePlacesApp: App {
    let persistenceController = PersistenceController.shared
    // for map
    @StateObject var modelMap = MapLocation.shared
    var body: some Scene {
        WindowGroup {
            ContentView(modelMap: modelMap).environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
