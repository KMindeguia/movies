//
//  appsnap.swift
//  appsnap
//
//  Created by Bastien Cojan on 27/12/2016.
//  Copyright © 2016 iKode Ltd. All rights reserved.
//

import XCTest

class appsnap: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
//        SWHttpTrafficRecorder.shared().recordingFormat = SWHTTPTrafficRecordingFormat.mocktail
//        do {
//            try SWHttpTrafficRecorder.shared().startRecording(atPath: "/Users/bastien/Desktop/moktails")
//        }
//        catch let error as NSError {
//            print(error.localizedDescription)
//        }

        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments = ["Appsnap_stubbing"] ;
        setupSnapshot(app)
        app.launch()
        snapshot("launch")

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        snapshot("end")
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        let cells = app.tables.cells
        cells.element(boundBy: 0).tap()
        
        snapshot("Rogue One: a star wars story")
        
        let tablesQuery = app.tables
        // tap first element
        tablesQuery.children(matching: .button).element.tap()
        
        app.swipeUp()
        
        snapshot("Rogue One_ bottom screen")
        
        //related movies
        XCUIApplication().tables.cells.containing(.staticText, identifier:"View all similar movies").buttons["btn round next"].tap()
        
        snapshot("related movies")
        
        //select star wars
        app.collectionViews.children(matching: .cell).element(boundBy: 0).otherElements.children(matching: .image).element(boundBy: 0).tap()
        
        snapshot("star wars episode IV: a new hope")
        
        //back to similar movies
        
        app.buttons["back icon"].tap()
        
        snapshot("back to similar movies")
        
        app.navigationBars["Similar Movies"].children(matching: .button).element(boundBy: 0).tap()
        
        snapshot("back to Rogue on: a star wars story")
        
        //back
        app.buttons["back icon"].tap()
        
        snapshot("home screen")
        
        app.swipeUp()
        
        snapshot("home screen bottom")
    }
    
}
