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
    @State var name: String = ""
    // to be able to get data
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
                    
                }.onDelete(perform: delPlace)
                .onMove(perform: movePlace)
            }
        }.padding()
        .navigationTitle("My Places")
        .navigationBarItems(leading: EditButton(), trailing: Button("+") {
            addPlace()
            name = ""
        })
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
    private func delPlace(idx: IndexSet) {
        withAnimation {
            idx.map{place[$0]}.forEach {
                p in viewContext.delete(p)
            }
            saveContext()
        }
    }
    
    // func to add to viewmodel? Need to fix, as not
    private func movePlace(from source: IndexSet, to destination: Int) {
        withAnimation {
            var revisedPlace: [Place] = place.map {$0}
            revisedPlace.move(fromOffsets: source, toOffset: destination)
            for reverseIndex in stride(from: revisedPlace.count - 1, through: 0, by: -1) {
                let p = revisedPlace[reverseIndex]
                p.placePosition = Int16(reverseIndex)
            }
            //place = revisedPlace // to update position
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
