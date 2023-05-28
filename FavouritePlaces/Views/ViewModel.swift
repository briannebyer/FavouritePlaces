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
 The LocationTimeZone struct represents the decoded result from an API response for retrieving the time zone of a location. It conforms to the Decodable protocol, indicating that it can be initialized from an external representation, JSON.
 - Parameter timeZone: property value obtained from decoding the corresponding JSON key in the API response.
 */
struct LocationTimeZone: Decodable {
    var timeZone: String
}

/**
 The LocationSunriseSunset struct represents the decoded result from an API response for retrieving the sunrise and sunset times of a location. It conforms to the Decodable protocol, indicating that it can be initialized from an external representation, JSON.
 - Parameter sunrise: string representing the time of sunrise for the location.
 - Parameter sunset: string representing the time of sunset for the location.
 */
struct LocationSunriseSunset: Decodable {
    var sunrise: String
    var sunset: String
}

/**
 The LocationSunriseSunsetAPI struct represents the decoded result from an API response for retrieving the sunrise and sunset times of a location. It provides access to the nested LocationSunriseSunset object and the status. It conforms to the Decodable protocol, indicating that it can be initialized from an external representation, JSON.
 - Parameter results: LocationSunriseSunset object representing the sunrise and sunset times.
 - Parameter status: string representing the status of the API response.
 */
struct LocationSunriseSunsetAPI: Decodable {
    var results: LocationSunriseSunset
    var status: String?
}

/**
This extension adds computed properties and a function to the Place struct. The properties allow for getting and setting the name, description, longitude, latitude, and URL of a place in both string and non-string formats. The rowDisplay property returns a string combining the place name and description. The getImage() function asynchronously downloads and returns an image associated with the place URL, or a default image if the URL is nil or invalid.

- Parameter strName: computed property that returns the name of the place as a string or "unknown" if it is nil.
- Parameter strDesc: computed property that returns the description of the place as a string or "unknown" if it is nil.
- Parameter strLong: computed property that returns the longitude of the place as a string or "unknown" if it is nil. It can also be set with a string value and automatically converts it to a Double data type.
- Parameter strLat: computed property that returns the latitude of the place as a string or "unknown" if it is nil. It can also be set with a string value and automatically converts it to a Double data type.
- Parameter strURL: computed property that returns the URL of the place's picture as a string or an empty string if it is nil. It can also be set with a string value and automatically converts it to a URL data type.
- Parameter rowDisplay: computed property that returns the name and description of the place in the format "name: description".
- Requires: Place struct must have a placeName and placeDetail property, and the placeLongitude and placeLatitude properties must be convertible to Double.
- Returns: Image object downloaded asynchronously from the place URL or a default image if the URL is nil or invalid.
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


/**
This extension adds computed properties and functions to the Place struct for handling time zones and retrieving sunrise and sunset times.

- Parameter strTimeZone: computed property that returns the time zone of the place as a string. If the time zone is not available, it initiates a function to fetch the time zone and returns an empty string.
- Parameter timeZoneDisplay: view that displays the time zone information.
- Parameter strSunrise: computed property that returns the time of sunrise for the place as a string, converted to the local time zone. If the sunrise time is not available, it returns an empty string.
- Parameter strSunset: computed property that returns the time of sunset for the place as a string, converted to the local time zone. If the sunset time is not available, it returns an empty string.
- Parameter sunRiseDisplay: view that displays the sunrise time.
- Parameter sunSetDisplay: view that displays the sunset time.
- Parameter fetchTimeZone: function that fetches the time zone of the place from an API and updates the placeTimeZone property.
- Parameter fetchSunInfo: function that fetches the sunrise and sunset times for the place from an API and updates the placeSunrise and placeSunset properties.
*/
extension Place {
    
    var strTimeZone: String {
        if let tz = self.placeTimeZone {
            return tz
        }
        fetchTimeZone()
        return ""
    }

    var timeZoneDisplay: some View{
        HStack {
            Image(systemName: "timer")
            Text("Time zone: ")
            if strTimeZone != "" {
                Text(strTimeZone)
            } else {
                ProgressView()
            }
        }
    }
    
    var strSunrise: String {
        if let sr = placeSunrise {
            let localTM = timeConvertFromGMTtoTimeZone(from: sr, to: self.strTimeZone)
            // return "GMT: \(sr) Local:\(localTM)"
            return "\(localTM)"
        }
        return ""
    }
    
