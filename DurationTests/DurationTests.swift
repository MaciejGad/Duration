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
    
    let date_6_03_2019 = Date(timeIntervalSince1970: 1551867068)
    let date_25_03_2018 = Date(timeIntervalSince1970: 1521932460)
    
    override func setUp() {
        Duration.calendar = Calendar(identifier: .gregorian)
        Duration.timeZone = TimeZone(identifier: "Europe/Warsaw")!
    }

    func test1day() throws {
        //given
        let givenDurationText = "P1D"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.day)
        XCTAssertEqual(sut.duration.timeIntervalFrom(date: date_25_03_2018), TimeInterval.day - TimeInterval.hour) //change time to daylight saving
        XCTAssertEqual(sut.duration.timeIntervalTo(date: date_25_03_2018), TimeInterval.day)
        XCTAssertEqual(sut.duration.startDate(ending: date_25_03_2018).timeIntervalSince1970, 1521846060.0)
        XCTAssertEqual(sut.duration.endDate(starting: date_25_03_2018).timeIntervalSince1970, 1522015260.0)
        
    }
    
    func test1year() throws {
        //given
        let givenDurationText = "P1Y"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.year)
        XCTAssertEqual(sut.duration.timeIntervalFrom(date: date_6_03_2019), TimeInterval.day * 366) //leap-year
        XCTAssertEqual(sut.duration.timeIntervalTo(date: date_6_03_2019), TimeInterval.day * 365)
        
        XCTAssertEqual(sut.duration.startDate(ending: date_6_03_2019).timeIntervalSince1970, 1520331068.0)
        XCTAssertEqual(sut.duration.endDate(starting: date_6_03_2019).timeIntervalSince1970, 1583489468.0)
    }
    
    func test1year1day() throws {
        //given
        let givenDurationText = "P1Y1D"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.year + TimeInterval.day )
        XCTAssertEqual(sut.duration.timeIntervalFrom(date: date_6_03_2019), TimeInterval.day * 366 + TimeInterval.day) //leap-year
        XCTAssertEqual(sut.duration.timeIntervalTo(date: date_6_03_2019), TimeInterval.day * 365 + TimeInterval.day)
        
        
        XCTAssertEqual(sut.duration.startDate(ending: date_6_03_2019).timeIntervalSince1970, 1520244668.0)
        XCTAssertEqual(sut.duration.endDate(starting: date_6_03_2019).timeIntervalSince1970, 1583575868.0)
    }
    
    func test2_5years() throws {
        //given
        let givenDurationText = "P2.5Y"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.year * 2.5)
        
        XCTAssertEqual(sut.duration.timeIntervalTo(date: date_6_03_2019), 78714000)   //1551867068 - 1473153068
        XCTAssertEqual(sut.duration.timeIntervalFrom(date: date_6_03_2019), 79052400) //1630919468 - 1551867068
        
        
        XCTAssertEqual(sut.duration.startDate(ending: date_6_03_2019).timeIntervalSince1970, 1473153068.0)
        XCTAssertEqual(sut.duration.endDate(starting: date_6_03_2019).timeIntervalSince1970, 1630919468.0)
    }

    func test2_coma_5years() throws {
        //given
        let givenDurationText = "P2,5Y"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.year * 2.5)
        
        XCTAssertEqual(sut.duration.timeIntervalTo(date: date_6_03_2019), 78714000)   //1551867068 - 1473153068
        XCTAssertEqual(sut.duration.timeIntervalFrom(date: date_6_03_2019), 79052400) //1630919468 - 1551867068
        
        XCTAssertEqual(sut.duration.startDate(ending: date_6_03_2019).timeIntervalSince1970, 1473153068.0)
        XCTAssertEqual(sut.duration.endDate(starting: date_6_03_2019).timeIntervalSince1970, 1630919468.0)
    }
    
    func test1month() throws {
        //given
        let givenDurationText = "P1M"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.month)
        XCTAssertEqual(sut.duration.timeIntervalTo(date: date_6_03_2019), TimeInterval.day * 28)
        XCTAssertEqual(sut.duration.timeIntervalFrom(date: date_6_03_2019), TimeInterval.day * 31 - TimeInterval.hour) //change time to daylight saving
        
        XCTAssertEqual(sut.duration.startDate(ending: date_6_03_2019).timeIntervalSince1970, 1549447868.0)
        XCTAssertEqual(sut.duration.endDate(starting: date_6_03_2019).timeIntervalSince1970, 1554541868.0)
    }
    
    func test1_5monthAnd4days() throws {
        //given
        let givenDurationText = "P1.5M4D"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.day * (30 * 1.5 + 4))
        XCTAssertEqual(sut.duration.timeIntervalTo(date: date_6_03_2019), TimeInterval.day * (28 + 15 + 4) )
        XCTAssertEqual(sut.duration.timeIntervalFrom(date: date_6_03_2019), TimeInterval.day * (31 + 15 + 4) - TimeInterval.hour) //change time to daylight saving
        
        XCTAssertEqual(sut.duration.startDate(ending: date_6_03_2019).timeIntervalSince1970, 1547806268.0)
        XCTAssertEqual(sut.duration.endDate(starting: date_6_03_2019).timeIntervalSince1970, 1556183468.0)
    }
    
    func test0_5month() throws {
        //given
        let givenDurationText = "P0.5M"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.day * 15)
        XCTAssertEqual(sut.duration.timeIntervalTo(date: date_25_03_2018), TimeInterval.day * 15 )
        XCTAssertEqual(sut.duration.timeIntervalFrom(date: date_25_03_2018), TimeInterval.day * 15 - TimeInterval.hour) //change time to daylight saving
        
        XCTAssertEqual(sut.duration.startDate(ending: date_25_03_2018).timeIntervalSince1970, 1520636460.0)
        XCTAssertEqual(sut.duration.endDate(starting: date_25_03_2018).timeIntervalSince1970, 1523224860.0)
    }
    
    func test1week() throws {
        //given
        let givenDurationText = "P1W"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.week)
        XCTAssertEqual(sut.duration.timeIntervalTo(date: date_25_03_2018), TimeInterval.day * 7)
        XCTAssertEqual(sut.duration.timeIntervalFrom(date: date_25_03_2018), TimeInterval.day * 7 - TimeInterval.hour)  //change time to daylight saving
    }
    
    func test1hour() throws {
        //given
        let givenDurationText = "PT1H"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.hour)
        XCTAssertEqual(sut.duration.timeIntervalTo(date: date_25_03_2018), TimeInterval.hour)
        XCTAssertEqual(sut.duration.timeIntervalFrom(date: date_25_03_2018), TimeInterval.hour)
    }
    
    func test1minute() throws {
        //given
        let givenDurationText = "PT1M"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, TimeInterval.minute)
        XCTAssertEqual(sut.duration.timeIntervalTo(date: date_6_03_2019), TimeInterval.minute)
        XCTAssertEqual(sut.duration.timeIntervalFrom(date: date_6_03_2019), TimeInterval.minute)
        
        XCTAssertEqual(sut.duration.startDate(ending: date_6_03_2019).timeIntervalSince1970, 1551867008.0)
        XCTAssertEqual(sut.duration.endDate(starting: date_6_03_2019).timeIntervalSince1970, 1551867128.0)
    }
    
    func test1second() throws {
        //given
        let givenDurationText = "PT1S"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        XCTAssertEqual(sut.duration.timeInterval, 1)
        XCTAssertEqual(sut.duration.timeIntervalTo(date: date_6_03_2019), 1)
        XCTAssertEqual(sut.duration.timeIntervalFrom(date: date_6_03_2019), 1)
        
        XCTAssertEqual(sut.duration.startDate(ending: date_6_03_2019).timeIntervalSince1970, 1551867067.0)
        XCTAssertEqual(sut.duration.endDate(starting: date_6_03_2019).timeIntervalSince1970, 1551867069.0)
    }
    
    func testP3Y6M4DT12H30M5S() throws {
        
        //given
        let givenDurationText = "P3Y6M4DT12H30M5S"
        
        //when
        let sut = try decode(duration: givenDurationText)
        
        //then
        let timeInterval = TimeInterval.year * 3 + TimeInterval.month * 6 + TimeInterval.day * 4 + TimeInterval.hour * 12 + TimeInterval.minute * 30 + 5
        print(sut.duration.timeInterval)
        XCTAssertEqual(sut.duration.timeInterval, timeInterval)
        XCTAssertEqual(sut.duration.timeIntervalTo(date: date_6_03_2019), 110727005) //1551867068 - 1441140063
        XCTAssertEqual(sut.duration.timeIntervalFrom(date: date_6_03_2019), 110979005) //1662846073 - 1551867068
        
        XCTAssertEqual(sut.duration.startDate(ending: date_6_03_2019).timeIntervalSince1970, 1441140063.0)
        XCTAssertEqual(sut.duration.endDate(starting: date_6_03_2019).timeIntervalSince1970, 1662846073.0)
        
//        let startDate = sut.duration.startDate(ending: date_6_03_2019)
//        let endDate = sut.duration.endDate(starting: date_6_03_2019)
//        print("current: \(date_6_03_2019)")
//        print("start:   \(startDate) - \(startDate.timeIntervalSince1970)")
//        print("end:     \(endDate) - \(endDate.timeIntervalSince1970)")
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
