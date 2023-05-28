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
                    HStack {
                        VStack {
                            // uses place's current latitude to center map
                            Text("Latitude: \(modelMap.region.center.latitude)")
                                .font(.subheadline)
                            // uses places current longitude to center map
                            Text("Longitude: \(modelMap.region.center.longitude)")
                                .font(.subheadline)
                        }
                        Spacer()
                        Image(systemName: "map")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                checkMap()
                                // update
                                place.strLat = mLatitude
                                place.strLong = mLongitude
                                // save
                                saveData()
                            }
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
//            print(place.placeZoom)
            
            mZoom = place.placeZoom
//            print(mZoom)
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
     /**
     This function checks the address of the map location and updates the map location's latitude and longitude based on the address.

     - Remark: function is executed asynchronously on the main queue.
     - Important: after updating the map location, the view should be updated by calling the updateViewLoc function.
     - Requires: map location should have a valid name property.
     - Note: function also saves the updated data.
     */
    func checkAddress() {
        DispatchQueue.main.async {
            modelMap.fromAddressToLoc(updateViewLoc)
            // save
            saveData()
            }
        }
    
    /**
     The function updates the view location by setting the latitude and longitude properties of the map location based on the current values of modelMap.mlatStr and modelMap.mlongStr. This function performs the following steps:
     1. Sets the value of mLatitude to the value of modelMap.mlatStr.
     2. Sets the value of mLongitude to the value of modelMap.mlongStr.
     3. Updates the mlongStr property of the modelMap object with the new mLongitude value.
     4. Updates the mlatStr property of the modelMap object with the new mLatitude value.
     5. Calls the saveData() function to save the updated data.
     
     - Remark: function is executed synchronously.
     - Requires: modelMap object should have valid mlatStr and mlongStr properties, and the mLatitude and mLongitude variables should have valid values.
     */
    func updateViewLoc() {
        mLatitude = modelMap.mlatStr
        mLongitude = modelMap.mlongStr
        modelMap.mlongStr = mLongitude
        modelMap.mlatStr = mLatitude
        //save
        saveData()
    }
    
    /**
     This function checks the location of the map based on the current latitude and longitude values (mLatitude and mLongitude). This function performs the following steps:
     1. Sets the mlongStr property of the modelMap object to the value of mLongitude.
     2. Sets the mlatStr property of the modelMap object to the value of mLatitude.
     3. Calls the fromLocToAddress() function of the modelMap object to convert the location coordinates to an address.
     4. Calls the setupRegion() function of the modelMap object to set up the map region based on the updated location.
     
     - Remark: function is executed synchronously.
     - Requires: modelMap object and mLatitude and mLongitude properties should have valid values.
     */

    func checkLocation() {
        modelMap.mlongStr = mLongitude
        modelMap.mlatStr = mLatitude
        modelMap.fromLocToAddress()
        modelMap.setupRegion()
    }
    
    /**
     The function checks the zoom level of the map and updates the map location accordingly. This function performs the following steps:
     1. Calls the checkMap() function to ensure the map is properly initialized.
     2. Calls the fromZoomToDelta() function of the modelMap object, passing the value of mZoom, to update the delta value of the map location's region based on the zoom level.
     3. Calls the fromLocToAddress() function of the modelMap object to update the name property of the map location based on the current coordinates.
     4. Calls the setupRegion() function of the modelMap object to set up the region of the map location.
     
     - Remark: function may perform asynchronous operations.
     - Requires: modelMap object should be properly initialized, and the mZoom property should have a valid value.
     */
    func checkZoom() {
        checkMap()
        modelMap.fromZoomToDelta(mZoom)
        modelMap.fromLocToAddress()
        modelMap.setupRegion()
    }
    
    /**
     The function checks the map and updates the map location based on the current region. This function performs the following steps:
     1. Calls the updateFromRegion() function of the modelMap object to update the latitude and longitude properties of the map location based on the current region.
     2. Assigns the updated latitude value to the mLatitude property.
     3. Assigns the updated longitude value to the mLongitude property.
     4. Calls the fromLocToAddress() function of the modelMap object to update the name property of the map location based on the current coordinates.
     
     - Remark: function may perform asynchronous operations.
     - Requires: modelMap object should be properly initialized.
     */
    func checkMap() {
        // checks location on map, finds lat/long
        modelMap.updateFromRegion()
        mLatitude = modelMap.mlatStr
        mLongitude = modelMap.mlongStr
        // checks long/lat and finds name of location
        modelMap.fromLocToAddress()
    }
    
}

