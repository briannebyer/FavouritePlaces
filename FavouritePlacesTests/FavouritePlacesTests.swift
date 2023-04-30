//
//  FavouritePlacesTests.swift
//  FavouritePlacesTests
//
//  Created by Brianne Byer on 26/4/2023.
//

import XCTest
@testable import FavouritePlaces

class FavouritePlacesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /**
    This test checks the navigation flow of the app. It creates instances of ContentView, SearchView, and DetailView with a newly created NSManagedObjectContext instance. Then it checks that each view's body property is not nil.

    - Throws: An error if the test fails.
    - Returns: Void.
    */
    func testNavigation() throws {
        let contentView = ContentView()
        let searchView = SearchView(locationName: "test", viewContext: contentView.viewContext)
        let detailView = DetailView(place: Place(context: contentView.viewContext))

        XCTAssertNotNil(contentView.body)
        XCTAssertNotNil(searchView.body)
        XCTAssertNotNil(detailView.body)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
