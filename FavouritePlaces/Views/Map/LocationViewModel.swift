//
//  LocationViewModel.swift
//  FavouritePlaces
//
//  Created by Brianne Byer on 21/5/2023.
//

import Foundation
import CoreData
import CoreLocation
import MapKit
import SwiftUI

/**
 This extension adds computed properties and a function to the MapLocation struct. The properties allow for getting and setting the latitude and longitude of a map location as strings for converting them to Double values. The updateFromRegion function updates the map location's latitude and longitude based on the current region. The setupRegion function sets up the region of the map location based on its latitude, longitude, and delta. The fromLocToAddress function converts the map location's latitude and longitude to an address and updates the name property with the address information. The fromAddressToLoc function converts the map location's name to a latitude and longitude coordinate. The fromZoomToDelta function converts a zoom level to a delta value for the region span.

 - Parameter mlatStr: Computed property that returns the latitude of the map location as a string with a maximum of 5 decimal places. It can also be set with a string value and automatically converts it to a Double data type.
 - Parameter mlongStr: Computed property that returns the longitude of the map location as a string with a maximum of 5 decimal places. It can also be set with a string value and automatically converts it to a Double data type.
 - Parameter updateFromRegion: Function that updates the map location's latitude and longitude based on the current region.
 - Parameter setupRegion: Function that sets up the region of the map location based on its latitude, longitude, and delta.
 - Parameter fromLocToAddress: Function that converts the map location's latitude and longitude to an address and updates the name property with the address information.
 - Parameter fromAddressToLoc: Function that converts the map location's name to a latitude and longitude coordinate.
 - Parameter fromZoomToDelta: Function that converts a zoom level to a delta value for the region span.
 */
extension MapLocation {
    var mlatStr: String {
        get{String(format: "%.5f", latitude)}
        set{
            guard let lat = Double(newValue), lat <= 90.0, lat >= -90.0 else {return}
            latitude = lat
        }
    }
    
    var mlongStr: String {
        get{String(format: "%.5f", longitude)}
        set{
            guard let long = Double(newValue), long <= 180.0, long >= -180.0 else {return}
            longitude = long
        }
    }
    
    func updateFromRegion() {
        latitude = region.center.latitude
        longitude = region.center.longitude
    }
    
    func setupRegion() {
        withAnimation{
            region.center.latitude = latitude
            region.center.longitude = longitude
            region.span.longitudeDelta = delta
            region.span.latitudeDelta = delta
        }
    }
    
    func fromLocToAddress() {
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { marks, error in
            if let err = error {
                print("error in fromLocToAddress: \(err)")
                return
            }
            let mark = marks?.first
            let name = mark?.name ?? mark?.country ?? mark?.locality ?? mark?.administrativeArea ?? "No name"
            self.name = name
        }
        
    }

    func fromAddressToLoc(_ cb:@escaping ()-> Void){
        let encode = CLGeocoder()
        encode.geocodeAddressString(self.name){
            marks, error in
            if let err = error {
                print("error in fromAddressToLoc \(err)")
                return
            }
            if let mark = marks?.first {
                self.latitude = mark.location?.coordinate.latitude ?? self.latitude
                self.longitude = mark.location?.coordinate.longitude ?? self.longitude
                cb()
                self.setupRegion()
            }
        }
    }
    
    func fromZoomToDelta(_ zoom: Double){
        let d1 = -10.0
        let d2 = 3.0
        delta = pow(10.0, zoom / d1 + d2)
    }
}
