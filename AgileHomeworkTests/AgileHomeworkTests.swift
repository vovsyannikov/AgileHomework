//
//  AgileHomeworkTests.swift
//  AgileHomeworkTests
//
//  Created by Виталий Овсянников on 27.11.2020.
//

import XCTest
@testable import AgileHomework

class AgileHomeworkTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        // Login checks
        let logins: [(login: String, result: Bool)] = [
            ("timmyNoScopes@yahoo.com", true),
            ("adaw", false),
            ("a@.ru", false),
            ("@google.su", false),
            ("I'm not an email", false),
            ("this.email.is.incorrect@ya.r", false),
            ("true.email@rambler.com", true)
        ]
        
        for (login, res) in logins {
            let actualResult = Authentication.loginIsCorrect(for: login)
            XCTAssert(actualResult == res, "\(login) has to be \(res) and actually \(actualResult)")
        }
        
        // Password checks
        let passwords: [(pass: String, result: [PasswordError]) ] = [
            ("5yAdgy",      []),
            ("123asda",     [.noUpperCaseLetter]),
            ("h90T",        [.tooShort]),
            ("yhfGt2jayw",  []),
            ("HDJUTSVG",    [.noNumber, .noLowerCaseLetter])
        ]
        
        for (pass, res) in passwords {
            XCTAssert(Authentication.passwordIsStrong(for: pass) == res)
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
