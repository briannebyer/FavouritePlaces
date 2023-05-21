//
//  LocationViewModel.swift
//  FavouritePlaces
//
//  Created by Brianne Byer on 21/5/2023.
//

import Foundation
import CoreData
import MapKit

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
}
