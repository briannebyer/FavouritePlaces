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
    // to change default back button
    @Environment(\.presentationMode) var presentationMode
    // var viewContext: NSManagedObjectContext
    
    var body: some View {
        VStack {
            if !isEditing {
                List {
                    VStack (alignment: .leading) {
                        HStack {
                            Text("Place name: ")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(locationName)")
                        }
                        image.scaledToFit().cornerRadius(20).shadow(radius:10)
                        HStack {
                            Text("\(locationDetail)")
                                .font(.caption)
                        }
                        Spacer()
                        NavigationLink(destination: LocationView(pLatitude: $locationLat, pLongitude: $locationLong, pName: $locationName)) {
                                            Text("Map of \(locationName)")
                                        }
//                        HStack {
//                            Text("Longitude: ")
//                                .foregroundColor(.gray)
//                            Spacer()
//                            Text("\(locationLong)")
//                        }
//                        HStack {
//                            Text("Latitude: ")
//                                .foregroundColor(.gray)
//                            Spacer()
//                            Text("\(locationLat)")
//                        }
                    }
                }
            } else {
                List {
                    TextField("Enter place name: ", text: $locationName)
                        .foregroundColor(.gray)
                    TextField("Enter image URL: ", text: $locationURL)
                        .foregroundColor(.gray)
                   // TextField("Enter additional details: ", text: $locationDetail)
                   //     .foregroundColor(.gray)
                   // TextField("Enter longitude: ", text: $locationLong)
                   //     .foregroundColor(.gray)
                    TextField("Enter latitude: ", text: $locationLat)
                        .foregroundColor(.gray)
                }
            }

        }.navigationTitle(isEditing ? "Location Details": locationName )
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.blue)
                    Text("My Places")
                }
            }, trailing:
                Button(action: {
                    if isEditing {
                        place.strName = locationName
                        place.strURL = locationURL
                        //place.strDesc = locationDetail
                        //place.strLong = locationLong
                        place.strLat = locationLat
                        saveData()
                        Task {
                            image = await place.getImage()
                        }
                    }
                    isEditing.toggle()
                }, label: {
                    Text(isEditing ? "Done" : "Edit")
                })
            )
        
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
