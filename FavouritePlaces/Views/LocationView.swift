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
    
    @Binding var pLatitude: String
    @Binding var pLongitude: String
    @Binding var pName: String
    // to change default back button
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack (alignment: .center){
            HStack {
//                Text("\(pName)")
//                    .font(.headline)
            }
//            Slider(value: $zoom, in: 10...60) {
//                print($0)
//            }
            Map(coordinateRegion: $region)
            
            VStack {
                Text("Latitude: \(pLatitude)")
                    .font(.subheadline)
                Text("Longitude: \(pLongitude)")
                    .font(.subheadline)

            }
        }.navigationTitle("Map of \(pName) ")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.blue)
               Text("\(pName)")
            }, trailing: Button(action: {
                // something here later
            }) {
                Text("Edit")
            })
    }
}

