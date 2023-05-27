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
    @ObservedObject var modelMap: MapLocation
    @State var mZoom = 45.0
    @Binding var mLatitude: String
    @Binding var mLongitude: String
    //@State var mName: String
    @State var isEditing = false
    // to change default back button
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack (alignment: .center){
            // not editing
            if !isEditing {
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
                    Button("Update Coordinates"){
                        checkMap()
                        // update
                        place.strLat = mLatitude
                        place.strLong = mLongitude
                        // save
                        saveData()
                }
                }
            // when editing
            } else {
                HStack {
                    TextField("Place name: ", text: $modelMap.name)
                    Image(systemName: "sparkle.magnifyingglass")
                        .foregroundColor(.blue)
                        .onTapGesture {
                          checkAddress()
                        }
                }
                
                Slider(value: $mZoom, in: 10...60) {
                    if !$0 {
                        place.placeZoom = mZoom
                        checkZoom()
                        saveData()
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
                }
            }

        }.task {
            checkMap()
        }
        .onAppear(){
            
            if(place.placeZoom<10.0){
                place.placeZoom = 10
            }
            print(place.placeZoom)
            
            mZoom = place.placeZoom
            print(mZoom)
            mLatitude = place.strLat
            mLongitude = place.strLong
            checkLocation()
            checkZoom()
            checkMap()
            
        }.onDisappear(){
            saveData()
        }
        .navigationTitle(isEditing ? "Update place" : "Map of \(place.strName)")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.blue)
               Text("Place")
            }, trailing: Button(action: {
                if isEditing {
                    checkLocation()
                }
                isEditing.toggle()
            }) {
                Text(isEditing ? "Done" : "Edit")
            })
    }
    
    func checkAddress() {
        DispatchQueue.main.async {
            modelMap.fromAddressToLoc(updateViewLoc)
            // save
            saveData()
            }
        }
    
    func updateViewLoc() {
        mLatitude = modelMap.mlatStr
        mLongitude = modelMap.mlongStr
        modelMap.mlongStr = mLongitude
        modelMap.mlatStr = mLatitude
        //save
        saveData()
    }
    
    func checkLocation() {
        modelMap.mlongStr = mLongitude
        modelMap.mlatStr = mLatitude
        modelMap.fromLocToAddress()
        modelMap.setupRegion()
    }
    
    func checkZoom() {
        checkMap()
        modelMap.fromZoomToDelta(mZoom)
        modelMap.fromLocToAddress()
        modelMap.setupRegion()
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

