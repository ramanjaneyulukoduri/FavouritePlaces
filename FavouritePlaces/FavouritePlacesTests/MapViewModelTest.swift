//
//  MapViewModelTest.swift
//  FavouritePlacesTests
//
//  Created by Ajay Girolkar on 18/05/22.
//

import XCTest
@testable import FavouritePlaces

class MapViewModelTest: XCTestCase {
    
    var mapViewViewModel: MapViewViewModel?

    override func setUpWithError() throws {
        mapViewViewModel = MapViewViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    @MainActor func testSyncDataFromModel() {
        guard let mapViewViewModel = mapViewViewModel else { return }
        let favouritePlaceModel = FavouritePlaceDataModel(id: UUID(), imageURL: "", location: "Test Location",
                                                          enterLocationDetailsText: "TestModel", locationDescription: "", latitude: "30", longitude: "20")
        
        mapViewViewModel.favouritePlaceModel = favouritePlaceModel
        mapViewViewModel.favouritePlaceObservableModel = FavouritePlaceObservableModel()
        
        mapViewViewModel.syncDataFromModel()
        XCTAssertEqual(mapViewViewModel.latitudeTextField, "30")
        XCTAssertEqual(mapViewViewModel.longitudeTextField, "20")
    }
    
    @MainActor func testSyncMasterModel() {
        guard let mapViewViewModel = mapViewViewModel else { return }
        let favouritePlaceModel = FavouritePlaceDataModel(id: UUID(), imageURL: "", location: "Test Location",
                                                          enterLocationDetailsText: "TestModel", locationDescription: "",
                                                          latitude: "30.0", longitude: "20.0")
        
        mapViewViewModel.favouritePlaceModel = favouritePlaceModel
        mapViewViewModel.favouritePlaceObservableModel = FavouritePlaceObservableModel()
        
        mapViewViewModel.syncDataFromModel()
        mapViewViewModel.syncMasterModel(completion: {
        })
        XCTAssertEqual(favouritePlaceModel.latitude, "\(mapViewViewModel.region.center.latitude)")
        XCTAssertEqual(favouritePlaceModel.longitude, "\(mapViewViewModel.region.center.longitude)")
    }
}
