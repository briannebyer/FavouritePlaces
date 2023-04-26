//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by Brianne Byer on 26/4/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var name: String = ""
    @FetchRequest(entity: Place.entity(), sortDescriptors: [])
    private var place: FetchedResults<Place>
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add new place")
                TextField("Place name: ", text: $name)
                
            HStack {
                Spacer()
                Button("Add"){
                    addPlace()
                    name = ""
                }
                Spacer()
                Button("Clear") {
                    name = ""
                }
                Spacer()
            }
            List {
                ForEach(place) {p in
                    Text(p.placeName ?? "Unknown place")
                }
            }
        }.padding()
        .navigationTitle("My Places")
        }
    }
    
    // func to add to viewmodel?
    private func addPlace() {
        withAnimation {
            let place = Place(context: viewContext)
            place.placeName = name
            saveContext()
        }
    }
    
    // func to add to viewmodel?
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("An error occured during save: \(error)")
        }
    }
}
