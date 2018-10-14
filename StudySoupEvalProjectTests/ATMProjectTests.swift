//
//  ATMProjectTests.swift
//  StudySoupEvalProjectTests
//
//  Created by Max on 10/14/18.
//  Copyright © 2018 Max. All rights reserved.
//

import XCTest

class ATM: NSObject {
    func authorizeUser(_ user: User, _ pin: String) -> Bool {
        return true
    }
    
    func deposit(_ user: User, _ amount: Int) -> Bool {
        return true
    }
    
    func withdraw(_ user: User, _ amount: Int) -> Bool {
        return true
    }
    
    func getBalance(_ user: User) -> Int {
        return 0
    }
    
    func reset() {
        
    }
}

class User: NSObject {
    var name: String
    var pin: String
    private var lastWithdrawalTimestamp: Date = Date()
    
    init(name: String, pin: String) {
        self.name = name
        self.pin = pin
    }
    
    func setLastWithdrawalTimestamp(_ date: Date) {
        self.lastWithdrawalTimestamp = date
    }
}

let PIN = "1111"

class ATMProjectTests: XCTestCase {
    
    let atm: ATM = ATM()
    let user: User = User(name: "Rixian Bai", pin: PIN)
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if atm.authorizeUser(user, PIN) {
            atm.deposit(user, 100) // Deposit initial balance $100 to user's account for testing
            atm.reset() // Reset authorized user information
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        atm.reset()
    }
    
    func testATMAuthorization() {
        XCTAssertFalse(atm.authorizeUser(user, "1112")) // Pin is wrong, don't authorize the user
        XCTAssertTrue(atm.authorizeUser(user, PIN)) // Pin is correct, authorize the user
        atm.reset()
    }
    
    func testATMMainFunction() {
        if atm.authorizeUser(user, PIN) {
            XCTAssertNotNil(atm.getBalance(user)) // Check if user balance is retrievable
            XCTAssertTrue(atm.withdraw(user, 10)) // Check if withdrawal is possible. Current balance is 100 - 10 = $90
            XCTAssertFalse(atm.withdraw(user, 100)) // Check if negative balance is possible. 90 - 100 = $-10 is not possible
            XCTAssertTrue(atm.deposit(user, 100)) // Check if it's possible to deposit money. Current balance is 90 + 100 = $190
            XCTAssertEqual(atm.getBalance(user), 190) // Check if it's deposited properly
            atm.reset()
        }
    }
    
    func testATMBalanceNegativity() {
        if atm.authorizeUser(user, PIN) {
            atm.withdraw(user, atm.getBalance(user)) // Withdraw all the money and make user's balance zero
            XCTAssertEqual(atm.getBalance(user), 0) // Check if balance is really zero
            XCTAssertFalse(atm.withdraw(user, 10)) // Make sure balance cannot be negative
            atm.reset()
        }
    }
    
    func testATMWithdrawal() {
        if atm.authorizeUser(user, "1111") {
            atm.deposit(user, 1000) // deposit $1000
            atm.withdraw(user, 100)
            XCTAssertFalse(atm.withdraw(user, 300), "It is not allowed to withdraw more than $300 within 24 hours")
            // Set last withdrawl timestamp to 24 hours before and see if it's possible to withdraw $300
            user.setLastWithdrawalTimestamp(Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
            XCTAssertTrue(atm.withdraw(user, 300)) // Check if it is possible to withdraw $300
            atm.reset()
        }
    }
    
    // Integration testing using Mockingjay
    /*
    func testInterfaceBetweenPinCheckWebserviceAndATM() {
        let authorizationSuccessful = ["authorized": true]
        stub(http(.post, uri: "https://atm/authorize/userid/pin"), authorizationSuccessful)
        XCTAssertTrue(atm.authorizeUser(user, PIN))
        
        let authorizationFailed = ["authorized": false]
        stub(http(.post, uri: "https://atm/authorize/userid/pin"), authorizationFailed)
        XCTAssertFalse(atm.authorizeUser(user, PIN))
        
        let notFoundStub = http(404, headers: nil, data: nil)
        stub(http(.post, uri: "https://atm/authorize/userid/pin"), builder: notFoundStub)
        XCTAssertThrowsError(atm.authorizeUser(user, PIN), "404 Not found", { (error: Error) in
            XCTAssertEqual(error.localizedDescription, "user not found")
        })
        
        let serverErrorStub = http(500, headers: nil, data: "server error".data(using: .utf8))
        stub(http(.post, uri: "https://atm/authorize/userid/pin"), builder: serverErrorStub)
        XCTAssertThrowsError(atm.authorizeUser(user, PIN), "Server error", { (error: Error) in
            XCTAssertEqual(error.localizedDescription, "server error")
        })
        
        let serviceNotAvailableStub = http(503, headers: nil, data: "service not available".data(using: .utf8))
        stub(http(.post, uri: "https://atm/authorize/userid/pin"), builder: serviceNotAvailableStub)
        XCTAssertThrowsError(atm.authorizeUser(user, PIN), "Service not available", { (error: Error) in
            XCTAssertEqual(error.localizedDescription, "service not available")
        })
    }
     */
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
