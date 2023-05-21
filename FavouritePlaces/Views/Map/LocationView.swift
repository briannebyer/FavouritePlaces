//
//  LocationView.swift
//  FavouritePlaces
//
//  Created by Brianne Byer on 19/5/2023.
//

import SwiftUI
import MapKit
import CoreData

struct LocationView: View {
    var place: Place
    // for map, using new class
    @StateObject var modelMap: MapLocation
    @State var mZoom = 10.0
    @State var mLatitude: String = "0.0"
    @State var mLongitude: String = "0.0"
    @State var isEditing = false
    // to change default back button
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack (alignment: .center){
            if !isEditing {
//                Slider(value: $mZoom, in: 10...60) {
//                    if !0 {
//                        checkZoom()
//                    }
//                }
                
                ZStack {
                    Map(coordinateRegion: $modelMap.region)
                }
                
                VStack {
                    // uses place's current latitude to center map
                    Text("Latitude: \(modelMap.region.center.latitude)")
                        .font(.subheadline)
                    // uses places current longitude to center map
                    Text("Longitude: \(modelMap.region.center.longitude)")
                        .font(.subheadline)
                    
                    Text("\(mLatitude)")
                    Text("\(mLongitude)")
                }
            // when editing
            } else {
                HStack {
                    TextField("Place name: ", text: $modelMap.name)
                    Image(systemName: "sparkle.magnifyingglass")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            //checkAddress()
                        }
                }
                
                ZStack {
                    Map(coordinateRegion: $modelMap.region)
                }

                VStack {
                    TextField("Enter latitude: ", text: $mLatitude)
                        .foregroundColor(.gray)
                    TextField("Enter longitude: ", text: $mLongitude)
                        .foregroundColor(.gray)
                    Image(systemName: "sparkle.magnifyingglass")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            checkMap()
                        }
                    
                }
            }

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
                    place.strLong = mLongitude
                    place.strLat = mLatitude
                    // then after checking, saves
                    saveData()
                }
                isEditing.toggle()
            }) {
                Text(isEditing ? "Done" : "Edit")
            })
//            .onAppear {
//                mLongitude = place.strLong
//                mLatitude = place.strLat
//            }
//            .task {
//                checkMap()
//            }
    }
    
    func checkAddress() {
        
    }
    
    func checkLocation() {
        
    }
    
    func checkZoom() {
        
    }
    
    func checkMap() {
        // checks location on map, finds lat/long
        modelMap.updateFromRegion()
        mLatitude = modelMap.mlatStr
        mLongitude = modelMap.mlongStr
        // checks long/lat and finds name of location
        modelMap.fromLocToAddress()
    }
}

