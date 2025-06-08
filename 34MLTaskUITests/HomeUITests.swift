//
//  HomeUITests.swift
//  MLTaskTests
//
//  Created by Moustafa Mohamed Gadallah on 12/12/1446 AH.
//

import XCTest

final class HomeUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

   // simple UI Test to check scrolling enabled
    
    func testHomeViewLoadsAndScrolls() {
      
        XCTAssertTrue(app.scrollViews.firstMatch.exists, "Scroll view should exist")

        
        let firstCell = app.scrollViews.children(matching: .other).firstMatch
        if firstCell.exists {
            firstCell.swipeUp()
        }
    }


}
