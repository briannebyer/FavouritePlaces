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


/**
This class represents a map location and contains information about the name, latitude, longitude, delta, region, timeZone, sunrise time, and sunset time of the location.

- Parameter name: string representing the name of the map location.
- Parameter latitude: double representing the latitude coordinate of the map location.
- Parameter longitude: double representing the longitude coordinate of the map location.
- Parameter delta: double representing the delta value for the map location's region.
- Parameter region: MKCoordinateRegion object representing the region of the map location.
- Parameter timeZone: optional string representing the time zone of the map location.
- Parameter sunRiseTime: optional string representing the sunrise time of the map location.
- Parameter sunSetTime: optional string representing the sunset time of the map location.

- Remark: class conforms to the ObservableObject protocol to allow for observation of property changes.
- Important: name, latitude, longitude, delta, region, timeZone, sunRiseTime, and sunSetTime properties are marked with @Published as they may change and need to be observed.
- Requires: name should not be an empty string. The latitude and longitude should be valid coordinate values. The delta should be a valid delta value. The region should be a valid MKCoordinateRegion object.
*/
class MapLocation: ObservableObject {
    @Published var name = ""
    @Published var latitude = 0.0
    @Published var longitude = 0.0
    @Published var delta = 100.0
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 100.0, longitudeDelta: 100.0))
    // for timezone, sunset and sunrise features
      @Published var timeZone: String?
      @Published var sunRiseTime: String?
      @Published var sunSetTime: String?

    static let shared = MapLocation()
    
    init(){}
}



