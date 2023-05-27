//
//  ViewModel.swift
//  FavouritePlaces
//
//  Created by Brianne Byer on 26/4/2023.
//

import Foundation
import CoreData
import SwiftUI

// default image, if place does not have image
let defaultImage = Image(systemName: "photo").resizable()
var downloadImages: [URL: Image] = [:]

/**
This extension adds computed properties and a function to the Place struct. The properties allow for getting and setting the name, description, longitude, latitude, and URL of a place in both string and non-string formats. The rowDisplay property returns a string combining the place name and description. The getImage() function asynchronously downloads and returns an image associated with the place URL, or a default image if the URL is nil or invalid.

- Parameter strName: a computed property that returns the name of the place as a string or "unknown" if it is nil.
- Parameter strDesc: a computed property that returns the description of the place as a string or "unknown" if it is nil.
- Parameter strLong: a computed property that returns the longitude of the place as a string or "unknown" if it is nil. It can also be set with a string value and automatically converts it to a Double data type.
- Parameter strLat: a computed property that returns the latitude of the place as a string or "unknown" if it is nil. It can also be set with a string value and automatically converts it to a Double data type.
- Parameter strURL: a computed property that returns the URL of the place's picture as a string or an empty string if it is nil. It can also be set with a string value and automatically converts it to a URL data type.
- Parameter rowDisplay: a computed property that returns the name and description of the place in the format "name: description".
- Requires: The place struct must have a placeName and placeDetail property, and the placeLongitude and placeLatitude properties must be convertible to Double.
- Returns: An Image object downloaded asynchronously from the place URL or a default image if the URL is nil or invalid.
*/
extension Place {
    var strName: String {
        get {
            self.placeName ?? "unknown"
        }
        set {
            self.placeName = newValue
        }
    }
    
    var strDesc: String {
        get {
            self.placeDetail ?? "unknown"
        }
        set {
            self.placeDetail = newValue
        }
    }
    
    // to allow latitude to be a string for input and any changes, then converting back to float data type
    var strLat: String {
        get {
            "\(self.placeLatitude)"
        }
        set {
            guard let placeLatitude = Double(newValue) else {
                return
            }
            self.placeLatitude = placeLatitude
        }
    }
    
    // switched lat and long, as lat goes first typically
    // to allow longitude to be a string for input and any changes, then converting back to float data type
    var strLong: String {
        get {
            "\(self.placeLongitude)"
        }
        set {
            guard let placeLongitude = Double(newValue) else {
                return
            }
            self.placeLongitude = placeLongitude
        }
    }

    var strURL: String {
        get {
            self.placePicture?.absoluteString ?? ""
        }
        set {
            guard let url = URL(string: newValue) else { return }
            self.placePicture = url
        }
    }
    var rowDisplay: String {
        "\(self.strName): \(self.strDesc)"
    }
    
    func getImage() async ->Image {
        guard let url = self.placePicture else {return defaultImage}
        if let image = downloadImages[url] {return image}
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let uiimg = UIImage(data: data) else {return defaultImage}
            let image = Image(uiImage: uiimg).resizable()
            downloadImages[url]=image
            return image
        }catch {
            print("Error in download image: \(error)")
        }
        
        return defaultImage
    }
}

// extension for MapLocation, to handle timezones
extension MapLocation {
    var timeZoneStr: String {
        if let tz = timeZone {
            return tz
        }
        //fetchTimeZone()
        return ""
    }
    
    var timeZoneDisplay: some View{
        HStack {
            Image(systemName: "timer.square")
            Text("Time zone: ")
            if timeZoneStr != "" {
                Text(timeZoneStr)
            } else {
                ProgressView()
            }
        }
    }
    // pull data from API
//    func fetchTimeZone () {
//        // Brisbane lat and long
//        let urlStr = "https://timeapi.io/api/TimeZone/coordinate?latitude=27.4705&longitude=153.0260"
//        guard let url = URL(string: urlStr) else {
//            return
//        }
//        let request = URLRequest(url: url)
//        URLSession/shared.dataTask(with: request) { data, _, _ in
//            guard let data = data, let api = try?
//                    JSONDecoder().decode(LocationTimeZone.self, from: data) else {
//                return
//            }
//            DispatchQueue.main.async {
//                self.timeZone = api.timezone
//                //self.fecthSunriseInfo()
//            }
//        }
//    }
}

/**
The function saves changes made to the managed object context of the PersistenceController shared instance.

- Important: The changes will not be persisted to the persistent store until the context is saved.
- Throws: An error if there is an issue saving the changes.
*/
func saveData() {
    let ctx = PersistenceController.shared.container.viewContext
    do {
        try ctx.save()
    }catch {
        print("Error to save with \(error)")
    }
}

// create function to load default places
func loadDefaultPlaces() {
      let defaultPlaces = [["Mt Tamborine", "Beautiful views!", "-27.942164", "153.193649", "https://www.mustdogoldcoast.com/sites/mustdogoldcoast/files/styles/mdb_category_blue_node_large/public/featured/Hero%20st-bernards2017-09-19-00.51.21_0%20%281%29.jpg?itok=eNYlsor2"],
            // next default place
            ["GongCha", "Best boba", "37.8238", "144.9625", "https://gongchatea.com.au/wp-content/uploads/2021/04/IMG_4040-300x225.jpg"],
            // next default place
            ["Eaton Centre", "Iconic mall", "43.6544", "79.3807", "https://upload.wikimedia.org/wikipedia/commons/b/b2/CF_Tornoto_Eaton_Centre_202205.jpg"]]
    
    let ctx = PersistenceController.shared.container.viewContext

    defaultPlaces.forEach {
        let place = Place(context: ctx)
        place.strName = $0[0]
        place.strDesc = $0[1]
        place.strLat = $0[2]
        place.strLong = $0[3]
        place.strURL = $0[4]
    }
    saveData()
}
