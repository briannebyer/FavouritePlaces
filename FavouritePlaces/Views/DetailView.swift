//
//  DetailView.swift
//  FavouritePlaces
//
//  Created by Brianne Byer on 26/4/2023.
//

import SwiftUI
import CoreData
import MapKit

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
    // for map
    @ObservedObject var modelMap: MapLocation
    // for map snippet
    @State var mapdelta = 20.0
    var d1 = -10.0
    var d2 = 3.5
    var zoom = 100.0
    
    @State private var mapSnippet = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
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
                        NavigationLink(destination: LocationView(place: place, modelMap: modelMap, mLatitude: $locationLat, mLongitude: $locationLong)){
                            // show snippet
                            Map(coordinateRegion: $mapSnippet)
                                .frame(width: 50, height: 50, alignment: .leading)
                                            Text("Map of \(locationName)")
                                        }
                    }

                }
            } else {
                List {
                    TextField("Enter place name: ", text: $locationName)
                        .foregroundColor(.gray)
                    TextField("Enter image URL: ", text: $locationURL)
                        .foregroundColor(.gray)
                    TextField("Enter additional details: ", text: $locationDetail)
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
                        place.strDesc = locationDetail
                        place.strLong = locationLong
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
                
                // for map snippet
                mapdelta = pow(10.0, zoom/d1+d2)
                // center of snippet
                self.mapSnippet.center.latitude = Double(place.strLat) ?? 0
                self.mapSnippet.center.longitude = Double(place.strLong) ?? 0
                // span of snippet (square)
                self.mapSnippet.span.latitudeDelta = mapdelta
                self.mapSnippet.span.longitudeDelta = mapdelta
            
            }.onDisappear(){
                place.strName = locationName
                place.strURL = locationURL
                place.strDesc = locationDetail
                place.strLong = locationLong
                place.strLat = locationLat
                saveData()
            }
            
            .task {
                await image = place.getImage()
            }
    }
}
