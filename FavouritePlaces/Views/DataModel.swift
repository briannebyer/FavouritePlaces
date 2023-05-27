//
//  DataModel.swift
//  FavouritePlaces
//
//  Created by Brianne Byer on 21/5/2023.
//

import Foundation
import MapKit
import CoreLocation
import CoreData

class MapLocation: ObservableObject {
    @Published var name = ""
    @Published var latitude = 0.0
    @Published var longitude = 0.0
    @Published var delta = 100.0
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 100.0, longitudeDelta: 100.0))
    // for timezone, sunset and sunrise features
      @Published var timeZone: String?
    // @Published var sunRiseTime: String?
    // @Published var sunSetTime: String?

    static let shared = MapLocation()
    //static let shared = MapLocation(name: name, latitude: latitude, longitude: longitude)
    
    //init(){}//name: String, latitude: Double, longitude: Double) {
        //self.name = name
        //self.latitude = latitude
        //self.longitude = longitude
   // }
}