    var strSunset: String {
        if let ss = placeSunset {
            let localTM = timeConvertFromGMTtoTimeZone(from: ss, to: self.strTimeZone)
            // return "GMT: \(ss) Local:\(localTM)"
            return "\(localTM)"
        }
        return ""
    }
    
    var sunRiseDisplay: some View{
        HStack {
            Image(systemName: "sunrise")
                .foregroundColor(.gray)
            //Text("Sunrise: ")
            if strSunrise != "" {
                Text(strSunrise)
                    .font(.caption)
            } else {
                ProgressView()
            }
        }
    }
    
    var sunSetDisplay: some View{
        HStack {
            Image(systemName: "sunset")
                .foregroundColor(.gray)
            //Text("Sunset: ")
            if strSunset != "" {
                Text(strSunset)
                    .font(.caption)
            } else {
                ProgressView()
            }
        }
    }
    
    // pull data from API
    func fetchTimeZone () {
        let urlStr = "https://timeapi.io/api/TimeZone/coordinate?latitude=\(placeLatitude)&longitude=\(placeLongitude)"
        guard let url = URL(string: urlStr) else {
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data, let api = try?
                    JSONDecoder().decode(LocationTimeZone.self, from: data) else {
                return
            }
            DispatchQueue.main.async {
                //print("THIS IS THE TIME")
                //print(api.timeZone)
                self.placeTimeZone = api.timeZone
                self.fetchSunInfo()
            }
        }.resume()
    }
    
    // pull data from sunrise and sunset API
    func fetchSunInfo () {
        let urlStr = "https://api.sunrise-sunset.org/json?lat=\(placeLatitude)&lng=\(placeLongitude)"
        guard let url = URL(string: urlStr) else {
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data, let api = try?
                    JSONDecoder().decode(LocationSunriseSunsetAPI.self, from: data) else {
                return
            }
            DispatchQueue.main.async {
//                print("Sunrise Time")
//                print(api.results.sunrise)
                self.placeSunrise = api.results.sunrise
                self.placeSunset = api.results.sunset
            }
        }.resume()
    }
}

/**
The function saves changes made to the managed object context of the PersistenceController shared instance.

- Important: changes will not be persisted to the persistent store until the context is saved.
- Throws: error if there is an issue saving the changes.
*/
func saveData() {
    let ctx = PersistenceController.shared.container.viewContext
    do {
        try ctx.save()
    }catch {
        print("Error to save with \(error)")
    }
}

/**
 The function loads default places into the app.
 */
func loadDefaultPlaces() {
      let defaultPlaces = [["Mt Tamborine", "Beautiful views!", "-27.942164", "153.193649", "https://www.mustdogoldcoast.com/sites/mustdogoldcoast/files/styles/mdb_category_blue_node_large/public/featured/Hero%20st-bernards2017-09-19-00.51.21_0%20%281%29.jpg?itok=eNYlsor2"],
            // next default place
            ["GongCha", "Best boba", "-37.8238", "144.9625", "https://gongchatea.com.au/wp-content/uploads/2021/04/IMG_4040-300x225.jpg"],
            // next default place
            ["CF Eaton Center", "Iconic mall", "43.6544", "-79.3807", "https://upload.wikimedia.org/wikipedia/commons/b/b2/CF_Tornoto_Eaton_Centre_202205.jpg"]]
    
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

/**
 This function converts a time from GMT to a specific time zone.

 - Parameter from: time to convert in GMT format (e.g., "10:30:00").
 - Parameter to: target time zone identifier (e.g., "America/New_York").
 - Returns: converted time as a string in the format specified by the target time zone, or "<unknown>" if the conversion fails.
 */
func timeConvertFromGMTtoTimeZone(from tm: String, to timezone: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateStyle = .none
    inputFormatter.timeStyle = .medium
    inputFormatter.timeZone = .init(secondsFromGMT: 0)
    
    let outPutFormatter = DateFormatter()
    outPutFormatter.dateStyle = .none
    outPutFormatter.timeStyle = .medium
    outPutFormatter.timeZone = TimeZone(identifier: timezone)
    
    if let time = inputFormatter.date(from: tm) {
        return outPutFormatter.string(from: time)
    }
    return "<unknown>"
}
