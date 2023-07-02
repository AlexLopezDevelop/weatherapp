//
//  weatherappTests.swift
//  weatherappTests
//
//  Created by Alex Lopez on 28/6/23.
//

import XCTest
@testable import weatherapp

final class weatherappTests: XCTestCase {
    
    func testConvertUnixDateTimeToHuman() {
        let timestamp = 1688026665
        
        let result = convertUnixDateTimeToHuman(timestamp: timestamp)
        
        XCTAssertEqual(result, "10 AM")
    }
    
    func testWrongFormatConvertUnixDateTimeToHuman() {
        let timestamp = -10
        
        let result = convertUnixDateTimeToHuman(timestamp: timestamp)
        
        XCTAssertNil(result)
    }
}
