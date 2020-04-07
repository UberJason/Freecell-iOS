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
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launchArguments = ["-usePreconfiguredBoard"]
        app.launch()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGameplay() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        snapshot("initialScreen")
        app.tapCard("♦️A")
        app.tapCard("♠️6")
        app.tapCard("♦️5")
        app.tapCard("♠️8")
        app.tapCard("♣️7")
        app.tapCard("♠️9")
        app.tapCard("♣️7")
        app.tapCard("❤️6")
        app.tapCard("❤️4")
        app.tapCard("❤️7")
        app.tapCard("❤️6")
        app.tapCard("♦️6")
        app.tapCard("♣️10")
        app.tapCard("♦️8")
        app.tapCard("♣️7")
        app.tapCard("♠️4")
        app.tapCard("♠️Q")
        app.tapCard("♦️10")
        snapshot("laterScreen")
        app.tapCard("❤️4")
        app.tapCard("♠️3")
        app.tapCard("❤️5")
        app.tapCard("♠️5")
        app.tapCard("❤️4")
        app.tapCard("♠️7")
        app.tapCard("♦️K")
        app.tapCard("❤️10")
        app.tapCard("❤️10")
        app.tapCard("❤️K")
        app.tapCard("♣️6")
        app.tapCard("❤️J")
        app.tapCard("♣️6")
        app.tapCard("❤️5")
        app.tapCard("♦️9")
        app.tapCard("♠️J")
        app.dragCard("♠️K", to: "column-3")
        app.tapCard("♦️Q")
        app.tapCard("♣️9")
        app.tapCard("❤️Q")
        app.tapCard("♣️J")
        app.tapCard("♣️10")
        app.tapCard("❤️9")
        app.tapCard("♣️K")
        app.tapCard("♦️J")
        
        let newGameButton = app.buttons["New Game"]
        guard newGameButton.waitForExistence(timeout: 5.0) else { XCTFail(); return }
        snapshot("victoryScreen")
        newGameButton.tap()
        
    }

    func testMenuControls() {
        // This is not really a test.
        let app = XCUIApplication()
        
        let menuButton = app.buttons["Menu"]
        menuButton.tap()
        
        let table = app.tables
        table.buttons["System"].tap()
        table.buttons["Light"].tap()
        table.buttons["Dark"].tap()
        
        table.buttons["Control Scheme"].tap()
        table.buttons["Classic"].tap()
        var backButton = app.navigationBars["Control Style"].buttons["Menu"]
        backButton.tap()
        
        table.buttons["Control Scheme"].tap()
        table.buttons["Modern"].tap()
        backButton.tap()
        
        table.buttons["Statistics"].tap()
        backButton = app.navigationBars["Statistics"].buttons["Menu"]
        backButton.tap()
        
        app.navigationBars["Menu"].buttons["Done"].tap()
    }
}

extension XCUIApplication {
    func tapCard(_ title: String) {
        staticTexts["\(title)-tab"].tap()
    }
    
    func dragCard(_ fromTitle: String, to elementTitle: String) {
        staticTexts["\(fromTitle)-tab"].press(forDuration: 0.1, thenDragTo: staticTexts[elementTitle])
    }
}
