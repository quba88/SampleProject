//
//  SampleProjectTests.swift
//  SampleProjectTests
//
//  Created by Jakub Krystek on 06.12.2016.
//  Copyright © 2016 Jakub Krystek. All rights reserved.
//

import XCTest
@testable import SampleProject

class SampleProjectTests: XCTestCase {
    let rsaTest = RSA()
    
    override func setUp() {
        super.setUp()
        self.rsaTest.generateKeys()

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateAccount(){
        XCTAssertTrue(try KeychainWrapper.createAccount(login: "123321", password: "123"))
        XCTAssertThrowsError(try KeychainWrapper.createAccount(login: "123321", password: "123"))
        XCTAssertThrowsError(try KeychainWrapper.createAccount(login: "", password: "123"))
        XCTAssertThrowsError(try KeychainWrapper.createAccount(login: "123321", password: ""))
    }
    
    func testDeleteAccount()  {
        XCTAssertTrue(try KeychainWrapper.deleteAccount(login: "123321"))
        XCTAssertThrowsError(try KeychainWrapper.deleteAccount(login: "123321"))
    }
    
    func testValidateUserAccess() {
        
        XCTAssertTrue(try KeychainWrapper.validateUserAccess(login: "123", password: "123"))
        XCTAssertFalse(try KeychainWrapper.validateUserAccess(login: "123", password: "12dd3"))
        XCTAssertThrowsError(try KeychainWrapper.validateUserAccess(login: "", password: "4564"))
        XCTAssertThrowsError(try KeychainWrapper.validateUserAccess(login: "212132", password: ""))
        XCTAssertThrowsError(try KeychainWrapper.validateUserAccess(login: "aaaaaaaaaa", password: "4564"))
    }
    
    func testEncryptTextText(){
        let text = "Lw 35_643+1234?"
        let textToDecrypt = self.rsaTest.encryptValue(value: text)
        
        XCTAssertFalse(textToDecrypt == text)
        
        let textEncripted = self.rsaTest.decryptValue(value: textToDecrypt)
        print(textToDecrypt)
        XCTAssertTrue(textEncripted == text, "not equail \(text) == \(textEncripted)")

    }
    
}
