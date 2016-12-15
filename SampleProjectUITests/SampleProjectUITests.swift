
//
//  SampleProjectUITests.swift
//  SampleProjectUITests
//
//  Created by Jakub Krystek on 06.12.2016.
//  Copyright © 2016 Jakub Krystek. All rights reserved.
//

import XCTest

class SampleProjectUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateAccountAndLogin() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        let app = XCUIApplication()
        let element = app.otherElements.containing(.navigationBar, identifier:"SampleProject.LoginView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let textField = element.children(matching: .textField).element
        textField.tap()
        app.buttons["Create account"].tap()
        
        let element2 = app.otherElements.containing(.navigationBar, identifier:"SampleProject.CrateAccountView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let textField2 = element2.children(matching: .textField).element
        textField2.tap()
        textField2.typeText("12345678901")
        
        let secureTextField = element2.children(matching: .secureTextField).element(boundBy: 0)
        secureTextField.tap()
        secureTextField.tap()
        secureTextField.typeText("123456")
        
        let secureTextField2 = element2.children(matching: .secureTextField).element(boundBy: 1)
        secureTextField2.tap()

        secureTextField2.typeText("123456")
        app.buttons["Subbmit"].tap()
        app.alerts["Success!"].buttons["OK"].tap()
        
        let element12 = app.otherElements.containing(.navigationBar, identifier:"SampleProject.LoginView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let textField12 = element12.children(matching: .textField).element
        textField12.tap()
        textField12.typeText("123")
        
        let secureTextField12 = element12.children(matching: .secureTextField).element
        secureTextField12.tap()
        secureTextField12.typeText("\r")
        secureTextField12.typeText("123")
        app.buttons["Log in to app"].tap()
        
        
        
    }
    
}
