//
//  DurationTests.swift
//  DurationTests
//
//  Created by Maciej Gad on 05/03/2019.
//  Copyright © 2019 MaciejGad. All rights reserved.
//

import XCTest
@testable import Duration

class DurationTests: XCTestCase {

    func test1day() throws {
        //given
        let givenDurationText = "P1D"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.day)
    }
    
    func test1year() throws {
        //given
        let givenDurationText = "P1Y"

        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.year )
    }
    
    func test1year1day() throws {
        //given
        let givenDurationText = "P1Y1D"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.year + TimeInterval.day )
    }
    
    func test2_5years() throws {
        //given
        let givenDurationText = "P2.5Y"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.year * 2.5)
    }

    func test2_coma_5years() throws {
        //given
        let givenDurationText = "P2,5Y"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.year * 2.5)
    }
    
    func test1month() throws {
        //given
        let givenDurationText = "P1M"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.day * 30)
    }
    
    func test1week() throws {
        //given
        let givenDurationText = "P1W"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.week)
    }
    
    func test1hour() throws {
        //given
        let givenDurationText = "PT1H"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.hour)
    }
    
    func test1minute() throws {
        //given
        let givenDurationText = "PT1M"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.minute)
    }
    
    func test1second() throws {
        //given
        let givenDurationText = "PT1S"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, 1)
    }
    
    func testP3Y6M4DT12H30M5S() throws {
        
        //given
        let givenDurationText = "P3Y6M4DT12H30M5S"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        let timeInterval = TimeInterval.year * 3 + TimeInterval.day * 30 * 6 + TimeInterval.day * 4 + TimeInterval.hour * 12 + TimeInterval.minute * 30 + 5
        XCTAssertEqual(sut.duration.timeInterval, timeInterval)
    }
    
    func testNo_P_atBeginThrows() {
        XCTAssertThrowsError(try decode(duration: "1DT3H"))
    }
    
    func testNo_T_atBeginOfTimeThrows() {
        XCTAssertThrowsError(try decode(duration: "P3H"))
        XCTAssertThrowsError(try decode(duration: "P3S"))
    }
    
    func testUnknownElement() {
        XCTAssertThrowsError(try decode(duration: "P3H T1H"))
    }
    
    func testDiscontinuous() {
        XCTAssertThrowsError(try decode(duration: "P3H T1"))
    }
    
    
    private func decode(duration:String) throws -> Box {
        let data = Data(bytes: "{\"duration\":\"\(duration)\"}".utf8)
        let decoder = JSONDecoder()
        return try decoder.decode(Box.self, from: data)
    }
}

struct Box:Codable {
    let duration:Duration
}
