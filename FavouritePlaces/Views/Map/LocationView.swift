//
//  LocationView.swift
//  FavouritePlaces
//
//  Created by Brianne Byer on 19/5/2023.
//

import SwiftUI
import MapKit
import CoreData

//// for map
//var latitude = -27.470125
//var longitude = 153.021072
//var rangeMeter = 10_000.00
//// bigger the degree, the longer the span
//var deltaDegree = 0.05

struct LocationView: View {
    var place: Place
    // for map, using new class
    @StateObject var modelMap: MapLocation
//    @State var pZoom = 10.0
//    @State var pLatitude: String
//    @State var pLongitude: String
//    @State var pName: String
    // for editing
    @State var isEditing = false
    // to change default back button
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack (alignment: .center){
   //         if !isEditing {
    //            Slider(value: $pZoom, in: 10...60) {
    //                print($0)
    //            }
                Map(coordinateRegion: $modelMap.region)
                
//                VStack {
//                    Text("Latitude: \(pLatitude)")
//                        .font(.subheadline)
//                    Text("Longitude: \(pLongitude)")
//                        .font(.subheadline)
//                }
            // when editing
//            } else {
//                HStack {
//                    Text("\(pName)")
////                    TextField("Enter location name: ", text: $pName)
////                        .foregroundColor(.gray)
//                }
//                Map(coordinateRegion: $modelMap.region)
//
//                VStack {
//                    TextField("Enter latitude: ", text: $pLatitude)
//                        .foregroundColor(.gray)
//                    TextField("Enter longitude: ", text: $pLongitude)
//                        .foregroundColor(.gray)
//                }
//            }

        }.navigationTitle(isEditing ? "Update place" : "Map of Place")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.blue)
               Text("Place")
            }, trailing: Button(action: {
                if isEditing {
                    //place.placeName = locationName
//                    place.strLong = pLongitude
//                    place.strLat = pLatitude
                    saveData()
                }
                isEditing.toggle()
            }) {
                Text(isEditing ? "Done" : "Edit")
            })
            .onAppear {
                // locationName = place.placeName
//                pLongitude = place.strLong
//                pLatitude = place.strLat
            }
    }
}

