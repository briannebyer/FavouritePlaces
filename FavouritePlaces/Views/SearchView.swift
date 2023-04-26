//
//  SearchView.swift
//  FavouritePlaces
//
//  Created by Brianne Byer on 26/4/2023.
//

import SwiftUI
import CoreData

struct SearchView: View {
    var locationName: String
    var viewContext: NSManagedObjectContext
    @State var matches:[Place]?

    var body: some View {
        List {
            ForEach(matches ?? []) { match in
                Text(match.placeName ?? "No matches")
            }
        }.navigationTitle("Search Result")
            .task {
                let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
                fetchRequest.entity = Place.entity()
                fetchRequest.predicate = NSPredicate (
                    format: "placeName contains %@", locationName
                )
                matches = try? viewContext.fetch(fetchRequest)
        }
    }
}


