//
//  FreecellUITests.swift
//  FreecellUITests
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import XCTest

class FreecellUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        setupSnapshot(app)
        app.launchArguments += ["-uiTesting"]
        app.launchArguments += ["-usePreconfiguredBoard"]
        app.launch()
        
        continueAfterFailure = false
        
        app.setSystemTheme()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGameplayLightMode() {
        // UI tests must launch the application that they test.
        app.setLightTheme()
        
        runGameWithSnapshots(in: app)
        
        app.setSystemTheme()
    }
    
    func testGameplayDarkMode() {
        app.setDarkTheme()
        
        runGameWithSnapshots(in: app)
        
        app.setSystemTheme()
    }
    
    func testMenuControls() {
        // This is not really a test.
        app.setLightTheme()
        
        let menuButton = app.buttons["Menu"]
        menuButton.tap()
        snapshot("4-menuScreen")
        
        let table = app.tables
        table.buttons["Control Scheme"].tap()
        table.buttons["Classic"].tap()
        snapshot("5-controlsScreen")
        var backButton = app.navigationBars["Control Style"].buttons["Menu"]
        backButton.tap()
        
        table.buttons["Control Scheme"].tap()
        table.buttons["Modern"].tap()
        backButton.tap()
        
        table.buttons["Statistics"].tap()
        backButton = app.navigationBars["Statistics"].buttons["Menu"]
        backButton.tap()
        
        app.navigationBars["Menu"].buttons["Done"].tap()
        
        app.setSystemTheme()
    }
    
    func runGameWithSnapshots(in app: XCUIApplication) {
        snapshot("1-initialScreen")
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
        snapshot("2-laterScreen")
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
        snapshot("3-victoryScreen")
        newGameButton.tap()
    }
}

extension XCUIApplication {
    func setLightTheme() {
        let menuButton = buttons["Menu"]
        menuButton.tap()
        
        let table = tables
        table.buttons["Light"].tap()
        navigationBars["Menu"].buttons["Done"].tap()
    }
    
    func setDarkTheme() {
        let menuButton = buttons["Menu"]
        menuButton.tap()
        
        let table = tables
        table.buttons["Dark"].tap()
        navigationBars["Menu"].buttons["Done"].tap()
    }
    
    func setSystemTheme() {
        let menuButton = buttons["Menu"]
        menuButton.tap()
        
        let table = tables
        table.buttons["System"].tap()
        navigationBars["Menu"].buttons["Done"].tap()
    }
    
    func tapCard(_ title: String) {
        staticTexts["\(title)-tab"].tap()
    }
    
    func dragCard(_ fromTitle: String, to elementTitle: String) {
        staticTexts["\(fromTitle)-tab"].press(forDuration: 0.1, thenDragTo: staticTexts[elementTitle])
    }
}
