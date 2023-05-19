//
//  LocationView.swift
//  FavouritePlaces
//
//  Created by Brianne Byer on 19/5/2023.
//

import SwiftUI
import MapKit

var latitude = -27.470125
var longitude = 153.021072
var rangeMeter = 10_000.00
// bigger the degree, the longer the span
var deltaDegree = 0.05

struct LocationView: View {
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: deltaDegree, longitudeDelta: deltaDegree) )
    @State var zoom = 10.0
    
    var body: some View {
        VStack {
            HStack {
                Text("Address")
            }
            Slider(value: $zoom, in: 10...60) {
                print($0)
            }
            Map(coordinateRegion: $region)
            
            HStack {
                Text("Lat/Long")
            }
        }.navigationTitle("Map of ____ ")
            .navigationBarItems(leading: Button(action : {
                // something here later
            }) {
               Text("Place name here")
            }, trailing: Button(action: {
                // something here later
            }) {
                Text("Edit")
            })
    }
}

