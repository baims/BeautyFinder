//
//  BeautyFinderUITests.swift
//  BeautyFinderUITests
//
//  Created by Bader Alrshaid on 1/8/16.
//  Copyright © 2016 Baims. All rights reserved.
//

import XCTest

class BeautyFinderUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testUntilBookingPage()
    {
        let app = XCUIApplication()
        let cells = app.collectionViews.cells
        cells.elementBoundByIndex(0).tap()
        cells.elementBoundByIndex(0).tap()
        app.tables.cells.elementBoundByIndex(0).tap()
        cells.elementBoundByIndex(0).tap()
        app.tables.cells.elementBoundByIndex(0).tap()
    }
    
    func testSearchByArea()
    {
        
        let app = XCUIApplication()
        app.tabBars.buttons["Search"].tap()
        app.staticTexts["Area"].tap()
        app.navigationBars["BeautyFinder.SearchView"].textFields["Search"].typeText("M")
        app.collectionViews.cells.otherElements.containingType(.StaticText, identifier:"Bader Salon").childrenMatchingType(.Image).element.tap()
        
    }
}
