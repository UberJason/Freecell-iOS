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

        app.staticTexts["♦️A-tab"].tap()
        app.staticTexts["♠️6-tab"].tap()
        app.staticTexts["♦️5-tab"].tap()
        app.staticTexts["♠️8-tab"].tap()
        app.staticTexts["♣️7-tab"].tap()
        app.staticTexts["♠️9-tab"].tap()
        app.staticTexts["♣️7-tab"].tap()
        app.staticTexts["❤️6-tab"].tap()
        app.staticTexts["❤️4-tab"].tap()
        app.staticTexts["❤️7-tab"].tap()
        app.staticTexts["❤️6-tab"].tap()
        app.staticTexts["♦️6-tab"].tap()
        app.staticTexts["♣️10-tab"].tap()
        app.staticTexts["♦️8-tab"].tap()
        app.staticTexts["♣️7-tab"].tap()
        app.staticTexts["♠️4-tab"].tap()
        app.staticTexts["♠️Q-tab"].tap()
        app.staticTexts["♦️10-tab"].tap()
        app.staticTexts["❤️4-tab"].tap()
        app.staticTexts["♠️3-tab"].tap()
        app.staticTexts["❤️5-tab"].tap()
        app.staticTexts["♠️5-tab"].tap()
        app.staticTexts["❤️4-tab"].tap()
        app.staticTexts["♠️7-tab"].tap()
        app.staticTexts["♦️K-tab"].tap()
        app.staticTexts["❤️10-tab"].tap()
        app.staticTexts["❤️10-tab"].tap()
        app.staticTexts["❤️K-tab"].tap()
        app.staticTexts["♣️6-tab"].tap()
        app.staticTexts["❤️J-tab"].tap()
        app.staticTexts["♣️6-tab"].tap()
        app.staticTexts["❤️5-tab"].tap()
        app.staticTexts["♦️9-tab"].tap()
        app.staticTexts["♠️J-tab"].tap()
        app.staticTexts["♠️K-tab"].press(forDuration: 0.1, thenDragTo: app.staticTexts["column-3"])
        app.staticTexts["♦️Q-tab"].tap()
        app.staticTexts["♣️9-tab"].tap()
        app.staticTexts["❤️Q-tab"].tap()
        app.staticTexts["♣️J-tab"].tap()
        app.staticTexts["♣️10-tab"].tap()
        app.staticTexts["❤️9-tab"].tap()
        app.staticTexts["♣️K-tab"].tap()
        app.staticTexts["♦️J-tab"].tap()
        
        let newGameButton = app.buttons["New Game"]
        guard newGameButton.waitForExistence(timeout: 5.0) else { XCTFail(); return }
        newGameButton.tap()
    }

}
