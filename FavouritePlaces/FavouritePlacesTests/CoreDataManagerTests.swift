//
//  CoreDataManagerTests.swift
//  FavouritePlacesTests
//
//  Created by Ramanjaneyulu Kodurion on 10/05/22.
//

import XCTest
@testable import FavouritePlaces

class CoreDataManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddItem() {
        let id = UUID()
        let favouritePlaceDataModel = FavouritePlaceDataModel(id: id, imageURL: "", latitude: "", location: "Sydney", enterLocationDetailsText: "", locationDescription: "", longitude: "")
        CoreDataManager.shared.addItem(favouritePlaceDataModel: favouritePlaceDataModel)
        var isElementAdded = false
        if let getFavouriteModel =  CoreDataManager.shared.getFavouritePlaceModels() {
            for model in getFavouriteModel {
                if model.id == id {
                    isElementAdded = true
                }
            }
            
        }
        if isElementAdded {
            XCTAssert(isElementAdded, "Successfully added item")
        } else {
            XCTAssert(isElementAdded, "Failed to add item")
        }
    }
    
    func testConvertDataModelToCoreDataModel() {
        let id = UUID()
        let favouritePlaceDataModel = FavouritePlaceDataModel(id: id, imageURL: "", latitude: "", location: "Sydney", enterLocationDetailsText: "", locationDescription: "", longitude: "")
        
        let convertedModel = CoreDataManager.shared.convertDataModelToCoreDataModel(favouritePlaceDataModel: favouritePlaceDataModel)
        
        XCTAssertEqual(favouritePlaceDataModel.id, convertedModel.id, "Model converted")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
