//
//  FreecellUITests.swift
//  FreecellUITests
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import XCTest

class FreecellUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments = ["-usePreconfiguredBoard"]
        app.launch()

        
        app.staticTexts["♦️A"].tap()
        app.staticTexts["♠️6"].tap()
        app.staticTexts["♦️5"].tap()
        app.staticTexts["♠️8"].tap()
        app.staticTexts["♣️7"].tap()
        app.staticTexts["♠️9"].tap()
        app.staticTexts["♣️7"].tap()
        app.staticTexts["❤️6"].tap()
        app.staticTexts["❤️4"].tap()
        app.staticTexts["❤️7"].tap()    // This is never triggered - probably because it's trying to tap on the ❤️7 in the *center* but there's another card on top of it. I wonder if we can tap specifically on the upper-left CardTab
        app.staticTexts["❤️6"].tap()
    

        
                
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }

//    func testLaunchPerformance() {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
