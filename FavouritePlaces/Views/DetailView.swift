//
//  DetailView.swift
//  FavouritePlaces
//
//  Created by Brianne Byer on 26/4/2023.
//

import SwiftUI
import CoreData

struct DetailView: View {
    var place: Place
    // refer to entity attributes
    @State var locationName: String = ""
    @State var locationURL = ""
    @State var locationDetail = ""
    @State var locationLong = ""
    @State var locationLat = ""
    @State var isEditing = false
    @State var image = defaultImage
    //var viewContext: NSManagedObjectContext
    // @State var details: [PlaceInformation]?
    
    var body: some View {
        VStack {
            if !isEditing {
                List {
                    Text("Place name: \(locationName)")
                    Text("Place image: \(locationURL)")
                    Text("Place details: \(locationDetail)")
                    Text("Longitude: \(locationLong)")
                    Text("Latitude: \(locationLat)")
                }
            } else {
                List {
                    TextField("Place name: ", text: $locationName)
                    TextField("Place image: ", text: $locationURL)
                    TextField("Place details: ", text: $locationDetail)
                    TextField("Longitude: ", text: $locationLong)
                    TextField("Latitude: ", text: $locationLat)
                }
            }
            HStack {
                Button("\(isEditing ? "Confirm" : "Edit")") {
                    if(isEditing) {
                        place.strName = locationName
                        place.strURL = locationURL
                        place.strDesc = locationDetail
                        place.strLong = locationLong
                        place.strLat = locationLat
                        saveData()
                        Task {
                        image = await place.getImage()
                        }
                    }
                    isEditing.toggle()
                }
            }
            image.scaledToFit().cornerRadius(20).shadow(radius:20)
            
        }.navigationTitle("Location Details")
            .onAppear {
                locationName = place.strName
                locationURL = place.strURL
                locationDetail = place.strDesc
                locationLong = place.strLong
                locationLat = place.strLat
            }.task {
                await image = place.getImage()
            }
    }
}
