//
//  DetailView.swift
//  FavouritePlaces
//
//  Created by Brianne Byer on 26/4/2023.
//

import SwiftUI
import CoreData

struct DetailView: View {
    var place: Place
    // refer to entity attributes
    @State var locationName: String = ""
    @State var locationURL = ""
    @State var locationDetail = ""
    @State var locationLong = ""
    @State var locationLat = ""
    @State var isEditing = false
    //@State var image = defaultImage
    //var viewContext: NSManagedObjectContext
    // @State var details: [PlaceInformation]?
    
    var body: some View {
        VStack {
            if !isEditing {
                List {
                    Text("Place name: \(locationName)")
                    Text("Place image: \(locationURL)")
                    Text("Place details: \(locationDetail)")
                    Text("Longitude: \(locationLong)")
                    Text("Latitude: \(locationLat)")
                }
            }
        }.navigationTitle("Location Details")
            .onAppear {
                locationName = place.strName
                locationURL = place.strURL
                locationDetail = place.strDesc
                locationLong = place.strLong
                locationLat = place.strLat
        }
    }
}

//            } else {
//                    List{
//                        TextField("Place name:", text: $pName)
//                        //TextField("Place image:", text: $pURL)
//                        TextField("Place details:", text: $pDetail)
//                        TextField("Longitude:", text: Binding<String>(
//                                get: { String(pLong) },
//                                set: { if let value = Double($0) { pLong = value } }
//                            ))
//                        TextField("Latitude:", text: Binding<String>(
//                            get: { String(pLat) },
//                            set: { if let value = Double($0) { pLat = value } }
//                    ))
//                }
//            }
//        }
//    }
//}
