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


// for map
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
                print("errof in fromLocToAddress: \(err)")
                return
            }
            let mark = marks?.first
            let name = mark?.name ?? mark?.country ?? mark?.locality ?? mark?.administrativeArea ?? "No name"
            self.name = name
        }
        
    }
    
// might need to play around with d values
    func fromZoomToDelta(_ zoom: Double){
        let d1 = -10.0
        let d2 = 3.0
        delta = pow(10.0, zoom / d1 + d2)
    }
}
