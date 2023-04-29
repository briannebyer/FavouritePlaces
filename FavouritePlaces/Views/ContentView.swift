//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by Brianne Byer on 26/4/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // to be able to receive context
    @Environment(\.managedObjectContext) private var viewContext
    // refer to entity attributes
    @State var locationName: String = ""
    // to be able to get data
    @FetchRequest(entity: Place.entity(), sortDescriptors: [])
    private var places: FetchedResults<Place>
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Place name: ", text: $locationName)
                    
                    NavigationLink("Search") {
                        SearchView(locationName: locationName, viewContext: viewContext)
                        }
                }
            List {
                ForEach(places) {place in
                    NavigationLink(destination: DetailView(place: place)) {
                        RowView(place: place)
                        //Text(place.placeName ?? "Unknown place")
                    }
                    
                }.onDelete(perform: delPlace)
                .onMove(perform: movePlace)
            }
        }.padding()
        .navigationTitle("My Places")
        .navigationBarItems(leading: EditButton(), trailing: Button("+") {
            addPlace()
            locationName = ""
        })
        }
    }
    
    // func to add to viewmodel?
    private func addPlace() {
        // if locationName empty, do nothing
        guard !locationName.isEmpty else {
            return
        }
        withAnimation {
            let places = Place(context: viewContext)
            places.placeName = locationName
            saveData()
        }
    }
    
    // func to add to viewmodel?
    private func delPlace(idx: IndexSet) {
        withAnimation {
            idx.map{places[$0]}.forEach {
                place in viewContext.delete(place)
            }
            saveData()
        }
    }
    
    // func to add to viewmodel? Need to fix, as not
    private func movePlace(from source: IndexSet, to destination: Int) {
        withAnimation {
            var revisedPlace: [Place] = places.map {$0}
            revisedPlace.move(fromOffsets: source, toOffset: destination)
            for reverseIndex in stride(from: revisedPlace.count - 1, through: 0, by: -1) {
                let place = revisedPlace[reverseIndex]
                place.placePosition = Int16(reverseIndex)
            }
            //places = revisedPlace // to update position
            saveData()
        }
    }
    
    // func to add to viewmodel?
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("An error occured during save: \(error)")
        }
    }
}
