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
    @Environment(\.managedObjectContext) var viewContext
    // refer to entity attributes
    @State var locationName: String = ""
    // to be able to get data
    @FetchRequest(entity: Place.entity(), sortDescriptors: [NSSortDescriptor(key: "placeName", ascending: true)])
    var places: FetchedResults<Place>
    // map
    @ObservedObject var modelMap: MapLocation
    
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
                ForEach(places) { place in
                    NavigationLink(destination: DetailView(place: place, modelMap: modelMap)){
                        RowView(place: place)
                    }
                    
                }.onDelete(perform: delPlace)
                //.onMove(perform: movePlace)
            }
        }.padding()
            // if there are 0 places, load the default places
        .task {
                if(places.count == 0) {
                    loadDefaultPlaces()
                }
            }
        .navigationTitle("My Places")
        .navigationBarItems(leading: EditButton(), trailing: Button("+") {
            addPlace()
        })
        }
    }

    /**
    This function adds a new place to the managed object context of the viewContext using the specified name and details.

    - Important: function modifies the managed object context and must be called within a withAnimation block to ensure any UI updates are animated.
    - Parameter viewContext: managed object context to which the new place will be added.
    - Parameter placeName: name of the new place to be added.
    - Parameter placeDetail: details of the new place to be added.
    */
    func addPlace() {
        withAnimation {
            let places = Place(context: viewContext)
            places.placeName = "New Location Name"
            places.placeDetail = "Add Details"
        }
    }
    
    /**
    This function deletes a place from the managed object context of the viewContext, based on the specified IndexSet of place objects.

    - Important: function modifies the managed object context and must be called within a withAnimation block to ensure any UI updates are animated.
    - Parameter viewContext: managed object context from which the place will be deleted.
    - Parameter idx: IndexSet object containing the indices of the place objects to be deleted.
    */
    func delPlace(idx: IndexSet) {
        withAnimation {
            idx.map{places[$0]}.forEach {
                place in viewContext.delete(place)
            }
            saveData()
        }
    }
    
    /**
    This function saves any changes made to the viewContext.

    - Throws: fatal error if there is an error while saving the context.
    - Important: function should be called after any changes are made to the managed object context.
    */
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("An error occured during save: \(error)")
        }
    }
}
