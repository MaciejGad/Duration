//
//  Duration.swift
//  Duration
//
//  Created by Maciej Gad on 05/03/2019.
//  Copyright © 2019 MaciejGad. All rights reserved.
//

import Foundation


public struct Duration: Codable {

    public var timeInterval: TimeInterval

    public static var calendar: Calendar = Calendar.current {
        didSet {
            calendar.timeZone = timeZone
        }
    }

    public static var timeZone: TimeZone = TimeZone.current {
        didSet {
            calendar.timeZone = timeZone
        }
    }

    private let dateComponents: DateComponents
    private let originalValue: String

    public init(string value: String) throws {
        guard value.hasPrefix("P") else {
            throw Errors.notBeginWithP
        }
        originalValue = value
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
        
        for char in value {
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        try self.init(string: value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(originalValue)
    }
    
    public func timeIntervalFrom(date:Date) -> TimeInterval {
        return endDate(starting: date).timeIntervalSince(date)
        
    }
    
    public func endDate(starting date:Date) -> Date {
        guard let endDate = Duration.calendar.date(byAdding: dateComponents, to: date) else {
            return date.addingTimeInterval(timeInterval)
        }
        return endDate
    }
    
    public func timeIntervalFromNow() -> TimeInterval {
        return timeIntervalFrom(date: Date())
    }
    
    public func timeIntervalTo(date:Date) -> TimeInterval {
        return date.timeIntervalSince(startDate(ending: date))
    }
    
    public func startDate(ending date:Date) -> Date {
        guard let startDate = Duration.calendar.date(byAdding: dateComponents.reverse(), to: date) else {
            return date.addingTimeInterval(-timeInterval)
        }
        return startDate
    }
    
    public func timeIntervalToNow() -> TimeInterval {
        return timeIntervalTo(date: Date())
    }
    
    public enum Errors:Error {
        case notBeginWithP
        case timePartNotBeginWithT
        case unknownElement
        case discontinuous

    }
}

extension Duration: CustomStringConvertible {
    public var description: String {
        return "Duration(\(originalValue))"
    }
}

extension DateComponents {
    func reverse() -> DateComponents {
        return DateComponents(calendar: self.calendar, timeZone: self.timeZone, era: nil, year: -(self.year ?? 0), month: -(self.month ?? 0), day:  -(self.day ?? 0), hour: -(self.hour ?? 0), minute:  -(self.minute ?? 0), second: -(self.second ?? 0), nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
    }
}

