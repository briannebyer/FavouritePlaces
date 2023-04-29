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
        "Name: \(self.strName) (Detail: \(self.strDesc))"
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


func saveData() {
    let ctx = PersistenceController.shared.container.viewContext
    do {
        try ctx.save()
    }catch {
        print("Error to save with \(error)")
    }
}
