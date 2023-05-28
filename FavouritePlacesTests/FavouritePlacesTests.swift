//
//  FavouritePlacesTests.swift
//  FavouritePlacesTests
//
//  Created by Brianne Byer on 26/4/2023.
//

import XCTest
import MapKit

@testable import FavouritePlaces

class FavouritePlacesTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    /**
     This function validates the behaviour of the `strLat` and `strLong` properties in the `MapLocation` class.
     */
    func testStrLatLong() throws {
        let model = MapLocation.shared
        
        // set the latitude string value to "45" and check if it matches the expected value "45.00000"
        model.mlatStr = "45"
        // the format should be at least 5 decimal places
        XCTAssert(model.mlatStr == "45.00000")
        
        model.mlongStr = "179"
        XCTAssert(model.mlongStr == "179.00000")
    }

    /**
     This function validates the behavior of updating and setting up the `region` property in the `MapLocation` class.
     */
    func testUpdateFromRegionAndSetupRegion() throws {
        // creates instance of "MapLocation" class
        let mapLocation = MapLocation.shared
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        //updates the latitude and longitude based on region
        mapLocation.region = region
        mapLocation.updateFromRegion()

        // if assertions fail, it indicates that the update process of the region property in the MapLocation class is incorrect
        XCTAssertEqual(mapLocation.latitude, 40.7128)
        XCTAssertEqual(mapLocation.longitude, -74.0060)
        // sets up region
        mapLocation.setupRegion()

        // if assertions fail, it indicates that the center of the region is incorrect for said long and lat
        XCTAssertEqual(mapLocation.region.center.latitude, 40.7128)
        XCTAssertEqual(mapLocation.region.center.longitude, -74.0060)
    }
}
