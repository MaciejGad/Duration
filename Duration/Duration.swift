//
//  Duration.swift
//  Duration
//
//  Created by Maciej Gad on 05/03/2019.
//  Copyright © 2019 MaciejGad. All rights reserved.
//

import Foundation


public struct Duration:Codable {
    public var timeInterval:TimeInterval
    
    static var calendar:Calendar = Calendar.current
    static var timeZone:TimeZone = TimeZone.current
    
    private let dateComponents:DateComponents
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let textValue = try container.decode(String.self)
        guard textValue.hasPrefix("P") else {
            throw Errors.notBeginWithP
        }
        var timeInterval:TimeInterval = 0
        var numberValue:String = ""
        let numbers = Set("0123456789.,")
        var isTimePart = false
        
        var dateComponents = DateComponents(calendar: Duration.calendar, timeZone: Duration.timeZone, era: nil, year: 0, month: 0, day: 0, hour: 0, minute: 0, second: 0, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        
        func addTimeInterval(base:Component) {
            guard let value = Double(numberValue.replacingOccurrences(of: ",", with: ".")) else {
                numberValue = ""
                return
            }
            timeInterval += value * base.timeInterval()
            numberValue = ""
            
            let components = base.value(duration: value)
            for component in components {
                var currentValue = dateComponents.value(for: component.component) ?? 0
                currentValue += component.duration
                dateComponents.setValue(currentValue, for: component.component)
            }
            
        }
        
        for char in textValue {
            switch char {
            case "P":
                continue
            case "T":
                isTimePart = true
            case _ where numbers.contains(char):
                numberValue.append(char)
            case "D":
                addTimeInterval(base: .day)
            case "Y":
                addTimeInterval(base: .year)
            case "M":
                if isTimePart {
                    addTimeInterval(base: .minute)
                } else {
                    addTimeInterval(base: .month)
                }
            case "W":
                addTimeInterval(base: .week)
            case "H":
                if isTimePart {
                    addTimeInterval(base: .hour)
                } else {
                    throw Errors.timePartNotBeginWithT
                }
            case "S":
                if isTimePart {
                    addTimeInterval(base: .second)
                } else {
                    throw Errors.timePartNotBeginWithT
                }
            default:
                throw Errors.unknownElement
            }
        }
        if numberValue.count > 0 {
            throw Errors.discontinuous
        }
        self.timeInterval = timeInterval
        self.dateComponents = dateComponents
    }
    
    func timeIntervalFrom(date:Date) -> TimeInterval {
        return endDate(starting: date).timeIntervalSince(date)
        
    }
    
    func endDate(starting date:Date) -> Date {
        guard let endDate = Duration.calendar.date(byAdding: dateComponents, to: date) else {
            return date.addingTimeInterval(timeInterval)
        }
        //print(endDate.timeIntervalSince1970)
        return endDate
    }
    
    func timeIntervalFromNow() -> TimeInterval {
        return timeIntervalFrom(date: Date())
    }
    
    func timeIntervalTo(date:Date) -> TimeInterval {
        return date.timeIntervalSince(startDate(ending: date))
    }
    
    func startDate(ending date:Date) -> Date {
        guard let startDate = Duration.calendar.date(byAdding: dateComponents.reverse(), to: date) else {
            return date.addingTimeInterval(-timeInterval)
        }
//        print(startDate.timeIntervalSince1970)
        return startDate
    }
    
    func timeIntervalToNow() -> TimeInterval {
        return timeIntervalTo(date: Date())
    }
    
    enum Errors:Error {
        case notBeginWithP
        case timePartNotBeginWithT
        case unknownElement
        case discontinuous

    }
}

extension DateComponents {
    func reverse() -> DateComponents {
        return DateComponents(calendar: self.calendar, timeZone: self.timeZone, era: nil, year: -(self.year ?? 0), month: -(self.month ?? 0), day:  -(self.day ?? 0), hour: -(self.hour ?? 0), minute:  -(self.minute ?? 0), second: -(self.second ?? 0), nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
    }
}

