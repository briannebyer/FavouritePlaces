//
//  ViewModel.swift
//  FavouritePlaces
//
//  Created by Brianne Byer on 26/4/2023.
//

import Foundation
import CoreData
import SwiftUI


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
}


func saveData() {
    let ctx = PersistenceController.shared.container.viewContext
    do {
        try ctx.save()
    }catch {
        print("Error to save with \(error)")
    }
}

//func saveContext() {
//    do {
//        try viewContext.save()
//    } catch {
//        let error = error as NSError
//        fatalError("An error occured during save: \(error)")
//    }
//}
